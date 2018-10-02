//
//  FBStyleSet.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBStyleSet: NSObject
{
    var classes:Array<FBStyleClass> = Array<FBStyleClass>()
    
    // initialize as a singleton...
    open class var shared:FBStyleSet
    {
        struct Singleton
        {
            static let instance = FBStyleSet()
        }
        return Singleton.instance;
    }
    
    func style(named: String) -> FBStyleClass?
    {
        for style in self.classes
        {
            if (style.name?.lowercased() == named.lowercased())
            {
                return style
            }
        }
        return nil
    }

    private override init()
    {
        super.init()
        self.load(file: "Style")
    }
    
    open func load(file: String)
    {
        var path:URL? = nil
        path = Bundle.main.url(forResource: file, withExtension: "css")
        if (path == nil)
        {
            let bundle = Bundle.init(for: self.classForCoder)
            path = bundle.url(forResource: file, withExtension: "css")
        }
        if (path == nil)
        {
            return
        }

        let css = SwiftCSS(CssFileURL: path!)
        for item in css.parsedCss
        {
            //print(item)
            if (self.style(named: item.key) == nil)
            {
                let style:FBStyleClass = FBStyleClass()
                style.name = item.key
                style.properties = item.value as NSDictionary
                self.classes.append(style)
            }
            else
            {
                let style:FBStyleClass = self.style(named: item.key)!
                let properties:NSMutableDictionary = NSMutableDictionary(dictionary: style.properties!)
                for v in item.value
                {
                    properties.setValue(v.value, forKey: v.key)
                }
                style.properties = NSDictionary(dictionary: properties)
            }
        }
        
        // go back and set the parents...
        for style in self.classes
        {
            if (style.properties!.value(forKey: "parent") != nil)
            {
                style.parent = self.style(named: style.properties!.value(forKey: "parent") as! String)
            }
        }        
    }
}
