//
//  Requirement.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBRequirementType:Int
{
    case Required = 0
    case Minimum = 1
    case Maximum = 2
    case Datatype = 3
    case Format = 4
    case MemberOf = 5
}

class FBRequirement: NSObject
{
    // Requirement -- Represents a condition that can be placed on a field.
    var type:FBRequirementType = FBRequirementType.Minimum;
    var value:Any? = nil;
    var members:Array<String> = Array<String>()

    override public init()
    {
        super.init()
    }
    
    public init(line:FBFileLine)
    {
        super.init()
        
        switch (line.keyword)
        {
        case FBKeyWord.Required:
            self.type = FBRequirementType.Required
            
            break
        case FBKeyWord.Minimum:
            self.type = FBRequirementType.Minimum
            
            break
        case FBKeyWord.Maximum:
            self.type = FBRequirementType.Maximum
            
            break
        case FBKeyWord.Format:
            self.type = FBRequirementType.Format
            
            break
        case FBKeyWord.MemberOf:
            self.type = FBRequirementType.MemberOf
            
            break
        default:
            
            break
        }
        self.value = line.value
    }
    
    func requirementTypeWith(string:String) -> FBRequirementType
    {
        switch (string.lowercased())
        {
        case "required":
            return FBRequirementType.Required
            
        case "minimum":
            return FBRequirementType.Minimum
            
        case "maximum":
            return FBRequirementType.Maximum
            
        case "datatype":
            return FBRequirementType.Datatype
            
        case "format":
            return FBRequirementType.Format
            
        case "memberof":
            return FBRequirementType.MemberOf
            
        default:
            return FBRequirementType.Required
        }
    }

    func satisfiedBy(field:FBField) -> Bool
    {
        switch (field.fieldType)
        {
        case FBFieldType.ImagePicker:
            switch (self.type)
            {
            case FBRequirementType.Required:
                /*
                if ((field.input == nil) || (field.input as! String).isEmpty)
                {
                    return false
                }
                */
                break
            case FBRequirementType.Minimum:
                if (field.input != nil)
                {
                    if ((field.input as! NSData).length < (self.value as! Int))
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.Maximum:
                if (field.input != nil)
                {
                    if ((field.input as! NSData).length > (self.value as! Int))
                    {
                        return false
                    }
                }
                break
            default:
                break
            }
            break
        case FBFieldType.Text, FBFieldType.TextArea:
            switch (self.type)
            {
            case FBRequirementType.Required:
                /*
                if ((field.input == nil) || (field.input as! String).isEmpty)
                {
                    return false
                }
                */
                break
            case FBRequirementType.Minimum:
                if (field.input != nil)
                {
                    if ((field.input as! String).count < Int(self.value as! String) ?? 0)
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.Maximum:
                if (field.input != nil)
                {
                    if ((field.input as! String).count > Int(self.value as! String) ?? 0)
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.Datatype:
                break
            case FBRequirementType.Format:
                if (field.input != nil)
                {
                    let format:String = FBSettings.shared.formats[self.value as! String]!
                    let emailTest = NSPredicate(format:"SELF MATCHES %@", format)
                    let valid:Bool = emailTest.evaluate(with: field.input as! String)
                    if (!valid)
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.MemberOf:
                if (field.input != nil)
                {
                    var found:Bool = false
                    let value:String = field.input as! String
                    for member in self.members
                    {
                        if (value == member)
                        {
                            found = true
                            break
                        }
                    }
                    if (!found)
                    {
                        return false
                    }
                    
                }
                break
            }
            break
        case FBFieldType.ComboBox, FBFieldType.CheckBox, FBFieldType.OptionSet, FBFieldType.Signature:
            switch (self.type)
            {
            case FBRequirementType.Required:
                /*
                if (field.input == nil)
                {
                    return false
                }
                */
                break
            default:
                break
            }
            break
        case FBFieldType.DatePicker:
            switch (self.type)
            {
            case FBRequirementType.Required:
                /*
                if (field.input == nil)
                {
                    return false
                }
                */
                break
            case FBRequirementType.Minimum:
                if (field.input != nil)
                {
                    let minDate:Date = self.value as! Date
                    let date:Date = field.input as! Date
                    if (date.compare(minDate) == ComparisonResult.orderedAscending)
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.Maximum:
                if (field.input != nil)
                {
                    let maxDate:Date = self.value as! Date
                    let date:Date = field.input as! Date
                    if (date.compare(maxDate) == ComparisonResult.orderedDescending)
                    {
                        return false
                    }
                }
                break
            case FBRequirementType.Format:
                if (field.input != nil)
                {
                    let format:String = FBSettings.shared.formats[self.value as! String]!
                    let emailTest = NSPredicate(format:"SELF MATCHES %@", format)
                    let valid:Bool = emailTest.evaluate(with: field.input as! String)
                    if (!valid)
                    {
                        return false
                    }
                }
                break
            default:
                break
            }

            break
        default:
            break
        }

        
        return true
    }
}
