//
//  FBSection.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBSection: NSObject
{
    // FBSection -- a group of fields in a form, it can have a title, and can allow new fields
    //              to be added, it can also be collapsed or removed from the form based on user interaction.
    
    var id:String = ""
    var tag:String? = "#Section"
    var style:FBStyleClass? = nil
    var title:String? = ""
    public var lines:Array<FBLine>? = Array<FBLine>()
    public var visible:Bool = true
    var collapsible:Bool = false
    var collapsed:Bool = false
    public var form:FBForm?
    var headerView:FBSectionHeaderView?
    var mode:FBFormMode = FBFormMode.View
    var allowsAdd:Bool = false
    var allowsRemove:Bool = false
    var addSection:Bool = false
    var addLine:Bool = false
    var fieldsToAdd:Array<FBFieldType> = Array<FBFieldType>()
    var range = (0, 0)
    private var _editable:Bool?
    var editable:Bool?
    {
        get
        {
            // this section is ONLY editable if none of its parents are explicitly set as NOT editable.
            if ((self.form?.editable == nil) || (self.form?.editable == true))
            {
                if ((_editable == nil) || (_editable == true))
                {
                    return true
                }
            }
            return false
        }
        set(newValue)
        {
            _editable = newValue
        }
    }

    public init(form: FBForm, lines:(Int, Int))
    {
        super.init()
        
        self.form = form
        let file = form.file!
        self.range = lines
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
        self.style!.parent = self.form!.style // override the default parents, our styles always descend from the style of the parent object!
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Id:
                self.id = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Style:
                //self.tag = file.lines[i].value
                self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: file.lines[i].value)!)
                self.style!.parent = self.form!.style
                
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (file.lines[i].value.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Collapsible:
                self.collapsible = (file.lines[i].value.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Collapsed:
                self.collapsed = (file.lines[i].value.lowercased() == "true")
                i += 1
                
                break
            case FBKeyWord.AllowsAdd:
                self.allowsAdd = (file.lines[i].value.lowercased() == "true")
                i += 1
                
                break
            case FBKeyWord.AddItems:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                        (file.lines[i].keyword == FBKeyWord.None))
                    {
                        switch (file.lines[i].keyword)
                        {
                        case FBKeyWord.Section:
                            self.fieldsToAdd.append(FBFieldType.Section)
                            break
                        case FBKeyWord.Image:
                            self.fieldsToAdd.append(FBFieldType.Image)
                            break
                        case FBKeyWord.Label:
                            self.fieldsToAdd.append(FBFieldType.Label)
                            break
                        case FBKeyWord.Signature:
                            self.fieldsToAdd.append(FBFieldType.Signature)
                            break
                        default:
                            break
                        }
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                
                break
            case FBKeyWord.Title:
                self.title = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Line:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                var lineRange = (i, i)
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
                lineRange.1 = i - 1
                self.lines?.append(FBLine(section: self, lines: lineRange))
                
                break
            default:
                i += 1
                break
            }
        }
    }
    
    func equals(value:String) -> Bool
    {
        return Bool(self.id.lowercased() == value.lowercased())
    }
    
    public func line(named:String) -> FBLine?
    {
        for line in self.lines!
        {
            if (line.id.lowercased() == named.lowercased())
            {
                return line
            }
        }
        return nil
    }
    
    public func field(withPath:String) -> FBField?
    {
        var line:FBLine? = nil
        var path:Array<String> = withPath.components(separatedBy: ".")
        if (path.count > 0)
        {
            line = self.line(named: path[0])
        }
        if (line != nil)
        {
            if (line?.fields.count == 1)
            {
                return line?.fields[0]
            }
            else
            {
                if (path.count > 2)
                {
                    return line?.field(named: path[2])
                }
            }
        }
        return nil
    }

    func visibleLines() -> Array<FBLine>
    {
        var visible:Array<FBLine> = Array<FBLine>()
        for line in self.lines!
        {
            if (line.visible == true)
            {
                visible.append(line)
            }
        }
        return visible 
    }
    
    func removeLine(row:Int)
    {
        var visible:Int = 0
        var actual:Int = 0
        for line in self.lines!
        {
            if (line.visible == true)
            {
                if (visible == row)
                {
                    break
                }
                visible += 1
            }
            actual += 1
        }
        self.lines?.remove(at: actual)
    }
    
    func lineCount() -> Int
    {
        return self.visibleLines().count 
    }
    
    func colorFor(line:FBLine) -> UIColor
    {
        var color:UIColor = UIColor.init(hexString: self.style?.value(forKey: "background-color") as! String) ?? UIColor.white
        if ((self.style?.value(forKey: "alternate-colors") as! String).lowercased() == "true")
        {
            var count:Int = 0
            for currentLine in self.visibleLines()
            {
                if (line.id == currentLine.id)
                {
                    return color
                }
                if (count % 2 == 1)
                {
                    color = UIColor.init(hexString: self.style?.value(forKey: "background-color") as! String) ?? UIColor.white
                }
                else
                {
                    color = UIColor.init(hexString: self.style?.value(forKey: "alternate-background-color") as! String) ?? UIColor.lightGray
                }
                count += 1
            }
        }
        return color
    }
}
