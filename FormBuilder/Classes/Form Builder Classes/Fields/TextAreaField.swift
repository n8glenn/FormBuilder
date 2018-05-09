//
//  TextAreaField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class TextAreaField: InputField
{
    override func initWith(line:FBLine, dictionary:NSDictionary) -> TextAreaField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value") as! String
        }

        return super.initWith(line: line, dictionary: dictionary) as! TextAreaField
    }
    
    var viewName:String
    {
        get
        {
            return self.style!.viewFor(type: self.fieldType)
        }
    }
    
    override var labelHeight:CGFloat
    {
        get
        {
            return self.caption!.height(withConstrainedWidth: self.labelWidth, font: self.style!.font)
        }
    }
    
    override var labelWidth:CGFloat
    {
        get
        {
            if (self.editing && self.required)
            {
                return self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 3) + self.requiredWidth + self.borderWidth)
            }
            else
            {
                return self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth)
            }
        }
    }
    
    var textAreaHeight:CGFloat
    {
        get
        {
            return ((self.data as? String)?.height(withConstrainedWidth: self.textWidth, font: self.style!.font))!
        }
    }
    
    override var textHeight:CGFloat
    {
        get
        {
            let height:CGFloat = self.line!.height() - (((self.style?.value(forKey: "margin") as! CGFloat) * 3) + self.labelHeight)
            if (height < 30.0)
            {
                return 30.0
            }
            else
            {
                return height
            }
        }
    }

    override var textWidth:CGFloat
    {
        get
        {
            let height:CGFloat = self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth)
            if (height < 30.0)
            {
                return 30.0
            }
            else
            {
                return height
            }

        }
    }

}
