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

    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Image"
        if (FBStyleSet.shared.style(named: self.tag!) != nil)
        {
            self.style = FBStyleSet.shared.style(named: self.tag!)
            self.style!.parent = self.line!.style // override the default parents, our styles always descend from the style of the parent object!
        }

        var i:Int = lines.0
        let file = self.line!.section!.form!.file!
        
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Value:
                self.data = file.lines[i].value
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
