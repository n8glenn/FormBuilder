//
//  SignatureField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class SignatureField: InputField
{
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
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
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }

}
