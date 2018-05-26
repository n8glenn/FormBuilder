//
//  SignatureView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/10/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class SignatureView: FieldView, SignViewDelegate
{
    var field:SignatureField?
    @IBOutlet var label:UILabel?
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var requiredView:RequiredView?
    @IBOutlet var button:UIButton?
    var popover:Popover?
    
    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            let style:FBStyleClass = (FBStyleSet.shared.style(named: "#SignView"))!

            let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0
            let border:CGFloat = (self.field?.style?.value(forKey: "border") as? CGFloat) ?? 5.0
            //let signWidth:CGFloat = style.value(forKey: "width") as? CGFloat ?? 200.0
            let signHeight:CGFloat = style.value(forKey: "height") as? CGFloat ?? 50.0
            
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                return (margin * 3) + signHeight + border
                
            case FBOrientation.Vertical:
                return (margin * 3) + self.field!.labelHeight + signHeight + border
                
            case FBOrientation.ReverseHorizontal:
                return (margin * 3) + signHeight + border
                
            case FBOrientation.ReverseVertical:
                return (margin * 3) + self.field!.labelHeight + signHeight + border
                
            case FBOrientation.PlaceHolder:
                return (margin * 3) + signHeight + border
            }
        }
    }
    
    override open func layoutSubviews()
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        
        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label!.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width / 2,
                                       height: self.field!.labelHeight)
            self.button!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.imageView!.frame = CGRect(x: margin + self.label!.frame.size.width,
                                        y: margin,
                                        width: (self.frame.width / 2) - ((margin * 3.0) + self.field!.requiredWidth),
                                        height: self.frame.height - (margin * 2.0))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.Vertical:
            self.label!.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width / 2,
                                       height: self.field!.labelHeight)
            self.button!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.imageView!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: margin + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseHorizontal:
            let width:CGFloat = (self.label!.text?.width(withConstrainedHeight: self.field!.labelHeight, font: self.field!.style!.font))!
            self.label!.frame = CGRect(x: self.frame.width - ((margin * 2.0) + self.field!.requiredWidth + width),
                                       y: margin, width: width, height: self.field!.labelHeight)
            self.button!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.imageView!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.ReverseVertical:
            let width:CGFloat = (self.label!.text?.width(withConstrainedHeight: self.field!.labelHeight, font: self.field!.style!.font))!
            self.label!.frame = CGRect(x: margin,
                                       y: (margin * 2) + self.field!.labelHeight, width: width, height: self.field!.labelHeight)
            
            self.button!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.imageView!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (margin * 2) + self.field!.labelHeight + (self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        case FBOrientation.PlaceHolder:
            self.label!.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width / 2,
                                       height: self.field!.labelHeight)
            self.button!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.imageView!.frame = CGRect(x: margin,
                                        y: margin,
                                        width: self.frame.width - (margin * 2.0),
                                        height: self.frame.height - (margin * 2.0))
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        }
        
    }

    open func updateDisplay(label:String, signature:UIImage?, required: Bool)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.imageView = UIImageView()
        self.addSubview(self.imageView!)
        self.button = UIButton()
        self.button?.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        self.addSubview(self.button!)
        self.requiredView = RequiredView()
        self.addSubview(self.requiredView!)
        self.label!.text = label
        self.label?.sizeToFit()

        if (self.field!.editing)
        {
            // set this field to edit mode
            self.requiredView?.isHidden = !required
            self.button!.isUserInteractionEnabled = true
        }
        else
        {
            // set this field to view mode
            self.requiredView?.isHidden = true
            self.button!.isUserInteractionEnabled = false
        }
    }
    
    @objc @IBAction func buttonPressed()
    {
        let style:FBStyleClass = (FBStyleSet.shared.style(named: "#SignaturePopover"))!
        let width:CGFloat = style.value(forKey: "width") as! CGFloat
        let height:CGFloat = style.value(forKey: "height") as! CGFloat
        let backgroundColor:UIColor = UIColor.init(hexString: style.value(forKey: "background-color") as! String)!
        var image:UIImage? = nil;
        let signView:SignView = UIView.fromNib(withName: "SignView")!
        signView.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        if (self.field!.input != nil)
        {
            image = self.field!.input as! UIImage?
        }
        signView.updateDisplay()
        if (image != nil)
        {
            signView.signatureView?.signature = image
        }
        signView.backgroundColor = UIColor.white
        signView.delegate = self
        let rect:CGRect = self.convert(self.bounds, to: nil)
        var popoverType:PopoverType = PopoverType.down
        if (rect.origin.y > (self.window!.bounds.height / 2.0))
        {
            popoverType = PopoverType.up
        }
        else
        {
            popoverType = PopoverType.down
        }
        self.popover = Popover()
        let options = [
            .type(popoverType),
            .animationIn(0.2),
            .animationOut(0.2),
            .color(backgroundColor),
            ] as [PopoverOption]
        self.popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        self.popover!.show(signView, fromView: self.button!)
    }

    func signatureUpdated(image: UIImage)
    {
        self.imageView!.image = image
        self.field!.input = image
    }
    
    func cleared()
    {
        self.imageView!.image = UIImage()
        self.field!.input = nil
    }
    
    func dismiss()
    {
        popover?.dismiss()
    }
}
