//
//  SectionHeaderView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/2/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol FBSectionHeaderDelegate: class
{
    func editSelected(section:Int)
    func saveSelected(section:Int)
    func cancelSelected(section:Int)
    func collapse(section:Int)
    func expand(section:Int)
    func addItem(section:Int, type:FBFieldType)
    func removeItem(indexPath:IndexPath, type:FBFieldType)
}

open class FBSectionHeaderView: UIView
{
    @IBOutlet var backgroundView:UIView?
    @IBOutlet var editButton:UIButton?
    @IBOutlet var cancelButton:UIButton?
    @IBOutlet var collapseButton:UIButton?
    @IBOutlet var label:UILabel?
    @IBOutlet var addButton:UIButton?
    @IBOutlet var removeButton:UIButton?
    var collapsible:Bool = false
    var collapsed:Bool = false
    var allowsAdd:Bool = false
    var allowsRemove:Bool = false
    var addItems:Array<String> = Array<String>()
    var index:Int?
    var section:FBSection?
    var style:FBStyleClass?
    weak var delegate:FBSectionHeaderDelegate?
    
    open func updateDisplay(index:Int, section:FBSection)
    {
        let bundle = Bundle.init(for: self.classForCoder)
        section.headerView = self
        self.section = section
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: "#SectionHeader")!)
        self.style!.parent = FBStyleSet.shared.style(named: "#Section")
        self.backgroundColor = UIColor.init(hexString: self.style!.value(forKey: "border-color") as! String)
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.init(hexString: self.style!.value(forKey: "background-color") as! String)
        self.addSubview(self.backgroundView!)
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.label?.font = UIFont(name: self.style!.value(forKey: "font-family") as! String,
                                  size: self.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.style!.value(forKey: "foreground-color") as! String)
        self.label?.text = section.title ?? ""
        self.label?.sizeToFit()
        self.backgroundView?.addSubview(self.label!)
        self.index = index
        self.collapsible = section.collapsible
        if (self.collapsible)
        {
            self.collapsed = section.collapsed
            self.collapseButton = UIButton()
            if (self.collapsed)
            {
                self.collapseButton?.setImage(UIImage.init(named: "right", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
            else
            {
                self.collapseButton?.setImage(UIImage.init(named: "down", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
            self.collapseButton?.addTarget(self, action: #selector(collapsePressed), for: UIControlEvents.touchUpInside)
            self.backgroundView?.addSubview(self.collapseButton!)
        }
        self.allowsAdd = section.allowsAdd
        if (self.allowsAdd)
        {
            self.addButton = UIButton()
            self.addButton?.setImage(UIImage.init(named: "plus", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            self.addButton?.addTarget(self, action: #selector(addPressed), for: UIControlEvents.touchUpInside)
            self.backgroundView?.addSubview(self.addButton!)
        }
        self.allowsRemove = section.allowsRemove
        if (self.allowsRemove)
        {
            self.removeButton = UIButton()
            self.removeButton?.setImage(UIImage.init(named: "minus", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            self.removeButton?.addTarget(self, action: #selector(removePressed), for: UIControlEvents.touchUpInside)
            self.backgroundView?.addSubview(self.removeButton!)
        }
        if (self.section?.editable == true)
        {
            self.editButton = UIButton()
            if (self.section!.mode == FBFormMode.View)
            {
                self.editButton?.setImage(UIImage.init(named: "edit", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
            else
            {
                self.editButton?.setImage(UIImage.init(named: "save", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
            self.editButton?.addTarget(self, action: #selector(editPressed), for: UIControlEvents.touchUpInside)
            self.backgroundView?.addSubview(self.editButton!)
            self.cancelButton = UIButton()
            self.cancelButton?.setImage(UIImage.init(named: "cancel", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            self.cancelButton?.addTarget(self, action: #selector(cancelPressed), for: UIControlEvents.touchUpInside)
            self.backgroundView?.addSubview(self.cancelButton!)
            if (self.section!.mode == FBFormMode.Edit)
            {
                self.cancelButton!.isHidden = false
            }
            else
            {
                self.cancelButton!.isHidden = true
            }
        }
        for item in section.fieldsToAdd
        {
            self.addItems.append(self.stringFrom(field: item))
        }
    }

    private func stringFrom(field:FBFieldType) -> String
    {
        switch (field)
        {
        case FBFieldType.Section:
            return "Section"
        case FBFieldType.Image:
            return "Image"
        case FBFieldType.Label:
            return "Label"
        case FBFieldType.Signature:
            return "Signature"
        default:
            return ""
        }
    }
    
    private func fieldFrom(string:String) -> FBFieldType
    {
        switch (string.lowercased())
        {
        case "section":
            return FBFieldType.Section
        case "image":
            return FBFieldType.Image
        case "label":
            return FBFieldType.Label
        case "signature":
            return FBFieldType.Signature
        default:
            return FBFieldType.Image
        }
    }
    
    func height() -> CGFloat
    {
        var labelHeight:CGFloat = self.labelHeight()
        if (labelHeight < 30.0)
        {
            labelHeight = 30.0
        }
        return (self.marginWidth() * 2) + labelHeight + self.borderWidth()
    }

    override open func layoutSubviews()
    {
        let border:CGFloat = self.style?.value(forKey: "border") as! CGFloat
        let margin:CGFloat = self.style?.value(forKey: "margin") as! CGFloat

        self.backgroundView?.frame = CGRect(x: border, y: 0.0, width: self.frame.width - (border * 2.0), height: self.frame.height - border)
        if (self.collapsible)
        {
            self.collapseButton!.frame = CGRect(x: margin + border, y: (self.frame.height / 2) - 15.0, width: 30.0, height: 30.0)
        }
        var left:CGFloat = margin
        if (self.collapsible)
        {
            left += 30.0 + margin
        }
        self.label!.frame = CGRect(x:left, y:(self.frame.height / 2) - (labelHeight() / 2), width:self.labelWidth(), height: self.labelHeight())
        if (self.allowsAdd)
        {
            self.addButton!.frame = CGRect(x: self.frame.width - (border + margin + 30.0), y: (self.frame.size.height / 2) - 15.0, width: 30.0, height: 30.0)
        }
        if (self.allowsRemove)
        {
            self.removeButton!.frame = CGRect(x: self.frame.width - (border + (margin * 2) + 60.0), y: (self.frame.size.height / 2) - 15.0, width: 30.0, height: 30.0)
        }
        if (self.section?.editable == true)
        {
            var buttonOffset:CGFloat = 30.0
            if (self.allowsAdd)
            {
                buttonOffset += 30.0 + margin
            }
            if (self.allowsRemove)
            {
                buttonOffset += 30.0 + margin
            }
            self.editButton!.frame = CGRect(x: self.frame.width - (border + margin + buttonOffset), y: (self.frame.size.height / 2) - 15.0, width: 30.0, height: 30.0)
            self.cancelButton!.frame = CGRect(x: self.frame.width - (border + margin + buttonOffset + 30.0 + margin), y: (self.frame.size.height / 2) - 15.0, width: 30.0, height: 30.0)
        }
    }
    
    func borderWidth() -> CGFloat
    {
        if (self.style == nil) { return 0.0 }
        return self.style?.value(forKey: "border") as! CGFloat
    }
    
    func marginWidth() -> CGFloat
    {
        if (self.style == nil) { return 0.0 }
        return self.style?.value(forKey: "margin") as! CGFloat
    }
    
    func labelWidth() -> CGFloat
    {
        var width:CGFloat = self.backgroundView!.frame.size.width - ((self.marginWidth() * 2) + (self.borderWidth() * 2))
        if (self.collapsible)
        {
            width -= (30.0 + self.marginWidth())
        }
        if (self.allowsAdd)
        {
            width -= (30.0 + self.marginWidth())
        }
        if (self.allowsRemove)
        {
            width -= (30.0 + self.marginWidth())
        }
        if (self.section?.editable == true)
        {
            width -= (30.0 + self.marginWidth())
            if (self.section?.mode == FBFormMode.Edit)
            {
                width -= (30.0 + self.marginWidth())
            }
        }
        return width
    }
    
    func labelHeight() -> CGFloat
    {
        return self.label?.text?.height(withConstrainedWidth: self.labelWidth(), font: self.style!.font) ?? 0.0
    }
    
    @objc @IBAction func editPressed()
    {
        let bundle = Bundle.init(for: self.classForCoder)
        if (self.section!.mode == FBFormMode.View)
        {
            self.editButton?.setImage(UIImage.init(named: "save", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            if (self.delegate != nil)
            {
                self.delegate!.editSelected(section: self.index!)
            }
        }
        else
        {
            if (self.delegate != nil)
            {
                self.delegate!.saveSelected(section: self.index!)
            }
        }
    }
    
    @objc @IBAction func cancelPressed()
    {
        let bundle = Bundle.init(for: self.classForCoder)
        self.section!.mode = FBFormMode.View
        self.editButton?.setImage(UIImage.init(named: "edit", in: bundle, compatibleWith: nil), for: UIControlState.normal)
        self.cancelButton?.isHidden = true
        if (self.delegate != nil)
        {
            self.delegate!.cancelSelected(section: self.index!)
        }
    }
    
    @objc @IBAction func collapsePressed()
    {
        let bundle = Bundle.init(for: self.classForCoder)
        if (self.delegate != nil)
        {
            if (self.collapsed)
            {
                self.delegate!.expand(section: self.index!)
            }
            else
            {
                self.delegate!.collapse(section: self.index!)
            }
            self.collapsed = !self.collapsed
            if (self.collapsed)
            {
                self.collapseButton?.setImage(UIImage.init(named: "right", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
            else
            {
                self.collapseButton?.setImage(UIImage.init(named: "down", in: bundle, compatibleWith: nil), for: UIControlState.normal)
            }
        }
    }
    
    @objc @IBAction func addPressed()
    {
        // show popup dialog here to allow selecting an item.
        let configuration:FTConfiguration = FTConfiguration.shared
        configuration.menuWidth = 100.0

        FTPopOverMenu.showForSender(sender: self.addButton!,
                                    with: self.addItems,
                                    done: { (selectedIndex) -> () in
                                        if (self.delegate != nil)
                                        {
                                            self.delegate!.addItem(section: self.index!, type: self.fieldFrom(string: self.addItems[selectedIndex]))
                                        }
        }) {
            
        }
    }

    @objc @IBAction func removePressed()
    {
        if (self.delegate != nil)
        {
            self.delegate?.removeItem(indexPath: IndexPath(row: 0, section: self.index!), type: FBFieldType.Section)
        }
    }
}
