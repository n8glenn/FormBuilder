//
//  ComboBoxField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class ComboBoxField: InputField
{
    private var _options:Array<String>?
    override var options:Array<String>?
    {
        get
        {
            return _options
        }
        set(newValue)
        {
            _options = newValue
        }
    }
    
    override func initWith(line:FBLine, dictionary:NSDictionary) -> ComboBoxField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = Int(dictionary.value(forKey: "value") as! Int)
        }

        if (dictionary.value(forKey: "options") != nil)
        {
            self.options = Array<String>()
            for optionString in dictionary.value(forKey: "options") as! Array<String>
            {
                self.options!.append(optionString)
            }
        }

        if (dictionary.value(forKey: "option-set") != nil)
        {
            let name:String = dictionary.value(forKey: "option-set") as! String
            self.options = FBSettings.sharedInstance.optionSets.value(forKey: name) as? Array<String>
        }

        return super.initWith(line: line, dictionary: dictionary) as! ComboBoxField
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
