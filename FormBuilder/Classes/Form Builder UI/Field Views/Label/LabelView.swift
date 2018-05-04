//
//  LabelView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/28/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class LabelView: FieldView
{
    @IBOutlet var label:UILabel?
    var field:LabelField?

    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            return ((self.field!.style!.value(forKey: "margin") as! CGFloat) * 2.0)
                + self.field!.labelHeight + (self.field!.style!.value(forKey: "border") as! CGFloat)
        }
    }
    
    override func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        self.label?.frame = CGRect(x: margin,
                                   y: margin,
                                   width: self.frame.width - (margin * 2),
                                   height: self.frame.height - (margin * 2))
    }

    func updateDisplay(label:String)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = self.field!.style!.font
        self.label?.text = label
    }
}
