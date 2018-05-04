//
//  ImageView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/30/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class ImageView: FieldView
{
    @IBOutlet var label:UILabel?
    @IBOutlet var imageView:UIImageView?
    var image:UIImage?
    var field:ImageField?

    override func height() -> CGFloat
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let border:CGFloat = self.field?.style?.value(forKey: "border") as? CGFloat ?? 1.5

        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            return self.field!.labelHeight + (self.imageView?.image?.size.height ?? 20.0) + (margin * 3) + border
        }
    }
    
    override func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0

        self.label?.frame = CGRect(x: margin,
                                   y: margin,
                                   width: self.frame.width - (margin * 2),
                                   height: self.field!.labelHeight)
        self.imageView?.frame = CGRect(x: margin,
                                       y: (margin * 2) + self.field!.labelHeight,
                                       width: self.image!.size.width,
                                       height: self.image!.size.height)
    }
    
    func updateDisplay(label:String, image:UIImage)
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0

        self.label = UILabel()
        self.addSubview(self.label!)
        self.imageView = UIImageView()
        self.image = image.resize(width: Double(self.field!.width - (margin * 2)))
        self.imageView?.image = self.image
        self.addSubview(self.imageView!)
        self.label?.font = self.field!.style!.font
        self.label?.text = label
    }
}
