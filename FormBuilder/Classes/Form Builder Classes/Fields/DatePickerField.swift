//
//  DatePickerField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class DatePickerField: InputField
{
    var dateType:FBDateType = FBDateType.Date

    override func initWith(line:FBLine, dictionary:NSDictionary) -> DatePickerField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value") as! String
        }
        if (dictionary.value(forKey: "dateType") != nil)
        {
            self.dateType = FBField.dateTypeWith(string: dictionary.value(forKey: "dateType") as! String)
        }
        return super.initWith(line: line, dictionary: dictionary) as! DatePickerField
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
            return self.caption!.height(withConstrainedWidth:
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }

    override var textHeight:CGFloat
        {
        get
        {
            return self.caption!.height(withConstrainedWidth:
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }

}
