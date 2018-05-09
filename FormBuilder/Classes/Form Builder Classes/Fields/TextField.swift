//
//  TextField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class TextField : InputField
{
    override func initWith(line:FBLine, dictionary:NSDictionary) -> TextField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value") as! String
        }
        
        return super.initWith(line: line, dictionary: dictionary) as! TextField
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
            let height:CGFloat = (self.data as! String).height(withConstrainedWidth:
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                                      font: self.style!.font)
            if (height < 20.0)
            {
                return 20.0
            }
            else
            {
                return height
            }
        }
    }

    override var labelWidth:CGFloat
    {
        get
        {
            return 0.0
        }
    }
}
