//
//  InputField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/2/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class InputField: FBField
{
    private var _textViewHeight:CGFloat = 90.0
    var requirements:Array<FBRequirement>? = Array<FBRequirement>()
    var valid:Bool = true

    private var _required:Bool = false
    override var required:Bool
    {
        get
        {
            return _required 
        }
        set(newValue)
        {
            _required = newValue
        }
    }

    private var _data:Any? = nil
    override var data:Any?
    {
        get
        {
            return _data
        }
        set(newValue)
        {
            _data = newValue
            self.line?.section?.form?.delegate?.updated(field: self, withValue: newValue)
        }
    }
    
    private var _editable:Bool?
    var editable:Bool?
    {
        get
        {
            // this field is ONLY editable if none of its parents are explicitly set as NOT editable.
            if ((self.line?.section?.form?.editable == nil) || (self.line?.section?.form?.editable == true))
            {
                if ((self.line?.section?.editable == nil) || (self.line?.section?.editable == true))
                {
                    if ((self.line?.editable == nil) || (self.line?.editable == true))
                    {
                        if ((_editable == nil) || (_editable == true))
                        {
                            return true
                        }
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
    override var mode:FBFormMode
    {
        get
        {
            if ((self.line?.section?.form?.mode == FBFormMode.Edit) && self.editable!)
            {
                return FBFormMode.Edit
            }
            else if (self.line?.section?.form?.mode == FBFormMode.Print)
            {
                return FBFormMode.Print
            }
            else
            {
                return FBFormMode.View
            }
        }
    }
    
    override var editing:Bool
    {
        get
        {
            return ((self.mode == FBFormMode.Edit) && (self.editable)!)
        }
    }
    
    var textViewHeight:CGFloat
    {
        get
        {
            var height:CGFloat = (self.data as! String).height(withConstrainedWidth:
                self.width - ((((self.style?.value(forKey: "margin") ?? 2.5) as! CGFloat) * 2) + self.borderWidth),
                                                               font: self.style!.font)
            if (height < _textViewHeight)
            {
                height = _textViewHeight
            }
            return height
        }
    }
    
    override public init()
    {
        super.init()
    }
    
    override public init(line:FBLine, lines:(Int, Int))
    {
        super.init(line:line, lines:lines)
        
        var i:Int = lines.0
        self.range = lines
        let file = self.line!.section!.form!.file!
        
        while (i <= lines.1)
        {
            switch (file.lines[i].keyword)
            {
            case FBKeyWord.Required:
                self.required = (file.lines[i].value.lowercased() == "true")
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (file.lines[i].value.lowercased() != "false")
                i += 1
                
                break
            case FBKeyWord.Requirements:
                let indentLevel:Int = file.lines[i].indentLevel
                let spaceLevel:Int = file.lines[i].spaceLevel
                i += 1
                while (i <= lines.1)
                {
                    if ((file.lines[i].indentLevel > indentLevel) ||
                        (file.lines[i].spaceLevel > spaceLevel))
                    {
                        self.requirements?.append(FBRequirement(line: file.lines[i]))
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                break
            default:
                i += 1
                
                break
            }
        }
    }

    /*
    override func initWith(line:FBLine, dictionary:NSDictionary) -> InputField
    {
        if (dictionary.value(forKey: "required") != nil)
        {
            self.required = (dictionary.value(forKey: "required") as? Bool)!
        }
        if (dictionary.value(forKey: "editable") != nil)
        {
            self.editable = (dictionary.value(forKey: "editable") as? Bool)!
        }
        if (dictionary.value(forKey: "Requirements") != nil)
        {
            let requirementsArray:Array<NSDictionary>? = dictionary.value(forKey: "Requirements") as? Array<NSDictionary>
            if (requirementsArray != nil)
            {
                for requirementDict in requirementsArray!
                {
                    requirements?.append(FBRequirement().initWith(dictionary: requirementDict))
                }
            }
        }
        return super.initWith(line: line, dictionary: dictionary) as! InputField
    }
    */
    
    override func validate() -> FBException
    {
        let exception:FBException = FBException()
        exception.field = self
        if (self.required == true)
        {
            if (!self.hasValue())
            {
                exception.errors.append(FBRequirementType.Required)
                return exception
            }
        }
        if (self.requirements != nil)
        {
            for requirement in (self.requirements)!
            {
                if (!requirement.satisfiedBy(field: self))
                {
                    exception.errors.append(requirement.type)
                }
            }
        }
        return exception
    }
    
    func hasValue() -> Bool
    {
        if (isNil(someObject: self.data))
        {
            return false
        }
        switch (self.fieldType)
        {
        case FBFieldType.CheckBox:
            return ((self.data is Bool) && (self.data as! Bool) == true)
            
        case FBFieldType.OptionSet, FBFieldType.ComboBox:
            return (self.data is Int)
            
        case FBFieldType.Text, FBFieldType.TextArea:
            return ((self.data is String) &&
                !(self.data as! String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
            
        default:
            return self.data != nil
        }
    }

}
