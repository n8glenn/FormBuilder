//
//  TextAreaView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class TextAreaView: FieldView, UITextViewDelegate
{
    @IBOutlet var label:UILabel?
    @IBOutlet var textView:UITextView?
    @IBOutlet var requiredView:RequiredView?
    var field:TextAreaField?
    var maxLength:Int = 0
    
    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
            let border:CGFloat = self.field?.style?.value(forKey: "border") as? CGFloat ?? 1.5

            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                return (margin * 3) + self.field!.textViewHeight + self.field!.labelHeight + border + 30.0
                
            case FBOrientation.Vertical:
                return (margin * 3) + self.field!.textViewHeight + self.field!.labelHeight + border + 30.0
                
            case FBOrientation.ReverseHorizontal:
                return (margin * 3) + self.field!.textViewHeight + self.field!.labelHeight + border + 30.0
                
            case FBOrientation.ReverseVertical:
                return (margin * 3) + self.field!.textViewHeight + self.field!.labelHeight + border + 30.0
                
            case FBOrientation.PlaceHolder:
                return (margin * 3) + self.field!.textViewHeight + self.field!.labelHeight + border + 30.0
            }
        }
    }

    func updateDisplay(label:String, text:String, required:Bool)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.label?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.addSubview(self.label!)
        self.textView = UITextView()
        self.addSubview(self.textView!)
        self.requiredView = RequiredView()
        self.addSubview(self.requiredView!)
        
        self.label?.font = self.field!.style!.font
        self.textView?.font = self.field!.style!.font
        if (self.field!.editing)
        {
            // set this field to edit mode
            //self.textView?.borderStyle = UITextBorderStyle.bezel
            self.textView?.isUserInteractionEnabled = true
            self.requiredView?.isHidden = !required
        }
        else
        {
            // set this field to view mode
            //self.textView?.borderStyle = UITextBorderStyle.none
            self.textView?.isUserInteractionEnabled = false
            self.requiredView?.isHidden = true
        }
        
        self.label?.text = label
        self.textView?.text = text
        
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
    
    func textViewDidChange(_ textView: UITextView)
    {
        if (self.maxLength > 0)
        {
            if (self.textView!.text!.count > self.maxLength)
            {
                self.textView!.deleteBackward()
                return
            }
        }
        self.field?.data = self.textView!.text
    }
    
    override func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal, FBOrientation.Vertical, FBOrientation.ReverseHorizontal, FBOrientation.PlaceHolder:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.field!.labelWidth,
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (margin + self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            self.textView?.frame = CGRect(x: margin,
                                          y: (margin * 2) + self.field!.labelHeight,
                                          width: self.field!.textWidth,
                                          height: self.field!.textHeight)
            break
        case FBOrientation.ReverseVertical:
            self.textView?.frame = CGRect(x: margin,
                                          y: margin,
                                          width: self.frame.width - (margin * 2),
                                          height: self.frame.height - ((margin * 3) + self.field!.labelHeight))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height - (self.field!.labelHeight + margin) + (self.field!.labelHeight / 2.0)) - (self.field!.requiredHeight / 2.0),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            self.label?.frame = CGRect(x: margin,
                                       y: self.frame.height - (self.field!.labelHeight + margin),
                                       width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                       height: self.field!.labelHeight)
            break
        }
    }


}
