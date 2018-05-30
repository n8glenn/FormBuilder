//
//  HeadingView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/22/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBHeadingView: FBFieldView
{
    @IBOutlet var label:UILabel?
    var field:FBHeadingField?

    override func height() -> CGFloat
    {
        return ((self.field?.style?.value(forKey: "margin") as! CGFloat)  * 2) +
                self.field!.labelHeight + ((self.field?.style?.value(forKey: "border") as! CGFloat))
    }
    
    override open func layoutSubviews()
    {
        let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            break
        case FBOrientation.Vertical:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            break
        case FBOrientation.ReverseHorizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            break
        case FBOrientation.ReverseVertical:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            break
        case FBOrientation.PlaceHolder:
            self.label?.frame = CGRect(x: margin,
                                       y: (self.frame.height / 2) - (self.field!.labelHeight / 2),
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            break
        }
    }

    open func updateDisplay(label:String)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.label?.sizeToFit()

        self.label?.text = label
    }
}
