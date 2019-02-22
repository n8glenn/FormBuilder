//
//  DatePickerView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/31/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FBDatePickerView: FBFieldView, FBDateViewDelegate
{
    var field:FBDatePickerField?
    @IBOutlet var label:UILabel?
    @IBOutlet var button:UIButton?
    @IBOutlet var dateLabel:UILabel?
    @IBOutlet var requiredView:FBRequiredView?
    var minimum:Date? = nil
    var maximum:Date? = nil
    var popover:Popover?
    
    override func height() -> CGFloat
    {
        let margin:CGFloat = self.field?.style?.value(forKey: "margin") as? CGFloat ?? 5.0
        let border:CGFloat = self.field?.style?.value(forKey: "border") as? CGFloat ?? 1.5

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            return (margin * 2) + self.field!.labelHeight + border
            
        case FBOrientation.Vertical:
            return (margin * 3) + self.field!.labelHeight + self.field!.textHeight + border
            
        case FBOrientation.ReverseHorizontal:
            return (margin * 2) + self.field!.labelHeight + border
            
        case FBOrientation.ReverseVertical:
            return (margin * 3) + field!.labelHeight + field!.textHeight + border
            
        case FBOrientation.PlaceHolder:
            return (margin * 2) + self.field!.labelHeight + border
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
            let width:CGFloat = (self.dateLabel!.text?.width(withConstrainedHeight: self.field!.labelHeight, font: self.field!.style!.font))!
            self.dateLabel!.frame = CGRect(x: self.frame.width - ((margin * 2.0) + self.field!.requiredWidth + width),
                                           y: margin, width: width, height: self.field!.labelHeight)
            self.dateLabel!.textAlignment = NSTextAlignment.right
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
            let width:CGFloat = (self.dateLabel!.text?.width(withConstrainedHeight: self.field!.labelHeight, font: self.field!.style!.font))!
            self.dateLabel!.frame = CGRect(x: margin,
                                           y: (margin * 2) + self.field!.labelHeight, width: width, height: self.field!.labelHeight)
            self.dateLabel!.textAlignment = NSTextAlignment.left
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
            self.dateLabel!.frame = CGRect(x: margin,
                                           y: margin,
                                           width: self.frame.width / 2,
                                           height: self.field!.labelHeight)
            self.dateLabel!.textAlignment = NSTextAlignment.left
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
            self.dateLabel!.frame = CGRect(x: margin,
                                           y: margin,
                                           width: self.frame.width / 2,
                                           height: self.field!.labelHeight)
            self.dateLabel!.textAlignment = NSTextAlignment.left
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
            let width:CGFloat = (self.dateLabel!.text?.width(withConstrainedHeight: self.field!.labelHeight, font: self.field!.style!.font))!
            self.dateLabel!.frame = CGRect(x: self.frame.width - ((margin * 2.0) + self.field!.requiredWidth + width),
                                           y: margin, width: width, height: self.field!.labelHeight)
            self.dateLabel!.textAlignment = NSTextAlignment.right
            self.requiredView?.frame = CGRect(x: self.frame.width - (margin + self.field!.requiredWidth),
                                              y: (self.frame.height / 2) - (self.field!.requiredHeight / 2),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            break
        }

    }
    
    open func updateDisplay(label:String, text:String, required:Bool)
    {
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.button = UIButton()
        self.button?.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
        self.addSubview(self.button!)
        self.requiredView = FBRequiredView()
        self.addSubview(self.requiredView!)
        self.dateLabel = UILabel()
        self.addSubview(self.dateLabel!)
        self.label?.font = self.field!.style!.font
        self.dateLabel?.font = self.field!.style!.font
        if (self.field!.editing)
        {
            self.button!.isUserInteractionEnabled = true
            self.requiredView!.isHidden = false
        }
        else
        {
            self.button!.isUserInteractionEnabled = false
            self.requiredView!.isHidden = true 
        }
        self.label?.text = label
        self.dateLabel?.text = text
        
        for requirement in self.field!.requirements!
        {
            switch (requirement.type)
            {
            case FBRequirementType.Minimum:
                self.minimum = requirement.value as? Date
                break
            case FBRequirementType.Maximum:
                self.maximum = requirement.value as? Date
                break
            default:
                break
            }
        }
    }
    
    @objc @IBAction func buttonPressed()
    {
        let style:FBStyleClass = (FBStyleSet.shared.style(named: "#DatePopover"))!
        let width:CGFloat = style.value(forKey: "width") as! CGFloat
        let height:CGFloat = style.value(forKey: "height") as! CGFloat
        let dateView = FBDateView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        var date:Date = Date()
        
        if ((self.field!.data != nil) && (self.field!.data as? String) != "")
        {
            let dateFormatter:DateFormatter = DateFormatter()
            switch (self.field!.dateType)
            {
            case FBDateType.Date:
                dateFormatter.dateFormat = style.value(forKey: "date-format") as? String
                break
            case FBDateType.Time:
                dateFormatter.dateFormat = style.value(forKey: "time-format") as? String
                break
            case FBDateType.DateTime:
                dateFormatter.dateFormat = style.value(forKey: "date-time-format") as? String
                break
            }
            date = dateFormatter.date(from: (self.field!.data as? String)!)!
        }
        let buttonColor:UIColor = UIColor.init(hexString: style.value(forKey: "button-color") as! String)!
        let backgroundColor:UIColor = UIColor.init(hexString: style.value(forKey: "background-color") as! String)!
        let textColor:UIColor = UIColor.init(hexString: style.value(forKey: "foreground-color") as! String)!
        dateView.updateDisplay(date: date, buttonColor:buttonColor , dateType: self.field!.dateType)
        dateView.backgroundColor = backgroundColor
        dateView.textColor = textColor
        
        dateView.delegate = self
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
        self.popover!.show(dateView, fromView: self.button!)
    }
    
    func selected(date: Date)
    {
        let style:FBStyleClass = (FBStyleSet.shared.style(named: "#DatePopover"))!

        let dateFormatter:DateFormatter = DateFormatter()
        switch (self.field!.dateType)
        {
        case FBDateType.Date:
            dateFormatter.dateFormat = style.value(forKey: "date-format") as? String
            break
        case FBDateType.Time:
            dateFormatter.dateFormat = style.value(forKey: "time-format") as? String
            break
        case FBDateType.DateTime:
            dateFormatter.dateFormat = style.value(forKey: "date-time-format") as? String
            break
        }
        self.dateLabel!.text = dateFormatter.string(from: date)
        self.field!.input = self.dateLabel!.text 
        self.setNeedsLayout()
    }
    
    func cleared()
    {
        self.dateLabel!.text = ""
        self.field!.input = nil
        self.setNeedsLayout()
    }

    func dismiss()
    {
        self.popover?.dismiss()
    }
}
