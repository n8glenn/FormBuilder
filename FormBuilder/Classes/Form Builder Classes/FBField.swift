//
//  Field.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBFieldType:Int
{
    case Unknown = 0
    case Section = 1
    case Heading = 2
    case Label = 3
    case Image = 4
    case ImagePicker = 5
    case Text = 6
    case TextArea = 7
    case ComboBox = 8
    case CheckBox = 9
    case OptionSet = 10
    case Signature = 11
    case DatePicker = 12
}

public enum FBDateType:Int
{
    case Date = 0
    case Time = 1
    case DateTime = 2
}

open class FBField: NSObject
{
    // Field -- represents a line of data in the form (although potentially more than one field can
    //          be put on one line, this won't usually be the case)  the field is an item of data to
    //          be entered into the form, it can be validated and it can also potentially be
    //          replicated if allowed by the section it's in.
    
    public var id:String = ""
    public var hasInput:Bool = false
    public var hasData:Bool = false
    var tag:String? = "#Field"
    var style:FBStyleClass? = nil
    public var line:FBLine?
    public var fieldType:FBFieldType = FBFieldType.Heading
    var view:FBFieldView? = nil
    public var caption:String? = ""
    public var visible:Bool = true
    var range = (0, 0)
    private var _labelHeight:CGFloat = 30.0
    private var _textHeight:CGFloat = 30.0
    var requiredWidth:CGFloat = 5.0
    var requiredHeight:CGFloat = 5.0
    // the style properties control how the field is displayed, the display properties may be set in any parent class
    // all the way up to the form, and it may be overridden at every level as well.  So first we check to see if the value
    // has been set for this field, if not, has it been set for the line, if not, has it been set for the section, if not
    // has it been set for the form, and if not, is it set in the settings singleton?
    
    public var required:Bool
    {
        get
        {
            return false
        }
        set(newValue)
        {
            // do nothing
        }
    }

    public var input:Any?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing
        }
    }

    public var data:Any?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing 
        }
    }
    
    var optionSet:FBOptionSet?
    {
        get
        {
            return nil
        }
        set(newValue)
        {
            // do nothing
        }
    }

    var borderWidth:CGFloat
    {
        get
        {
            var borderWidth:CGFloat = 0.0
            if ((self == self.line!.fields.first) && (self == self.line!.fields.last))
            {
                borderWidth = (self.style?.value(forKey: "border") as! CGFloat) * 2.0
            }
            else if ((self == self.line!.fields.first) || (self == self.line!.fields.last))
            {
                borderWidth = (self.style?.value(forKey: "border") as! CGFloat) * 1.5
            }
            else
            {
                borderWidth = (self.style?.value(forKey: "border") as! CGFloat)
            }
            return borderWidth
        }
    }

    var borderHeight:CGFloat
    {
        get
        {
            return (self.style?.value(forKey: "border") as! CGFloat)
        }
    }
    
    var width:CGFloat
    {
        get
        {
            return (self.line!.section!.form!.tableView!.frame.width / CGFloat(self.line!.fields.count)) - self.borderWidth
        }
    }

    var labelHeight:CGFloat
    {
        get
        {
            return 0.0
        }
    }

    var labelWidth:CGFloat
    {
        get
        {
            return 0.0
        }
    }

    var textHeight:CGFloat
    {
        get
        {
            return 0.0
        }
    }
    
    var textWidth:CGFloat
    {
        get
        {
            return 0.0
        }
    }

    var mode:FBFormMode
    {
        get
        {
            return FBFormMode.View
        }
    }

    var editing:Bool
    {
        get
        {
            return false
        }
    }
    
    override public init()
    {
        super.init()
    }

    public init(line:FBLine, lines:(Int, Int))
    {
        super.init()
        
        self.line = line
        self.range = lines
        let file = self.line!.section!.form!.file!
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
        self.style!.parent = self.line!.style // override the default parents, our styles always descend from the style of the parent object!
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.None:
                i += 1
                
                break
            case FBKeyWord.Unknown:
                i += 1
                
                break 
            case FBKeyWord.Id:
                self.id = file.lines[i].value
                i += 1
                
                break
            case FBKeyWord.Visible:
                self.visible = (file.lines[i].value.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Style:
                //self.tag = file.lines[i].value
                self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: file.lines[i].value)!)
                self.style!.parent = self.line!.style // override the default parents, our styles always descend from the style of the parent object!
                i += 1
                
                break
            case FBKeyWord.Dialog:
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
            case FBKeyWord.FieldType:
                self.fieldType = FBField.typeWith(string: file.lines[i].value)
                i += 1
                
                break
            case FBKeyWord.Caption:
                self.caption = file.lines[i].value
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
                            self.caption = (self.caption ?? "") + value
                        }
                    }
                    else
                    {
                        break
                    }
                }
                i += 1
                
                break
            default:
                i += 1
                break
            }
        }
    }
    
    func initWith(line:FBLine, id:String, label:String, type:FBFieldType) -> FBField
    {
        self.line = line
        self.id = id as String
        self.fieldType = type
        self.caption = label
        self.visible = true
        
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
        self.style!.parent = self.line!.style // override the default parents, our styles always descend from the style of the parent object!
        
        return self
    }
    
    func validate() -> FBException
    {
        let exception:FBException = FBException()
        exception.field = self
        return exception
    }
    
    public func clear()
    {
        // do nothing here
        NSLog("in field clear")
    }
    
    func equals(value:String) -> Bool
    {
        return Bool(self.id.lowercased() == value.lowercased())
    }
        
    static func typeWith(string:String) -> FBFieldType
    {
        switch (string.lowercased())
        {
        case "section":
            return FBFieldType.Section
            
        case "heading":
            return FBFieldType.Heading

        case "label":
            return FBFieldType.Label

        case "image":
            return FBFieldType.Image
            
        case "imagepicker":
            return FBFieldType.ImagePicker

        case "text":
            return FBFieldType.Text

        case "textarea":
            return FBFieldType.TextArea

        case "combobox":
            return FBFieldType.ComboBox

        case "checkbox":
            return FBFieldType.CheckBox

        case "optionset":
            return FBFieldType.OptionSet

        case "signature":
            return FBFieldType.Signature
        
        case "datepicker":
            return FBFieldType.DatePicker
            
        default:
            return FBFieldType.Heading
        }
    }

    static func dateTypeWith(string:String) -> FBDateType
    {
        switch (string.lowercased())
        {
        case "date":
            return FBDateType.Date
            
        case "time":
            return FBDateType.Time
            
        case "datetime":
            return FBDateType.DateTime
        default:
            return FBDateType.Date
        }
    }
    
    func isNil(someObject: Any?) -> Bool {
        if someObject is String {
            if (someObject as? String) != nil && !((someObject as? String)?.isEmpty)! {
                return false
            }
        }
        if someObject is Array<Any> {
            if (someObject as? Array<Any>) != nil {
                return false
            }
        }
        if someObject is Dictionary<AnyHashable, Any> {
            if (someObject as? Dictionary<String, Any>) != nil {
                return false
            }
        }
        if someObject is Data {
            if (someObject as? Data) != nil {
                return false
            }
        }
        if someObject is Date {
            if (someObject as? Date != nil) {
                return false 
            }
        }
        if someObject is NSNumber {
            if (someObject as? NSNumber) != nil{
                return false
            }
        }
        if someObject is UIImage {
            if (someObject as? UIImage) != nil {
                return false
            }
        }
        return true
    }
}
