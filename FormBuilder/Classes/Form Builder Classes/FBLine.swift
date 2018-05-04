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
    var dictionary:NSDictionary?
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

    func initWith(section:FBSection, id:String) -> FBLine
    {
        self.section = section
        self.id = id  as String
        self.visible = true
        self.style = FBStyleSet.shared.style(named: self.tag!)
        self.style!.parent = self.section!.style // override the default parents, our styles always descend from the style of the parent object!
        
        return self
    }

    func initWith(section:FBSection, dictionary:NSDictionary) -> FBLine
    {
        self.dictionary = dictionary 
        self.section = section
        id = dictionary.value(forKey: "id")  as! String
        if (dictionary.value(forKey: "visible") != nil)
        {
            self.visible = (dictionary.value(forKey: "visible") as? Bool)!
        }
        if (dictionary.value(forKey: "tag") != nil)
        {
            self.tag = (dictionary.value(forKey: "tag") as? String)!
        }
        
        self.style = FBStyleSet.shared.style(named: self.tag!)
        self.style!.parent = self.section!.style // override the default parents, our styles always descend from the style of the parent object!

        let fieldsArray:Array<NSDictionary>? = dictionary.value(forKey: "Fields") as? Array<NSDictionary>
        if (fieldsArray != nil)
        {
            for fieldDict in fieldsArray!
            {
                let fieldType = FBField.typeWith(string: (fieldDict.value(forKey: "type") as? String)!)
                switch (fieldType)
                {
                case FBFieldType.Section:
                    break
                case FBFieldType.Heading:
                    let field:HeadingField = HeadingField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.Label:
                    let field:LabelField = LabelField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.Text:
                    let field:TextField = TextField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.TextArea:
                    let field:TextAreaField = TextAreaField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.ComboBox:
                    let field:ComboBoxField = ComboBoxField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.CheckBox:
                    let field:CheckBoxField = CheckBoxField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.Image:
                    let field:ImageField = ImageField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.ImagePicker:
                    let field:ImagePickerField = ImagePickerField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.OptionSet:
                    let field:OptionSetField = OptionSetField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.DatePicker:
                    let field:DatePickerField = DatePickerField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                case FBFieldType.Signature:
                    let field:SignatureField = SignatureField().initWith(line: self, dictionary: fieldDict)
                    field.line = self
                    fields.append(field as FBField)
                    break
                }
            }
        }
        
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
