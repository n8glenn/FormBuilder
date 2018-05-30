//
//  SignatureField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBSignatureField: FBInputField
{
    var dialog:FBDialog? = nil
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        self.tag = "#Signature"
        if (FBStyleSet.shared.style(named: self.tag!) != nil)
        {
            self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
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
                    self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: file.lines[i].value)!)
                }
                i += 1
                
                break
            case FBKeyWord.Requirements:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                        (file.lines[i].keyword == FBKeyWord.None))
                    {
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                
                break
            case FBKeyWord.Dialog:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                var fieldRange = (i, i)

                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                        (file.lines[i].keyword == FBKeyWord.None))
                    {
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                fieldRange.1 = i - 1
                self.dialog = FBDialog(type: FBDialogType.Signature, field: self, lines: fieldRange)
                
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

    override var labelWidth: CGFloat
    {
        get
        {
            let style:FBStyleClass? = self.dialog?.style ?? nil
            let signatureWidth:CGFloat = style?.value(forKey: "width") as? CGFloat ?? 300.0
            return self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth + signatureWidth)
        }
    }
}
