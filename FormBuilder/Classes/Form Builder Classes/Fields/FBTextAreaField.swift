//
//  TextAreaField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBTextAreaField: FBInputField
{
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#TextArea"
        if (FBStyleSet.shared.style(named: self.tag!) != nil)
        {
            self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
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
                while (i < lines.1)
                {
                    if (file.lines[i].continued)
                    {
                        i += 1
                        if (i <= lines.1)
                        {
                            var value:String = file.lines[i].value
                            value = value.replacingOccurrences(of: "\\n", with: "\n", options: [], range: nil)
                            value = value.replacingOccurrences(of: "\\t", with: "\t", options: [], range: nil)
                            value = value.replacingOccurrences(of: "\\r", with: "\r", options: [], range: nil)
                            value = value.replacingOccurrences(of: "\\\"", with: "\"", options: [], range: nil)
                            self.data = ((self.data ?? "") as! String) + value
                        }
                    }
                    else
                    {
                        break
                    }
                }
                i += 1
                
                break
            case FBKeyWord.Style:
                if (FBStyleSet.shared.style(named: file.lines[i].value) != nil)
                {
                    self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: file.lines[i].value)!)
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
            if (self.editing)
            {
                return ((self.input as? String)?.height(withConstrainedWidth: self.textWidth, font: self.style!.inputFont))!
            }
            else
            {
                return ((self.data as? String)?.height(withConstrainedWidth: self.textWidth, font: self.style!.inputFont))!
            }
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
