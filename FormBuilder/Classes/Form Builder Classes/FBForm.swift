//
//  UIForm.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBFormMode:Int
{
    case View = 0
    case Edit = 1
    case Print = 2
}

public enum FBOrientation:Int
{
    case Horizontal = 0
    case Vertical = 1
    case ReverseHorizontal = 2
    case ReverseVertical = 3
    case PlaceHolder = 4
}

public protocol FormDelegate: class
{
    func formLoaded()
    func updated(field:FBField, withValue:Any?)
}

public class FBForm: NSObject
{
    // UIForm -- this represents the entire form, it holds sections of fields, it has data
    //           and methods to be used by the user interface to facilitate displaying data,
    //           data entry, validation of data, etc.
    
    var tag:String? = "#Form"
    var style:FBStyleClass? = nil
    public var fields:Array<FBField> = Array<FBField>()
    public var sections:Array<FBSection> = Array<FBSection>()
    var mode:FBFormMode = FBFormMode.View
    var width:CGFloat = 0.0
    var file:FBFile? = nil
    var tableView:UITableView?
    private var _editable:Bool?
    var editable:Bool?
    {
        get
        {
            // this form is ONLY editable if none of its parents are explicitly set as NOT editable.
            if ((_editable == nil) || (_editable == true))
            {
                return true
            }
            return false
        }
        set(newValue)
        {
            _editable = newValue
        }
    }

    weak var delegate:FormDelegate?
    
    public init(file:String)
    {
        super.init()
        self.style = FBStyleSet.shared.style(named: self.tag!)
        self.style!.parent = FBStyleSet.shared.style(named: "#App") // override the default parents, our styles always descend from the style of the parent object!
        
        self.file = FBFile(file: file)
        
        var i:Int = 0
        while (i < self.file!.lines.count)
        {
            switch (self.file!.lines[i].keyword)
            {
            case FBKeyWord.Style:
                self.tag = self.file!.lines[i].value
                self.style = FBStyleSet.shared.style(named: self.tag!)
                i += 1
                
                break
            case FBKeyWord.Editable:
                self.editable = (self.file!.lines[i].value.lowercased() != "false")
                i += 1
                break
            case FBKeyWord.Section:
                let indentLevel:Int = self.file!.lines[i].indentLevel
                let spaceLevel:Int = self.file!.lines[i].spaceLevel
                i += 1
                var range = (i, i)
                while ((i < self.file!.lines.count) &&
                    ((self.file!.lines[i].indentLevel > indentLevel) ||
                        (self.file!.lines[i].spaceLevel > spaceLevel)))
                {
                    i += 1
                }
                range.1 = i - 1
                self.sections.append(FBSection(form: self, lines: range))
                break
            default:
                i += 1
                break
            }
        }
        if (delegate != nil)
        {
            delegate?.formLoaded()
        }
    }

    /*
    func load(file:String)
    {        
        // load the form, populate all of the sections, lines, fields, requirements, data, layout, etc.
        var formDict: NSDictionary?
        if let path = Bundle.main.path(forResource: file, ofType: "plist")
        {
            formDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = formDict
        {
            //self.style = FBStyle().initWith(parent: nil, item: self, dictionary: dict)
            if (dict.value(forKey: "style") != nil)
            {
                self.tag = (dict.value(forKey: "style") as? String)!
            }
            
            self.style = FBStyleSet.shared.style(named: self.tag!)

            if (dict.value(forKey: "editable") != nil)
            {
                self.editable = (dict.value(forKey: "editable") as? Bool)!
            }

            // get sections of form here
            let sectionArray:Any? = dict.value(forKey: "Sections")
            if (sectionArray != nil)
            {
                for sectionDict in (sectionArray as! Array<NSDictionary>)
                {
                    let section = FBSection().initWith(form:self, dictionary: sectionDict)
                    sections.append(section)
                }
            }
        }
        if (delegate != nil)
        {
            delegate?.formLoaded()
        }
    }
    */
    
    func validate() -> Array<FBException>
    {
        // loop through all of the fields in the form and validate each one.
        // return all of the exceptions found during validation.
        var exceptions:Array<FBException> = Array<FBException>()
        for section in self.visibleSections()
        {
            for line in section.visibleLines()
            {
                for field in line.visibleFields()
                {
                    let exception:FBException = field.validate()
                    if (exception.errors.count > 0)
                    {
                        exceptions.append(exception)
                    }
                }
            }
        }
        return exceptions
    }
    
    public func line(section:String, name:String) -> FBLine
    {
        return (self.section(named: section)?.line(named: name))!
    }
    
    public func section(named:String) -> FBSection?
    {
        for section in self.sections
        {
            if (section.id.lowercased() == named.lowercased())
            {
                return section
            }
        }
        return nil
    }
    
    public func line(withPath:String) -> FBLine?
    {
        var section:FBSection? = nil
        var path:Array<String> = withPath.components(separatedBy: ".")
        if (path.count > 0)
        {
            section = self.section(named: path[0])
        }
        if ((section != nil) && (path.count > 1))
        {
            return section?.line(named: path[1])
        }
        return nil
    }

    public func field(withPath:String) -> FBField?
    {
        var section:FBSection? = nil
        var line:FBLine? = nil
        var path:Array<String> = withPath.components(separatedBy: ".")
        if (path.count > 0)
        {
            section = self.section(named: path[0])
        }
        if ((section != nil) && (path.count > 1))
        {
            line = section?.line(named: path[1])
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
    
    func visibleSections() -> Array<FBSection>
    {
        var visible:Array<FBSection> = Array<FBSection>()
        for section in self.sections
        {
            if (section.visible == true)
            {
                visible.append(section)
            }
        }
        return visible 
    }
    
    func fieldCount() -> Int
    {
        var count:Int = 0
        for section in self.visibleSections()
        {
            count += section.lineCount()
        }
        return count
    }    
}
