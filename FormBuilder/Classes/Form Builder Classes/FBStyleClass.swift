//
//  FBStyleClass.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBStyleClass: NSObject
{
    @objc var parent:FBStyleClass? = nil
    var name:String? = nil 
    var properties:NSDictionary? = nil
    
    override public init()
    {
        super.init()
    }
    
    public init(withClass: FBStyleClass)
    {
        super.init()
        self.name = withClass.name
        if (withClass.properties != nil)
        {
            self.properties = NSDictionary(dictionary: withClass.properties!)
        }
        self.parent = withClass.parent
    }
    
    override public func value(forKey: String) -> Any?
    {
        if (properties?.value(forKey: forKey) != nil)
        {
            return properties?.value(forKey: forKey)
        }
        else
        {
            if (parent != nil)
            {
                return parent?.value(forKey:forKey)
            }
            else
            {
                return nil 
            }
        }
    }
    
    var font:UIFont
    {
        get
        {
            let name:String = self.value(forKey: "font-family") as? String ?? "Helvetica"
            let size:CGFloat = self.value(forKey: "font-size") as? CGFloat ?? 17.0
            return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: 17.0)
        }
    }
    
    var inputFont:UIFont
    {
        get
        {
            let name:String = self.value(forKey: "input-font-family") as? String ?? "Helvetica"
            let size:CGFloat = self.value(forKey: "input-font-size") as? CGFloat ?? 17.0
            return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: 17.0)
        }
    }
    
    var orientation:FBOrientation
    {
        get
        {
            let name:String? = self.value(forKey: "orientation") as? String
            
            if (name != nil)
            {
                switch (name!.lowercased())
                {
                case "horizontal":
                    return FBOrientation.Horizontal
                case "vertical":
                    return FBOrientation.Vertical
                case "reverse-horizontal":
                    return FBOrientation.ReverseHorizontal
                case "reverse-vertical":
                    return FBOrientation.ReverseVertical
                case "placeholder":
                    return FBOrientation.PlaceHolder
                default:
                    return FBOrientation.Horizontal
                }
            }
            else
            {
                return FBOrientation.Horizontal
            }
        }
    }
    
    func viewFor(type:FBFieldType) -> String
    {
        switch (type)
        {
        case FBFieldType.Section:
            return self.value(forKey: "section-header-view") as? String ?? "SectionHeaderView"

        case FBFieldType.Heading:
            return self.value(forKey: "heading-view") as? String ?? "HeadingView"

        case FBFieldType.Label:
            return self.value(forKey: "label-view") as? String ?? "LabelView"

        case FBFieldType.Text:
            return self.value(forKey: "textfield-view") as? String ?? "TextFieldView"

        case FBFieldType.TextArea:
            return self.value(forKey: "textarea-view") as? String ?? "TextAreaView"

        case FBFieldType.ComboBox:
            return self.value(forKey: "combobox-view") as? String ?? "ComboBoxFieldView"

        case FBFieldType.CheckBox:
            return self.value(forKey: "checkbox-view") as? String ?? "CheckBoxView"

        case FBFieldType.OptionSet:
            return self.value(forKey: "optionset-view") as? String ?? "OptionSetView"

        case FBFieldType.Image:
            return self.value(forKey: "image-view") as? String ?? "ImageView"

        case FBFieldType.ImagePicker:
            return self.value(forKey: "imagepicker-view") as? String ?? "ImagePickerView"

        case FBFieldType.DatePicker:
            return self.value(forKey: "datepicker-view") as? String ?? "DatePickerView"

        case FBFieldType.Signature:
            return self.value(forKey: "signature-view") as? String ?? "FBSignatureView"

        case FBFieldType.Unknown:
            return ""
        }
    }
}
