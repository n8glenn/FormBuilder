//
//  FBOptionSet.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/6/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBOptionSet: NSObject
{
    var id:String? = nil
    var range = (0, 0) // this is the range of lines in the spec file relating to this object.
    var field:FBField? = nil
    var options:Array<FBOption> = Array<FBOption>()
    
    public override init()
    {
        super.init()
    }
    
    public init(field:FBField?, file:FBFile, lines:(Int, Int))
    {
        super.init()
        
        self.range = lines
        self.field = field
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Id:
                self.id = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Option:
                let optionIndent:Int = file.lines[i].indentLevel
                let optionSpace:Int = file.lines[i].spaceLevel
                i += 1
                var optionRange = (i, i)
                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > optionIndent) ||
                        (file.lines[i].spaceLevel > optionSpace) ||
                        (file.lines[i].keyword == FBKeyWord.None))
                    {
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                optionRange.1 = i - 1
                self.options.append(FBOption(field: nil, file: file, lines: optionRange))
                
                break
            default:
                i += 1
                
                break
            }
        }
    }
    
    public func option(named: String) -> FBOption?
    {
        for option:FBOption in self.options
        {
            if (option.id.lowercased() == named.lowercased())
            {
                return option
            }
        }
        return nil
    }
    
    public func optionArray()->Array<String>
    {
        var optionArray:Array<String> = Array<String>()
        
        for option:FBOption in self.options
        {
            optionArray.append(option.value)
        }
        return optionArray
    }
    
    public func updateOption(option:FBOption)
    {
        let oldOption = self.option(named: option.id)
        if (oldOption != nil)
        {
            oldOption!.value = option.value
        }
        else
        {
            self.options.append(option)
        }
    }
}
