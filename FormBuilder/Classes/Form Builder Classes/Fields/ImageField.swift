//
//  ImageField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class ImageField: FBField
{
    private var _data:Any? = nil
    override var data:Any?
        {
        get
        {
            return _data
        }
        set(newValue)
        {
            _data = newValue
        }
    }

    override func initWith(line:FBLine, dictionary:NSDictionary) -> ImageField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value")! as! String
        }
        return super.initWith(line: line, dictionary: dictionary) as! ImageField
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
            if (self.caption!.isEmpty)
            {
                return 0.0
            }
            else
            {
                return self.caption!.height(withConstrainedWidth:
                    self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                            font: self.style!.font)
            }
        }
    }

}
