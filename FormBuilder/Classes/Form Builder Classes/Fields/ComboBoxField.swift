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
    private var _optionSet:FBOptionSet?
    override var optionSet:FBOptionSet?
        {
        get
        {
            return _optionSet
        }
        set(newValue)
        {
            _optionSet = newValue
        }
    }
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#ComboBox"
        if (FBStyleSet.shared.style(named: self.tag!) != nil)
        {
            self.style = FBStyleSet.shared.style(named: self.tag!)
            self.style!.parent = self.line!.style // override the default parents, our styles always descend from the style of the parent object!
        }

        let file = self.line!.section!.form!.file!
        var i:Int = lines.0
        
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Value:
                self.data = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.OptionSet:
                if (file.lines[i].value != "")
                {
                    self.optionSet = FBSettings.sharedInstance.optionSet[file.lines[i].value]
                    self.optionSet?.field = self
                }
                else
                {
                    let indentLevel:Int = file.lines[i].indentLevel
                    let spaceLevel:Int = file.lines[i].spaceLevel
                    i += 1
                    var optionRange = (i, i)
                    while (i <= lines.1)
                    {
                        if ((file.lines[i].indentLevel > indentLevel) ||
                            (file.lines[i].spaceLevel > spaceLevel))
                        {
                            i += 1
                        }
                        else
                        {
                            break
                        }
                        optionRange.1 = i - 1
                        self.optionSet = FBOptionSet(field: self, file: file, lines: optionRange)
                    }
                }
                i += 1
                
                break
            case FBKeyWord.Style:
                if (FBStyleSet.shared.style(named: file.lines[i].value) != nil)
                {
                    self.style = FBStyleSet.shared.style(named: file.lines[i].value)
                }
                i += 1
                
                break
            default:
                i += 1
                
                break
            }
        }
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
