//
//  FBFileLine.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/3/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBKeyWord:Int
{
    case Unknown = 0
    case None = 1
    case Style = 2
    case Editable = 3
    case Visible = 4
    case Section = 5
    case Line = 6
    case Field = 7
    case Id = 8
    case Title = 9
    case Collapsible = 10
    case Collapsed = 11
    case AllowsAdd = 12
    case AddItems = 13
    case FieldType = 14
    case Caption = 15
    case Required = 16
    case Value = 17
    case Requirements = 18
    case Minimum = 19
    case Maximum = 20
    case Format = 21
    case DataType = 22
    case MemberOf = 23
    case OptionSet = 24
    case Option = 25
    case PickerMode = 26
    case DateMode = 27
    case Image = 28
    case Label = 29
    case Signature = 30
    case Capitalize = 31
    case Keyboard = 32
}

public class FBFileLine: NSObject
{
    public var indentLevel:Int = 0
    public var spaceLevel:Int = 0
    public var keyword:FBKeyWord = FBKeyWord.None
    public var value:String = ""
    public var comment:String = ""
    public var continued:Bool = false
    
    public override init()
    {
        super.init()
        
    }
    
    public init(line:String)
    {
        super.init()
        self.load(line: line, continued: false)
    }
    
    public init(line:String, continued:Bool)
    {
        super.init()
        self.load(line: line, continued: continued)
    }
    
    public func load(line: String, continued:Bool)
    {
        // shortcut for comment lines
        if (line.trimmingCharacters(in: CharacterSet.whitespaces).hasPrefix("//"))
        {
            self.comment = line
            self.keyword = .None
            self.value = ""
            return
        }
        // shortcut for blank lines
        if (line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
        {
            self.comment = ""
            self.keyword = .None
            self.value = ""
            return
        }
        var text = line

        // get indentation level
        var first = ""
        repeat
        {
            first = text.first?.description ?? ""
            if (first == "\t")
            {
                text.removeFirst()
                indentLevel += 1
            }
        } while (first == "\t")
        // get space level
        repeat
        {
            first = text.first?.description ?? ""
            if (first == " ")
            {
                text.removeFirst()
                spaceLevel += 1
            }
        } while (first == " ")
        // get the keyword for this line
        var tokens = text.split(separator: " ")
        
        if (!continued && (tokens.count > 0))
        {
            
            switch (tokens.first?.lowercased())
            {
            case "style":
                self.keyword = FBKeyWord.Style
                break
            case "editable":
                self.keyword = FBKeyWord.Editable
                break
            case "visible":
                self.keyword = FBKeyWord.Visible
                break
            case "section":
                self.keyword = FBKeyWord.Section
                break
            case "line":
                self.keyword = FBKeyWord.Line
                break
            case "field":
                self.keyword = FBKeyWord.Field
                break
            case "id":
                self.keyword = FBKeyWord.Id
                break
            case "title":
                self.keyword = FBKeyWord.Title
                break
            case "collapsible":
                self.keyword = FBKeyWord.Collapsible
                break
            case "collapsed":
                self.keyword = FBKeyWord.Collapsed
                break
            case "allows-add":
                self.keyword = FBKeyWord.AllowsAdd
                break
            case "add-items":
                self.keyword = FBKeyWord.AddItems
                break
            case "type":
                self.keyword = FBKeyWord.FieldType
                break
            case "caption":
                self.keyword = FBKeyWord.Caption
                break
            case "required":
                self.keyword = FBKeyWord.Required
                break
            case "value":
                self.keyword = FBKeyWord.Value
                break
            case "requirements":
                self.keyword = FBKeyWord.Requirements
                break
            case "minimum":
                self.keyword = FBKeyWord.Minimum
                break
            case "maximum":
                self.keyword = FBKeyWord.Maximum
                break
            case "format":
                self.keyword = FBKeyWord.Format
                break
            case "data-type":
                self.keyword = FBKeyWord.DataType
                break
            case "member-of":
                self.keyword = FBKeyWord.MemberOf
                break
            case "option-set":
                self.keyword = FBKeyWord.OptionSet
                break
            case "option":
                self.keyword = FBKeyWord.Option
                break
            case "picker-mode":
                self.keyword = FBKeyWord.PickerMode
                break
            case "date-mode":
                self.keyword = FBKeyWord.DateMode
                break
            case "image":
                self.keyword = FBKeyWord.Image
                break
            case "label":
                self.keyword = FBKeyWord.Label
                break
            case "signature":
                self.keyword = FBKeyWord.Signature
                break
            case "capitalize":
                self.keyword = FBKeyWord.Capitalize
                break
            case "keyboard":
                self.keyword = FBKeyWord.Keyboard
                break 
            default:
                self.keyword = FBKeyWord.Unknown
                break
            }
            tokens.removeFirst()
        }
        
        var inComment:Bool = false
        while (tokens.count > 0)
        {
            if (tokens.first?.hasPrefix("//") == true)
            {
                inComment = true
                self.comment = self.comment + (tokens.first?.description)!
                tokens.removeFirst()
            }
            else if ((tokens.first?.description == "_") && !inComment)
            {
                self.continued = true
                tokens.removeAll()
            }
            else if (inComment)
            {
                self.comment = self.comment + (tokens.first?.description)!
                tokens.removeFirst()
                if (tokens.count > 0)
                {
                    self.comment = self.comment + " "
                }
            }
            else
            {
                self.value = self.value + (tokens.first?.description.trimmingCharacters(in: CharacterSet.whitespaces))!
                tokens.removeFirst()
                if (tokens.count > 0)
                {
                    self.value = self.value + " "
                }
            }
        }
        self.value = self.value.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
