//
//  FBStyleSet.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/5/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class FBStyleSet: NSObject
{
    var classes:Array<FBStyleClass> = Array<FBStyleClass>()
    
    // initialize as a singleton...
    class var shared:FBStyleSet
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
    
    func load(file: String)
    {
        let podBundle = Bundle.init(for: self.classForCoder)
        let path = podBundle.url(forResource: "Style", withExtension: "css")
        let css = SwiftCSS(CssFileURL: path!)
        for item in css.parsedCss
        {
            print(item)
            let style:FBStyleClass = FBStyleClass()
            style.name = item.key
            style.properties = item.value as NSDictionary
            self.classes.append(style)
        }
        
        // go back and set the parents...
        for style in self.classes
        {
            if (style.properties!.value(forKey: "parent") != nil)
            {
                style.parent = self.style(named: style.properties!.value(forKey: "parent") as! String)
            }
        }

        
        /*
        if let bundleURL = podBundle.url(forResource: "FormBuilder", withExtension: "bundle") {
            if let bundle = Bundle.init(url: bundleURL) {
                //return UINib(nibName: "MyView", bundle: bundle).instantiate(withOwner: self, options: nil)[0] as? MyView
                let path = bundle.url(forResource: "Style", withExtension: "css")
                let css = SwiftCSS(CssFileURL: path!)
                for item in css.parsedCss
                {
                    print(item)
                    let style:FBStyleClass = FBStyleClass()
                    style.name = item.key
                    style.properties = item.value as NSDictionary
                    self.classes.append(style)
                }
                
                // go back and set the parents...
                for style in self.classes
                {
                    if (style.properties!.value(forKey: "parent") != nil)
                    {
                        style.parent = self.style(named: style.properties!.value(forKey: "parent") as! String)
                    }
                }

                
            } else {
                assertionFailure("Could not load the bundle")
                //return nil
            }
        }else {
            assertionFailure("Could not create a path to the bundle")
            //return nil
        }
        */
        
        /*
        let path = Bundle.main.url(forResource: file, withExtension: "css")
        
        let podBundle = Bundle.init(for: self.classForCoder) // Bundle.init(identifier: "FormBuilder")
        
        if let bundleURL = podBundle.url(forResource: "Style", withExtension: "css") {
            
            if let bundle = Bundle.init(url: bundleURL) {
                
                let path = bundle.url(forResource: file, withExtension: "css")
                //2.Get parsed CSS
                let css = SwiftCSS(CssFileURL: path!)
                //3.Use it
                
                for item in css.parsedCss
                {
                    print(item)
                    let style:FBStyleClass = FBStyleClass()
                    style.name = item.key
                    style.properties = item.value as NSDictionary
                    self.classes.append(style)
                }
                
                // go back and set the parents...
                for style in self.classes
                {
                    if (style.properties!.value(forKey: "parent") != nil)
                    {
                        style.parent = self.style(named: style.properties!.value(forKey: "parent") as! String)
                    }
                }

                //let cellNib = UINib(nibName: classNameToLoad, bundle: bundle)
                //self.collectionView!.registerNib(cellNib, forCellWithReuseIdentifier: classNameToLoad)
                
            }else {
                
                assertionFailure("Could not load the bundle")
                
            }
            
        }else {
            
            assertionFailure("Could not create a path to the bundle")
            
        } */
    }
}
