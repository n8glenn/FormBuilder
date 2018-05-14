//
//  FBOption.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBOption: NSObject
{
    var id:String = ""
    var tag:String? = "#Option"
    var style:FBStyleClass? = nil
    var visible:Bool = true
    var value:String = ""
    var field:FBField? = nil
    var range = (0, 0)
    
    override public init()
    {
        super.init()
    }

    public init(field:FBField?, file:FBFile, lines:(Int, Int))
    {
        super.init()
        
        self.field = field
        self.range = lines
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Id:
                self.id = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Value:
                self.value = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Visible:
                self.visible = (file.lines[i].description.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Style:
                self.tag = file.lines[i].description
                self.style = FBStyleSet.shared.style(named: self.tag!)
                if (self.field != nil)
                {
                    self.style!.parent = self.field!.style // override the default parents, our styles always descend from the style of the parent object!
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
