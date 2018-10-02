//
//  UIColor-HexString.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/21/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    public convenience init?(hexString: String)
    {
        let r, g, b, a: CGFloat
        var color:String = hexString
        
        if !color.hasPrefix("#")
        {
            color = "#" + color
        }
        if color.count == 7
        {
            color = color + "FF"
        }
        if color.hasPrefix("#")
        {
            let start = hexString.index(color.startIndex, offsetBy: 1)
            let hexColor = String(color[start...])
            
            if hexColor.count == 8
            {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber)
                {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
