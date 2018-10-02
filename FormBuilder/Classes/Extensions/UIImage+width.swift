//
//  UIImage+width.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/31/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

extension UIImage
{
    
    func imageResize (sizeChange:CGSize)-> UIImage
    {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}

import UIKit

extension UIImage
{
    
    func resize(width : Double)-> UIImage?
    {
        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0
        
            maxWidth = width
            let per = (100.0 * width / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        
        let hasAlpha = true
        let scale: CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
}
