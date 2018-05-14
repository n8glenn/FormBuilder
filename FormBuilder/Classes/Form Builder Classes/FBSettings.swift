//
//  FBSettings.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/21/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBSettings: NSObject
{
    var editable:Bool = true
    var dateFormat:String = "yyyy-MM-dd"
    var timeFormat:String = "hh:mm:ss a"
    var dateTimeFormat:String = "yyyy-MM-dd hh:mm:ss a"
    
    var formats:Dictionary<String, String> = Dictionary<String, String>()
    var optionSet:Dictionary<String, FBOptionSet> = Dictionary<String, FBOptionSet>()
    
    class var sharedInstance: FBSettings
    {
        struct Singleton
        {
            static let instance = FBSettings(file: "Settings")
        }
        return Singleton.instance
    }

    public init(file:String)
    {
        super.init()
        
        let settingsFile:FBFile = FBFile(file: file)
        
        var i:Int = 0
        
        while (i < settingsFile.lines.count)
        {
            switch (settingsFile.lines[i].keyword)
            {
            case FBKeyWord.Format:
                let indentLevel:Int = settingsFile.lines[i].indentLevel
                let spaceLevel:Int = settingsFile.lines[i].spaceLevel
                i += 1
                var key:String? = nil
                var value:String? = nil
                while (i < settingsFile.lines.count)
                {
                    if ((settingsFile.lines[i].indentLevel > indentLevel) ||
                        (settingsFile.lines[i].spaceLevel > spaceLevel))
                    {
                        if (settingsFile.lines[i].keyword == FBKeyWord.Id)
                        {
                            key = settingsFile.lines[i].value
                        }
                        if (settingsFile.lines[i].keyword == FBKeyWord.Value)
                        {
                            value = settingsFile.lines[i].value
                        }
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                if (key != nil && value != nil)
                {
                    self.formats.updateValue(value!, forKey: key!)
                }
                
                break
            case FBKeyWord.OptionSet:
                let indentLevel:Int = settingsFile.lines[i].indentLevel
                let spaceLevel:Int = settingsFile.lines[i].spaceLevel
                i += 1
                var optionSetRange = (i, i)
                var optionId:String = ""
                var inOption:Bool = false
                while (i < settingsFile.lines.count)
                {
                    if ((settingsFile.lines[i].indentLevel > indentLevel) ||
                        (settingsFile.lines[i].spaceLevel > spaceLevel))
                    {
                        if ((settingsFile.lines[i].keyword == FBKeyWord.Id) && !inOption)
                        {
                            optionId = settingsFile.lines[i].value
                        }
                        else if (settingsFile.lines[i].keyword == FBKeyWord.Option)
                        {
                            inOption = true
                        }
                        i += 1
                    }
                    else
                    {
                        break
                    }
                }
                optionSetRange.1 = i - 1
                self.optionSet[optionId] = FBOptionSet(field: nil, file: settingsFile, lines: optionSetRange)
                break
            default:
                i += 1
                
                break
            }
        }
    }

    /*
    func load(file: String)
    {
        var formDict: NSDictionary?
        let podBundle = Bundle.init(for: self.classForCoder)
        if let path = podBundle.path(forResource: file, ofType: "spec")
        {
            formDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = formDict
        {
            // get sections of form here
            if (dict.value(forKey: "editable") != nil)
            {
                self.editable = dict.value(forKey: "editable") as! Bool
            }
            if (dict.value(forKey: "date-format") != nil)
            {
                self.dateFormat = (dict.value(forKey: "date-format") as? String)!
            }
            if (dict.value(forKey: "time-format") != nil)
            {
                self.timeFormat = (dict.value(forKey: "time-format") as? String)!
            }
            if (dict.value(forKey: "date-time-format") != nil)
            {
                self.dateTimeFormat = (dict.value(forKey: "date-time-format") as? String)!
            }
            if (dict.value(forKey: "Formats") != nil)
            {
                self.formats = dict.value(forKey: "Formats") as! NSDictionary
            }
            if (dict.value(forKey: "Options") != nil)
            {
                self.optionSets = dict.value(forKey: "Options") as! NSDictionary
            }
        }
    }
     */
}
