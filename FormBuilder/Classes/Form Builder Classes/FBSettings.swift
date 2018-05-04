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
    
    var formats:NSDictionary = NSDictionary()
    var optionSets:NSDictionary = NSDictionary()
    
    class var sharedInstance: FBSettings
    {
        struct Singleton
        {
            static let instance = FBSettings()
        }
        return Singleton.instance
    }
    
    private override init()
    {
        super.init()
        self.load(file: "Settings")
    }
    
    func load(file: String)
    {
        var formDict: NSDictionary?
        let podBundle = Bundle.init(for: self.classForCoder)
        if let path = podBundle.path(forResource: file, ofType: "plist")
        //if let path = Bundle.main.path(forResource: file, ofType: "plist")
        {
            formDict = NSDictionary(contentsOfFile: path)
            /*
             do
             {
             let data:NSData = try NSData(contentsOfFile: path)
             formDict = self.parseJSON(inputData: data)
             }
             catch
             {
             
             }
             */
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
}
