//
//  FBFile.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 5/3/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBFile: NSObject
{
    public var lines:Array<FBFileLine> = Array<FBFileLine>()
    
    public override init()
    {
        super.init()

    }
    
    public init(file:String)
    {
        super.init()
        self.load(file: file)
    }
    
    public func load(file: String)
    {
        var path:String? = nil
        path = Bundle.main.path(forResource: file, ofType: "spec")
        if (path == nil)
        {
            let bundle = Bundle.init(for: self.classForCoder)
            path = bundle.path(forResource: file, ofType: "spec")
        }
        if (path == nil)
        {
            return
        }
        
        do {
            let content:String = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            var textlines = content.split(separator: "\n")
            var continued:Bool = false
            while (textlines.count > 0)
            {
                let line:FBFileLine = FBFileLine.init(line: (textlines.first?.description)!, continued: continued)
                continued = line.continued
                lines.append(line)
                textlines.removeFirst()
            }
        } catch _ as NSError {
            return
        }
        
    }
}
