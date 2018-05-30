//
//  LabelView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/28/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBLabelView: FBFieldView
{
    @IBOutlet var label:UILabel?
    var field:FBLabelField?

    override func height() -> CGFloat
    {
        return ((self.field!.style!.value(forKey: "margin") as! CGFloat) * 2.0)
                + self.field!.labelHeight + (self.field!.style!.value(forKey: "border") as! CGFloat) + 1.0
    }
    
    override open func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        self.label?.frame = CGRect(x: margin,
                                   y: margin,
                                   width: self.frame.width - (margin * 2),
                                   height: self.frame.height - (margin * 2))
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
