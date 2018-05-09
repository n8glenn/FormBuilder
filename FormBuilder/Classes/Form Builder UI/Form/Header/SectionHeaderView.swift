//
//  SectionHeaderView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/2/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol SectionHeaderDelegate: class
{
    func collapse(section:Int)
    func expand(section:Int)
    func addItem(section:Int, type:FBFieldType)
    func removeItem(indexPath:IndexPath, type:FBFieldType)
}

class SectionHeaderView: UIView
{
    @IBOutlet var backgroundView:UIView?
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
    weak var delegate:SectionHeaderDelegate?
    
    func updateDisplay(index:Int, section:FBSection)
    {
        let bundle = Bundle.init(for: self.classForCoder)
        section.headerView = self
        self.section = section
        self.backgroundColor = UIColor.init(hexString: self.section?.style?.value(forKey: "border-color") as! String)
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = UIColor.init(hexString: self.section?.style?.value(forKey: "background-color") as! String)
        self.addSubview(self.backgroundView!)
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.label?.text = section.title ?? ""
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
        let labelHeight:CGFloat = (self.label?.text?.height(withConstrainedWidth: self.frame.width - 120.0, font: (self.label?.font)!))!
        return ((self.section!.style!.value(forKey: "margin") as! CGFloat) * 2) + labelHeight + (self.section!.style!.value(forKey: "border") as! CGFloat)
    }

    override func layoutSubviews()
    {
        let border:CGFloat = self.section?.style?.value(forKey: "border") as! CGFloat
        
        self.backgroundView?.frame = CGRect(x: border, y: 0.0, width: self.frame.width - (border * 2.0), height: self.frame.height - border)
        if (self.collapsible)
        {
            self.collapseButton!.frame = CGRect(x: 5.0, y: 5.0, width: 30.0, height: 30.0)
        }
        self.label!.frame = CGRect(x:50.0, y:5.0, width:self.frame.width - 120.0, height: 30.0)
        if (self.allowsAdd)
        {
            self.addButton!.frame = CGRect(x: self.frame.width - 35.0, y: 5.0, width: 30.0, height: 30.0)
        }
        if (self.allowsRemove)
        {
            self.removeButton!.frame = CGRect(x: self.frame.width - 80.0, y: 5.0, width: 30.0, height: 30.0)
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
            self.delegate?.removeItem(indexPath: IndexPath(row: self.index!, section: 0), type: FBFieldType.Section)
        }
    }
}
