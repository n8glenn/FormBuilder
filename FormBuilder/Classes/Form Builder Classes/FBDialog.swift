//
//  FBDialog.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/28/18.
//

import UIKit

public enum FBDialogType:Int
{
    case Date = 0
    case Signature = 1
}

open class FBDialog: NSObject
{
    var field:FBInputField? = nil
    var tag:String? = nil
    var type:FBDialogType? = nil
    var style:FBStyleClass? = nil

    override public init()
    {
        super.init()
    }
    
    public init(type:FBDialogType, field:FBInputField, lines:(Int, Int))
    {
        super.init()
        
        self.type = type
        self.field = field 
        switch (self.type!)
        {
        case FBDialogType.Date:
            self.tag = "#DateDialog"
            break
        case FBDialogType.Signature:
            self.tag = "#SignatureDialog"
            break
        }
        if (FBStyleSet.shared.style(named: self.tag!) != nil)
        {
            self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
            self.style!.parent = self.field!.style // override the default parents, our styles always descend from the style of the parent object!
        }
        
        var i:Int = lines.0
        let file = self.field!.line!.section!.form!.file!
        
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Style:
                if (FBStyleSet.shared.style(named: file.lines[i].value) != nil)
                {
                    self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: file.lines[i].value)!)
                    self.style!.parent = self.field!.style
                }
                i += 1
                
                break
            default:
                i += 1
                
                break
            }
        }
    }
}
