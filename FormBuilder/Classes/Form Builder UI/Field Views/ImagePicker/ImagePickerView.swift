//
//  ImagePickerView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/31/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class ImagePickerView: FieldView, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet var label:UILabel?
    @IBOutlet var button:UIButton?
    @IBOutlet var requiredView:RequiredView?
    @IBOutlet var clearButton:UIButton?
    
    //var image:UIImage?
    var field:ImagePickerField?
    var imagePicker:UIImagePickerController?
    
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
            if (self.field!.input != nil)
            {
                var width:CGFloat = (self.field?.caption!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.field?.style?.font)!))!
                if (width < 50.0 + border + (margin * 2))
                {
                    width = 50.0 + border + (margin * 2)
                }
                let resized:UIImage = (self.field!.input! as! UIImage).resize(width: Double(self.field!.width - ((margin * 4) + width + self.field!.requiredWidth)))!

                return resized.size.height + (margin * 2) + border
            }
            else
            {
                return (margin * 2) + border + 50.0
            }
        }
    }
    
    override open func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let border:CGFloat = self.field?.style?.value(forKey: "border") as? CGFloat ?? 1.5

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.field!.labelWidth,
                                       height: self.field!.labelHeight)
            /*
            self.label!.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - (margin * 2),
                                       height: self.field!.labelHeight)
            */
            if (self.field!.input != nil)
            {
                var width:CGFloat = (self.field?.caption!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.field?.style?.font)!))!
                if (width < 50.0 + border + (margin * 2))
                {
                    width = 50.0 + border + (margin * 2)
                }
                let resized:UIImage = (self.field!.input! as! UIImage).resize(width: Double(self.field!.width - ((margin * 4) + width + self.field!.requiredWidth)))!

                self.button!.frame = CGRect(x: self.frame.width - (resized.size.width + (margin * 2) + self.field!.requiredWidth),
                                        y: margin,
                                        width: resized.size.width,
                                        height: resized.size.height)
                if (self.clearButton != nil)
                {
                    self.clearButton!.frame = CGRect(x: margin,
                                                 y: (margin + resized.size.height) - 50.0, //self.frame.height - (50.0 + border + margin),
                                                 width: 50.0,
                                                 height: 50.0)
                }
            }
            else
            {
                self.button!.frame = CGRect(x: self.frame.width - (60.0 + (margin * 2) + self.field!.requiredWidth),
                                            y: margin,
                                            width: 60.0,
                                            height: 50.0)
            }
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2.0) - (self.field!.requiredHeight / 2.0),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.Vertical:
            break
        case FBOrientation.ReverseHorizontal:
            break
        case FBOrientation.ReverseVertical:
            break
        case FBOrientation.PlaceHolder:
            break
        }

    }
    
    open func updateDisplay(label:String, image:UIImage?)
    {
        let bundle = Bundle.init(for: self.classForCoder)
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.label?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.addSubview(self.label!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.label?.sizeToFit()
        if (image != nil)
        {
            self.field!.input = image!
        }
        self.label?.text = label
        self.button = UIButton()
        if (image != nil)
        {
            let width:CGFloat = (self.field?.caption!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.field?.style?.font)!))!
            let resized:UIImage = image!.resize(width: Double(self.field!.width - ((margin * 4) + width + self.field!.requiredWidth)))!
            self.button?.setImage(resized, for: UIControlState.normal)
            if (self.field!.editing)
            {
                self.clearButton = UIButton()
                self.clearButton?.addTarget(self, action: #selector(clearPressed), for: UIControlEvents.touchUpInside)
                self.clearButton?.setImage(UIImage.init(named: "trash", in: bundle, compatibleWith: nil), for: UIControlState.normal)
                self.addSubview(self.clearButton!)
            }
        }
        else
        {
            self.button?.setImage(UIImage.init(named: "camera", in: bundle, compatibleWith: nil), for: UIControlState.normal)
        }
        self.button?.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        self.addSubview(self.button!)
        if (self.field!.editing)
        {
            self.requiredView = RequiredView()
            self.addSubview(self.requiredView!)
            if (self.clearButton != nil)
            {
                self.clearButton?.isUserInteractionEnabled = true
            }
            self.button?.isUserInteractionEnabled = true
        }
        else
        {
            if (self.clearButton != nil)
            {
                self.clearButton?.isUserInteractionEnabled = false
            }
            self.button?.isUserInteractionEnabled = false 
        }
    }

    @objc @IBAction func buttonPressed()
    {
        self.imagePicker = UIImagePickerController()
        self.imagePicker!.delegate = self
        if (self.field!.imagePickerMode == FBImagePickerMode.Album)
        {
            self.imagePicker!.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        else
        {
            self.imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
        }
        self.imagePicker!.allowsEditing = true
        
        UIApplication.shared.keyWindow?.rootViewController?.present(imagePicker!, animated: true, completion: nil)
    }
    
    @objc @IBAction func clearPressed()
    {
        self.field!.input = nil
        if (self.delegate != nil)
        {
            self.delegate?.fieldHeightChanged()
        }
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let width:CGFloat = (self.field?.caption!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.field?.style?.font)!))!
        self.field!.input = image.resize(width: Double(self.field!.width - ((margin * 4) + width + self.field!.requiredWidth)))!
        self.button?.setImage((self.field!.input! as! UIImage), for: UIControlState.normal)
        self.button!.frame = CGRect(x: self.button!.frame.origin.x,
                                    y: self.button!.frame.origin.y,
                                    width: image.size.width,
                                    height: image.size.height)
        self.field?.input = image
        self.setNeedsLayout()
        if (self.delegate != nil)
        {
            self.delegate?.fieldHeightChanged()
        }
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let width:CGFloat = (self.field?.caption!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.field?.style?.font)!))!
        self.field!.input = image.resize(width: Double(self.field!.width - ((margin * 4) + width + self.field!.requiredWidth)))!
        self.button?.setImage((self.field!.input! as! UIImage), for: UIControlState.normal)
        self.button!.frame = CGRect(x: self.button!.frame.origin.x,
                                    y: self.button!.frame.origin.y,
                                    width: image.size.width,
                                    height: image.size.height)
        self.setNeedsLayout()
        if (self.delegate != nil)
        {
            self.delegate?.fieldHeightChanged()
        }
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.imagePicker?.dismiss(animated: true, completion: nil)
    }
}
