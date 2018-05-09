//
//  CheckBoxField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class CheckBoxField: InputField
{
    override func initWith(line:FBLine, dictionary:NSDictionary) -> CheckBoxField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value") as! Bool
        }

        return super.initWith(line: line, dictionary: dictionary) as! CheckBoxField
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
                self.width - (((self.style!.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }
}
