//
//  CheckBoxView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/23/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBCheckBoxView: FBFieldView
{
    @IBOutlet var checkBoxLabel:UILabel?
    @IBOutlet var button:FBCheckView?
    @IBOutlet var requiredView:FBRequiredView?
    var gestureRecognizer:UITapGestureRecognizer?
    var field:FBCheckBoxField?
    
    override func height() -> CGFloat
    {
        return ((self.field!.style!.value(forKey: "margin") as! CGFloat) * 2)
                + self.field!.labelHeight + (self.field!.style!.value(forKey: "border") as! CGFloat)
    }

    open func updateDisplay(label:String, state:FBCheckState, required:Bool)
    {
        self.checkBoxLabel = UILabel()
        self.checkBoxLabel?.numberOfLines = 0
        self.addSubview(self.checkBoxLabel!)
        self.checkBoxLabel?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.checkBoxLabel?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.checkBoxLabel?.sizeToFit()
        self.button = FBCheckView.fromNib(withName: "FBCheckView")
        self.button?.backgroundColor = UIColor.clear
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonPressed))
        self.button?.addGestureRecognizer(self.gestureRecognizer!)
        self.addSubview(self.button!)
        self.requiredView = FBRequiredView()
        self.addSubview(self.requiredView!)
        
        self.checkBoxLabel?.font = self.field!.style!.font
        if (self.field!.editing)
        {
            // set this field to edit mode
            self.requiredView?.isHidden = !required 
            self.button?.isUserInteractionEnabled = true
            self.button?.state = state
        }
        else
        {
            // set this field to view mode
            self.requiredView?.isHidden = true
            self.button?.isUserInteractionEnabled = false
            self.button?.state = state 
        }        
        self.checkBoxLabel!.text = label
    }
    
    override open func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                        height: self.field!.labelHeight)
            self.checkBoxLabel?.frame = CGRect(x: self.field!.labelHeight + (margin * 2),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (self.field!.labelHeight + (margin * 4))),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.Vertical:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                        height: self.field!.labelHeight)
            self.checkBoxLabel?.frame = CGRect(x: self.field!.labelHeight + (margin * 2),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (self.field!.labelHeight + (margin * 4))),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseHorizontal:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                        height: self.field!.labelHeight)
            self.checkBoxLabel?.frame = CGRect(x: self.field!.labelHeight + (margin * 2),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (self.field!.labelHeight + (margin * 4))),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseVertical:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                        height: self.field!.labelHeight)
            self.checkBoxLabel?.frame = CGRect(x: self.field!.labelHeight + (margin * 2),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (self.field!.labelHeight + (margin * 4))),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.PlaceHolder:
            self.button?.frame = CGRect(x: margin,
                                        y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                        width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                        height: self.field!.labelHeight)
            self.checkBoxLabel?.frame = CGRect(x: self.field!.labelHeight + (margin * 2),
                                               y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                               width: self.frame.width - (self.field!.requiredWidth + (self.field!.labelHeight + (margin * 4))),
                                               height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        }
        self.button?.setNeedsDisplay()
    }
    
    @objc @IBAction func buttonPressed()
    {
        // toggle between checked and unchecked...
        if (self.button?.state == FBCheckState.Checked)
        {
            self.button?.state = FBCheckState.Unchecked
        }
        else
        {
            self.button?.state = FBCheckState.Checked
        }
        self.button?.setNeedsDisplay()
        if (self.button?.state == FBCheckState.Checked)
        {
            self.field?.input = true
        }
        else
        {
            self.field?.input = nil
        }
    }    
}
