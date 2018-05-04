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
    var headerView:SectionHeaderView?
    var allowsAdd:Bool = false
    var allowsRemove:Bool = false
    var addSection:Bool = false
    var addLine:Bool = false
    var fieldsToAdd:Array<FBFieldType> = Array<FBFieldType>()
    var dictionary:NSDictionary?
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
    
    func initWith(form:FBForm, dictionary:NSDictionary) -> FBSection
    {
        self.dictionary = dictionary 
        self.form = form
        self.id = dictionary.value(forKey: "id") as! String
        self.title = dictionary.value(forKey: "title") as? String
        if (dictionary.value(forKey: "visible") != nil)
        {
            self.visible = (dictionary.value(forKey: "visible") as? Bool)!
        }
        
        if (dictionary.value(forKey: "style") != nil)
        {
            self.tag = (dictionary.value(forKey: "style") as? String)!
        }
        
        self.style = FBStyleSet.shared.style(named: self.tag!)
        self.style!.parent = self.form!.style // override the default parents, our styles always descend from the style of the parent object!

        if (dictionary.value(forKey: "editable") != nil)
        {
            self.editable = (dictionary.value(forKey: "editable") as? Bool)!
        }
        if (dictionary.value(forKey: "collapsible") != nil)
        {
            self.collapsible = (dictionary.value(forKey: "collapsible") as? Bool)!
        }
        if (dictionary.value(forKey: "collapsed") != nil)
        {
            self.collapsed = (dictionary.value(forKey: "collapsed") as? Bool)!
        }
        if (dictionary.value(forKey: "allows-add") != nil)
        {
            self.allowsAdd = (dictionary.value(forKey: "allows-add") as? Bool)!
        }
        if (dictionary.value(forKey: "editable") != nil)
        {
            self.editable = (dictionary.value(forKey: "editable") as? Bool)!
        }
        if (dictionary.value(forKey: "add-items") != nil)
        {
            let fields:Array<String> = (dictionary.value(forKey: "add-items") as? Array<String>)!
            for field in fields
            {
                self.fieldsToAdd.append(FBField.typeWith(string: field))
            }
        }
        let linesArray:Array<NSDictionary>? = dictionary.value(forKey: "Lines") as? Array<NSDictionary>
        if (linesArray != nil)
        {
            for lineDict in linesArray!
            {
                let line:FBLine = FBLine().initWith(section:self, dictionary: lineDict)
                line.section = self 
                lines?.append(line)
            }
        }
        
        return self
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
