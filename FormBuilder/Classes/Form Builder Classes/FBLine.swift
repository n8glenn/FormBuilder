//
//  FBLine.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/17/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBLine: NSObject
{
    public var id:String = ""
    public var tag:String? = "#Line"
    public var style:FBStyleClass? = nil
    public var visible:Bool = true
    var allowsRemove:Bool = false
    public var fields:Array<FBField> = Array<FBField>()
    public var section:FBSection?
    var range = (0, 0)
    private var _editable:Bool?
    var editable:Bool?
    {
        get
        {
            // this line is ONLY editable if none of its parents are explicitly set as NOT editable.
            if ((self.section?.form?.editable == nil) || (self.section?.form?.editable == true))
            {
                if ((self.section?.editable == nil) || (self.section?.editable == true))
                {
                    if ((_editable == nil) || (_editable == true))
                    {
                        return true
                    }
                }
            }
            return false
        }
        set(newValue)
        {
            _editable = newValue
        }
    }

    override public init()
    {
        super.init()
    }

    public init(section:FBSection, lines:(Int, Int))
    {
        super.init()
        
        self.section = section
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
        let file = self.section!.form!.file!
        self.style!.parent = self.section!.style // override the default parents, our styles always descend from the style of the parent object!
        
        var i:Int = lines.0
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
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
                self.style!.parent = self.section!.style // override the default parents, our styles always descend from the style of the parent object!
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (file.lines[i].value.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Field:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                var fieldRange = (i, i)
                var fieldType:FBFieldType = FBFieldType.Unknown
                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel) ||
                        (file.lines[i].keyword == FBKeyWord.None))
                    {
                        if (file.lines[i].keyword == FBKeyWord.FieldType)
                        {
                            fieldType = FBField.typeWith(string: file.lines[i].value)
                        }
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                fieldRange.1 = i - 1
                
                switch (fieldType)
                {
                case FBFieldType.Section:
                    break
                case FBFieldType.Heading:
                    let field:FBHeadingField = FBHeadingField(line: self, lines: fieldRange)
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.Label:
                    let field:FBLabelField = FBLabelField(line: self, lines: fieldRange)
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.Text:
                    let field:FBTextField = FBTextField(line: self, lines: fieldRange)
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.TextArea:
                    let field:FBTextAreaField = FBTextAreaField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.ComboBox:
                    let field:FBComboBoxField = FBComboBoxField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.CheckBox:
                    let field:FBCheckBoxField = FBCheckBoxField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.Image:
                    let field:FBImageField = FBImageField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.ImagePicker:
                    let field:FBImagePickerField = FBImagePickerField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.OptionSet:
                    let field:FBOptionSetField = FBOptionSetField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.DatePicker:
                    let field:FBDatePickerField = FBDatePickerField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.Signature:
                    let field:FBSignatureField = FBSignatureField(line: self, lines: fieldRange)
                    field.line = self
                    self.fields.append(field as FBField)
                    
                    break
                case FBFieldType.Unknown:
                    
                    break
                }
                
                break
            default:
                i += 1
                break
            }
        }
    }
    
    func initWith(section:FBSection, id:String) -> FBLine
    {
        self.section = section
        self.id = id  as String
        self.visible = true
        self.style = FBStyleClass(withClass:FBStyleSet.shared.style(named: self.tag!)!)
        self.style!.parent = self.section!.style // override the default parents, our styles always descend from the style of the parent object!
        
        return self
    }
    
    func equals(value:String) -> Bool
    {
        return Bool(self.id.lowercased() == value.lowercased())
    }
    
    func field(named:String) -> FBField?
    {
        for field in self.fields
        {
            if (field.id.lowercased() == named.lowercased())
            {
                return field
            }
        }
        return nil
    }
    
    func visibleFields() -> Array<FBField>
    {
        var visible:Array<FBField> = Array<FBField>()
        for field in fields
        {
            if (field.visible == true)
            {
                visible.append(field)
            }
        }
        return visible
    }
    
    func fieldCount() -> Int
    {
        return self.visibleFields().count 
    }
    
    func height() -> CGFloat
    {
        var height:CGFloat = 0.0
        for field in self.visibleFields()
        {
            if (field.view == nil)
            {
                height = 50.0
            }
            else
            {
                if (field.view!.height() > height)
                {
                    height = field.view!.height()
                }
            }
        }
        return height
    }
}
