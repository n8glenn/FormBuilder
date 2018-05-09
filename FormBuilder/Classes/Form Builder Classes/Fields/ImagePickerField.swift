//
//  ImagePickerField.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBImagePickerMode:Int
{
    case Album = 0
    case Camera = 1
}

class ImagePickerField: InputField
{
    var imagePickerMode:FBImagePickerMode = FBImagePickerMode.Album

    static func imagePickerModeWith(string:String) -> FBImagePickerMode
    {
        switch (string.lowercased())
        {
        case "album":
            return FBImagePickerMode.Album
            
        case "camera":
            return FBImagePickerMode.Camera
            
        default:
            return FBImagePickerMode.Album
        }
    }

    override func initWith(line:FBLine, dictionary:NSDictionary) -> ImagePickerField
    {
        if (dictionary.value(forKey: "value") != nil)
        {
            self.data = dictionary.value(forKey: "value") as! UIImage
        }
        if (dictionary.value(forKey: "picker-mode") != nil)
        {
            self.imagePickerMode = ImagePickerField.imagePickerModeWith(string: dictionary.value(forKey: "picker-mode") as! String)
        }
        return super.initWith(line: line, dictionary: dictionary) as! ImagePickerField
    }
    
    var viewName:String
    {
        get
        {
            return self.style!.viewFor(type: self.fieldType)
        }
    }
    
    override var labelHeight:CGFloat
    {
        get
        {
            return self.caption!.height(withConstrainedWidth:
                self.width - (((self.style?.value(forKey: "margin") as! CGFloat) * 2) + self.borderWidth),
                                        font: self.style!.font)
        }
    }
}
