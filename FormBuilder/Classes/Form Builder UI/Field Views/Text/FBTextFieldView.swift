//
//  TextFieldView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/17/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBTextFieldView: FBFieldView, UITextFieldDelegate
{
    @IBOutlet var label:UILabel?
    @IBOutlet var textField:UITextField?
    @IBOutlet var requiredView:FBRequiredView?
    var field:FBTextField?
    var maxLength:Int = 0
    
    override func height() -> CGFloat
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let border:CGFloat = self.field?.style?.value(forKey: "border") as? CGFloat ?? 1.5

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            return (margin * 2) + self.field!.labelHeight + border
            
        case FBOrientation.Vertical:
            return (margin * 3) + self.field!.labelHeight + self.field!.textHeight + border
            
        case FBOrientation.ReverseHorizontal:
            return (margin * 2) + self.field!.labelHeight + border
            
        case FBOrientation.ReverseVertical:
            return (margin * 3) + field!.labelHeight + field!.textHeight + border
            
        case FBOrientation.PlaceHolder:
            return (margin * 2) + self.field!.labelHeight + border
        }
    }
    
    override open func layoutSubviews()
    {
        let labelWidth:CGFloat = (self.label!.text?.width(withConstrainedHeight: self.frame.height, font: self.label!.font))!
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: labelWidth,
                                       height: self.field!.labelHeight)
            let textX:CGFloat = (self.label?.frame.origin.x)! + labelWidth + margin
            let textY:CGFloat = (self.frame.height / 2) - (self.field!.textHeight / 2)
            self.textField?.frame = CGRect(x: textX,
                                           y: textY,
                                           width: self.frame.width - (textX + (margin * 2) + self.field!.requiredWidth),
                                           height: self.field!.textHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)

            break
        case FBOrientation.Vertical:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            self.textField?.frame = CGRect(x: margin,
                                           y: self.field!.labelHeight + (margin * 2),
                                           width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                           height: self.field!.textHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.textField?.frame.origin.y)! + ((self.textField?.frame.height)! / 2.0) - (self.field!.requiredHeight / 2.0),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)

            break
        case FBOrientation.ReverseHorizontal:
            self.textField?.frame = CGRect(x: margin,
                                           y: (self.frame.height / 2) - (self.field!.textHeight / 2),
                                           width: self.frame.width - (labelWidth + (margin * 4) + self.field!.requiredWidth),
                                           height: self.field!.textHeight)
            self.label?.frame = CGRect(x: self.textField!.frame.width + (margin * 2),
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: labelWidth,
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)

            break
        case FBOrientation.ReverseVertical:
            self.textField?.frame = CGRect(x: margin,
                                           y: margin,
                                           width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                           height: self.field!.textHeight)
            self.label?.frame = CGRect(x: margin,
                                       y: (margin * 2) + self.field!.textHeight,
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.textHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                               y: (self.textField?.frame.origin.y)! + ((self.textField?.frame.height)! / 2.0) - (self.field!.requiredHeight / 2.0),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)

            break
        case FBOrientation.PlaceHolder:
            self.label?.isHidden = true
            self.textField?.frame = CGRect(x: margin,
                                           y: (self.frame.height / 2) - (self.field!.textHeight / 2),
                                           width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                           height: self.field!.textHeight)
            self.textField?.placeholder = self.label?.text
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                               y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                               width: self.field!.requiredWidth,
                                               height: self.field!.requiredHeight)

            break
        }
    }
    
    @objc @IBAction func textChanged()
    {
        if (self.maxLength > 0)
        {
            if (self.textField!.text!.count > self.maxLength)
            {
                self.textField!.deleteBackward()
                return
            }
        }
        self.field?.input = self.textField?.text
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    open func updateDisplay(label:String, text:String, required:Bool)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.label?.text = label
        self.label?.sizeToFit()
        self.textField = UITextField()
        self.textField?.keyboardType = self.field?.keyboard ?? .default
        self.textField?.autocapitalizationType = self.field?.capitalize ?? .words
        self.textField?.delegate = self
        self.textField?.addTarget(self, action: #selector(textChanged), for: UIControl.Event.editingChanged)
        self.addSubview(self.textField!)
        self.textField?.font = UIFont(name: self.field?.style!.value(forKey: "input-font-family") as! String,
                                  size: self.field?.style!.value(forKey: "input-font-size") as! CGFloat)
        self.textField?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "input-foreground-color") as! String)
        self.textField?.text = text
        self.textField?.sizeToFit()
        self.requiredView = FBRequiredView()
        self.addSubview(self.requiredView!)
        
        if (self.field!.editing)
        {
            // set this field to edit mode
            self.textField?.borderStyle = UITextField.BorderStyle.bezel
            self.textField?.isUserInteractionEnabled = true
            self.requiredView?.isHidden = !required
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.Vertical:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.ReverseHorizontal:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.ReverseVertical:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.PlaceHolder:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            }
        }
        else
        {
            // set this field to view mode
            self.textField?.borderStyle = UITextField.BorderStyle.none
            self.textField?.isUserInteractionEnabled = false
            self.requiredView?.isHidden = true
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                self.textField?.textAlignment = NSTextAlignment.right

                break
            case FBOrientation.Vertical:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.ReverseHorizontal:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.ReverseVertical:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            case FBOrientation.PlaceHolder:
                self.textField?.textAlignment = NSTextAlignment.left

                break
            }
        }
        
        for requirement in self.field!.requirements!
        {
            switch (requirement.type)
            {
            case FBRequirementType.Maximum:
                let max:Int = requirement.value as! Int
                self.maxLength = max
                break
            default:
                break
            }
        }
    }
}
