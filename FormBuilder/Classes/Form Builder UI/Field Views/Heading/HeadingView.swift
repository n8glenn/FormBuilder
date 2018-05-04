//
//  HeadingView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/22/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class HeadingView: FieldView
{
    @IBOutlet var label:UILabel?
    var field:HeadingField?

    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            return ((self.field!.style!.value(forKey: "margin") as! CGFloat) * 2) + self.field!.labelHeight + (self.field!.style!.value(forKey: "border") as! CGFloat)
        }
    }
    
    override func layoutSubviews()
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

    func updateDisplay(label:String)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = self.field?.style!.font 
        self.label?.text = label
    }
}
