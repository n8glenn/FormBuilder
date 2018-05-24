//
//  ComboBoxFieldView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/18/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class ComboBoxFieldView: FieldView
{
    @IBOutlet var label:UILabel?
    @IBOutlet var dropDownLabel:UILabel?
    @IBOutlet var button:DropDownView?
    @IBOutlet var requiredView:RequiredView?
    var gestureRecognizer:UITapGestureRecognizer?
    var field:FBField?
    
    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0
            let border:CGFloat = (self.field?.style?.value(forKey: "border") as? CGFloat) ?? 1.5

            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                return (margin * 2) + self.field!.labelHeight + border
                
            case FBOrientation.Vertical:
                return (self.field!.labelHeight * 2) + (margin * 3) + border
                
            case FBOrientation.ReverseHorizontal:
                return (margin * 2) + self.field!.labelHeight + border
                
            case FBOrientation.ReverseVertical:
                return (self.field!.labelHeight * 2) + (margin * 3) + border
                
            case FBOrientation.PlaceHolder:
                return (margin * 2) + self.field!.labelHeight + border
            }
        }
    }

    override func layoutSubviews()
    {
        let labelWidth:CGFloat = (self.label!.text?.width(withConstrainedHeight: self.field!.textHeight, font: self.label!.font))!
        let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: labelWidth,
                                       height: self.field!.labelHeight)
            self.button?.frame = CGRect(x: labelWidth + (margin * 2),
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - (labelWidth + self.field!.requiredWidth + (margin * 4)),
                                        height: self.field!.labelHeight)
            self.dropDownLabel?.frame = CGRect(x: labelWidth + (margin * 3),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (labelWidth + self.field!.requiredWidth + (margin * 5)),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)
            break
        case FBOrientation.Vertical:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - (self.field!.requiredWidth + (margin * 2)),
                                       height: self.field!.labelHeight)
            self.button?.frame = CGRect(x: margin,
                                        y: self.field!.labelHeight + (margin * 2),
                                        width: self.frame.width - (self.field!.requiredWidth + (margin * 3)),
                                        height: self.field!.labelHeight)
            self.dropDownLabel?.frame = CGRect(x: margin * 2,
                                               y: self.field!.labelHeight + (margin * 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (margin * 3)),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: self.button!.frame.origin.y + ((self.button!.frame.height / 2.0) - (self.field!.requiredHeight / 2.0)),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseHorizontal:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - (labelWidth + self.field!.requiredWidth + (margin * 4)),
                                        height: self.field!.labelHeight)
            self.dropDownLabel?.frame = CGRect(x: margin * 2,
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (labelWidth + self.field!.requiredWidth + (margin * 5)),
                                               height: self.field!.labelHeight)
            self.label?.frame = CGRect(x: self.button!.frame.width + (margin * 2),
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: labelWidth,
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseVertical:
            self.button?.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (self.field!.requiredWidth + (margin * 3)),
                                        height: self.field!.labelHeight)
            self.dropDownLabel?.frame = CGRect(x: margin * 2,
                                               y: margin,
                                               width: self.frame.width - (self.field!.requiredWidth + (margin * 4)),
                                               height: self.field!.labelHeight)
            self.label?.frame = CGRect(x: margin,
                                       y: self.field!.labelHeight + (margin * 2),
                                       width: self.frame.width - (margin * 3),
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: self.dropDownLabel!.frame.origin.y + ((self.dropDownLabel!.frame.height / 2.0) - (self.field!.requiredHeight / 2.0)),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)
            break
        case FBOrientation.PlaceHolder:
            self.label?.isHidden = true
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - (self.field!.requiredWidth + (margin * 3)),
                                        height: self.field!.labelHeight)
            self.dropDownLabel?.frame = CGRect(x: margin * 2,
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (margin * 3)),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)
            break
        }
    }
    
    @objc @IBAction func buttonPressed()
    {
        // show popup dialog here to allow selecting an item.
        let configuration:FTConfiguration = FTConfiguration.shared
        configuration.menuWidth = button!.frame.width
        FTPopOverMenu.showForSender(sender: button!,
                                    with: field!.optionSet!.optionArray(),
                                    done: { (selectedIndex) -> () in
                                        self.dropDownLabel?.text = (self.field?.optionSet?.options[selectedIndex].value)!
                                        self.field!.input = self.field?.optionSet?.options[selectedIndex].id
        }) {
            
        }
    }

    func updateDisplay(label:String, text:String, required:Bool)
    {
        self.label = UILabel()
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.addSubview(self.label!)
        self.label!.sizeToFit()
        self.dropDownLabel = UILabel()
        self.dropDownLabel?.font = UIFont(name: self.field?.style!.value(forKey: "input-font-family") as! String,
                                  size: self.field?.style!.value(forKey: "input-font-size") as! CGFloat)
        self.dropDownLabel?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "input-foreground-color") as! String)
        self.addSubview(self.dropDownLabel!)
        self.button = DropDownView.fromNib(withName: "DropDownView")
        self.button!.backgroundColor = UIColor.clear
        self.addSubview(self.button!)
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        self.button!.addGestureRecognizer(self.gestureRecognizer!)
        self.requiredView = RequiredView()
        self.addSubview(self.requiredView!)
        
        if (self.field!.editing)
        {
            // set this field to edit mode
            self.button?.isUserInteractionEnabled = true
            self.button?.isHidden = false
            self.requiredView?.isHidden = !required
            self.dropDownLabel?.backgroundColor = UIColor.white
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                break
            case FBOrientation.Vertical:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.ReverseHorizontal:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.ReverseVertical:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.PlaceHolder:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            }
        }
        else
        {
            // set this field to view mode
            self.button?.isUserInteractionEnabled = false
            self.button?.isHidden = true
            self.requiredView?.isHidden = true
            self.dropDownLabel?.backgroundColor = UIColor.clear
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                self.dropDownLabel?.textAlignment = NSTextAlignment.right
                break
            case FBOrientation.Vertical:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.ReverseHorizontal:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.ReverseVertical:
                self.dropDownLabel?.textAlignment = NSTextAlignment.left
                
                break
            case FBOrientation.PlaceHolder:
                self.dropDownLabel?.textAlignment = NSTextAlignment.right
                
                break
            }
        }
        
        self.label!.text = label
        self.dropDownLabel!.text = text
    }
}
