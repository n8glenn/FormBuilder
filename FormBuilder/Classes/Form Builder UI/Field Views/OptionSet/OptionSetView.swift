//
//  OptionSetView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/25/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class OptionSetView: FieldView, UIGestureRecognizerDelegate
{
    var field:OptionSetField?
    @IBOutlet var label:UILabel?
    @IBOutlet var requiredView:RequiredView?
    var optionViews:Dictionary<String, OptionView> = Dictionary<String, OptionView>()
    var optionLabels:Dictionary<String, UILabel> = Dictionary<String, UILabel>()
    var buttons:Array<UITapGestureRecognizer> = Array<UITapGestureRecognizer>()
    var labelButtons:Array<UITapGestureRecognizer> = Array<UITapGestureRecognizer>()
    var selectedId:String? = nil
    
    override func height() -> CGFloat
    {
        if (self.field!.line!.section!.collapsed)
        {
            return 0.0
        }
        else
        {
            let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0
            let border:CGFloat = (self.field?.style?.value(forKey: "border") as? CGFloat) ?? 5.0
            
            switch (self.field!.style!.orientation)
            {
            case FBOrientation.Horizontal:
                if (self.field!.editing)
                {
                    return (margin * 3) + (self.field!.labelHeight * 2) + border
                }
                else
                {
                    return (margin * 2) + self.field!.labelHeight + border
                }
                
            case FBOrientation.Vertical:
                if (self.field!.editing)
                {
                    return (margin * CGFloat(self.field?.optionSet?.options.count ?? 0 + 2)) +
                        (self.field!.labelHeight * CGFloat(self.field?.optionSet?.options.count ?? 0 + 1)) + border
                }
                else
                {
                    if (self.field!.data != nil)
                    {
                        return (margin * 3) + (self.field!.labelHeight * 2) + border
                    }
                    else
                    {
                        return (margin * 2) + self.field!.labelHeight + border
                    }
                }
                
            case FBOrientation.ReverseHorizontal:
                if (self.field!.editing)
                {
                    return (margin * 3) + (self.field!.labelHeight * 2) + border                }
                else
                {
                    return (margin * 2) + self.field!.labelHeight + border
                }
                
            case FBOrientation.ReverseVertical:
                if (self.field!.editing)
                {
                    return (margin * CGFloat(self.field?.optionSet?.options.count ?? 0 + 2)) +
                        (self.field!.labelHeight * CGFloat(self.field?.optionSet?.options.count ?? 0 + 1)) + border
                }
                else
                {
                    if (self.field!.data != nil)
                    {
                        return (margin * 3) + (self.field!.labelHeight * 2) + border
                    }
                    else
                    {
                        return (margin * 2) + self.field!.labelHeight + border
                    }
                }
                
            case FBOrientation.PlaceHolder:
                if (self.field!.editing)
                {
                    return (margin * 3) + (self.field!.labelHeight * 2) + border
                }
                else
                {
                    return (margin * 2) + self.field!.labelHeight + border
                }
            }
        }
    }
    
    func updateDisplay(label:String, optionSet:FBOptionSet, id:String?, required: Bool)
    {
        var index:Int = 0
        self.selectedId = id
        self.label = UILabel()
        self.label?.numberOfLines = 0
        self.addSubview(self.label!)
        self.requiredView = RequiredView()
        self.addSubview(self.requiredView!)
        self.label?.font = UIFont(name: self.field?.style!.value(forKey: "font-family") as! String,
                                  size: self.field?.style!.value(forKey: "font-size") as! CGFloat)
        self.label?.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "foreground-color") as! String)
        self.label!.text = label
        self.label?.sizeToFit()
        for option in self.field!.optionSet!.options
        {
            let optionView:OptionView = UIView.fromNib(withName: "OptionView")!
            optionView.option = option
            self.optionViews[option.id] = optionView
            self.addSubview(optionView)
            optionView.setNeedsDisplay()
            let label:UILabel = UILabel()
            label.font = UIFont(name: self.field?.style!.value(forKey: "input-font-family") as! String,
                                      size: self.field?.style!.value(forKey: "input-font-size") as! CGFloat)
            label.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "input-foreground-color") as! String)
            label.text = option.value
            label.sizeToFit()
            self.optionLabels[option.id] = label
            optionView.button = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            optionView.button!.delegate = self
            optionView.addGestureRecognizer(optionView.button!)
            optionView.isUserInteractionEnabled = self.field!.editing
            optionView.labelButton = UITapGestureRecognizer(target: self, action: #selector(self.handleLabelTap(_:)))
            optionView.labelButton!.delegate = self
            label.addGestureRecognizer(optionView.labelButton!)
            label.isUserInteractionEnabled = self.field!.editing
            self.buttons.append(optionView.button!)
            self.labelButtons.append(optionView.labelButton!)
            self.addSubview(label)
            if (id != nil)
            {
                if (option.id == id)
                {
                    optionView.state = FBCheckState.Checked
                }
            }
            index += 1
        }
        if (self.field!.editing)
        {
            // set this field to edit mode
            self.requiredView?.isHidden = !required
            for optionView in self.optionViews.values
            {
                optionView.isHidden = false
            }
            for label in self.optionLabels.values
            {
                label.isHidden = false
            }
        }
        else
        {
            // set this field to view mode
            self.requiredView?.isHidden = true
            for optionView in self.optionViews.values
            {
                optionView.isHidden = true
            }
            for label in self.optionLabels.values
            {
                label.isHidden = true
            }
            if (self.selectedId != nil)
            {
                self.optionLabels[self.selectedId!]?.isHidden = false
            }
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) 
    {
        if (self.delegate != nil)
        {
            var index:Int = 0
            for button in self.buttons
            {
                if (button == sender)
                {
                    break
                }
                else
                {
                    index += 1
                }
            }
            
            var id:String? = nil
            for optionView in self.optionViews.values
            {
                if (optionView.button == sender)
                {
                    optionView.state = FBCheckState.Checked
                    id = optionView.option?.id
                }
                else
                {
                    optionView.state = FBCheckState.Unchecked
                }
            }
            
            for optionView in self.optionViews.values
            {
                optionView.setNeedsDisplay()
            }
            self.field!.input = id ?? nil
        }
    }

    @objc func handleLabelTap(_ sender: UITapGestureRecognizer)
    {
        if (self.delegate != nil)
        {
            var index:Int = 0
            for button in self.labelButtons
            {
                if (button == sender)
                {
                    break
                }
                else
                {
                    index += 1
                }
            }
            
            var id:String? = nil
            for optionView in self.optionViews.values
            {
                if (optionView.labelButton == sender)
                {
                    optionView.state = FBCheckState.Checked
                    id = optionView.option?.id
                }
                else
                {
                    optionView.state = FBCheckState.Unchecked
                }
            }
            for optionView in self.optionViews.values
            {
                optionView.setNeedsDisplay()
            }
            self.field!.input = id ?? nil
        }
    }

    override func layoutSubviews()
    {
        self.label?.font = self.field!.style!.font
        let margin:CGFloat = (self.field?.style?.value(forKey: "margin") as? CGFloat) ?? 5.0

        switch (self.field!.style!.orientation)
        {
        case FBOrientation.Horizontal:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                              y: margin + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            if (self.field!.editing)
            {
                var left:CGFloat = 0.0
                let count:Int = self.optionViews.count
                var index:Int = 0
                let width:CGFloat = self.frame.width / CGFloat(count)
                for optionView in self.optionViews.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                }
                index = 0
                for labelView in self.optionLabels.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    labelView.frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    labelView.setNeedsDisplay()
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    let text:String = self.field?.optionSet?.option(named: (self.field?.data as? String) ?? "")?.value ?? ""
                    let width:CGFloat = text.width(withConstrainedHeight: self.field?.labelHeight ?? 0.0, font: self.optionLabels[self.field!.data as! String]!.font!)
                    
                    self.optionLabels[self.field!.data as! String]?.frame = CGRect(x: self.frame.width - (width + (margin * 2) + self.field!.requiredWidth),
                                                            y: margin,
                                                            width: width,
                                                            height: self.field!.labelHeight)

                }
            }
            
            break
        case FBOrientation.Vertical:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                              y: margin + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            if (self.field!.editing)
            {
                var left:CGFloat = 0.0
                let count:Int = self.optionViews.count
                var index:Int = 0
                let width:CGFloat = self.frame.width / CGFloat(count)
                var top:CGFloat = (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0)
                var labelTop:CGFloat = (margin * 2) + self.field!.labelHeight
                for optionView in self.optionViews.values
                {
                    left = margin
                    
                    optionView.frame = CGRect(x: left,
                                              y: top,
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    index += 1
                    optionView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }
                index = 0
                for labelView in self.optionLabels.values
                {
                    left = margin
                    
                    labelView.frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: labelTop,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    index += 1
                    labelView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }

            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! String]?.frame = CGRect(x: margin,
                                                                               y: (margin * 2) + self.field!.labelHeight,
                                                                               width: self.frame.width - (margin * 2),
                                                                               height: self.field!.labelHeight)
                }
            }

            break
        case FBOrientation.ReverseHorizontal:
            let width:CGFloat = (self.label?.text!.width(withConstrainedHeight: (self.field?.labelHeight)!, font: (self.label?.font)!))!

            self.label?.frame =  CGRect(x: self.frame.width - (width + (margin * 2) + self.field!.requiredWidth),
                                                               y: margin,
                                                               width: width,
                                                               height: self.field!.labelHeight)

            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                              y: margin + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            if (self.field!.editing)
            {
                var left:CGFloat = 0.0
                let count:Int = self.optionViews.count
                var index:Int = 0
                let width:CGFloat = self.frame.width / CGFloat(count)
                for optionView in self.optionViews.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    index += 1
                    optionView.setNeedsDisplay()
                }
                index = 0
                for labelView in self.optionLabels.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    labelView.frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    labelView.setNeedsDisplay()
                }

            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! String]?.frame = CGRect(x: margin,
                                                                               y: margin,
                                                                               width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                                                               height: self.field!.labelHeight)
                }
            }

            break
        case FBOrientation.ReverseVertical:
            self.label?.frame = CGRect(x: margin,
                                       y: self.frame.height - (margin + self.field!.labelHeight),
                                       width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                              y: self.frame.height - (margin + self.field!.labelHeight) + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            if (self.field!.editing)
            {
                var left:CGFloat = 0.0
                let count:Int = self.optionViews.count
                var index:Int = 0
                let width:CGFloat = self.frame.width / CGFloat(count)
                var top:CGFloat = margin + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0)
                var labelTop:CGFloat = margin
                for optionView in self.optionViews.values
                {
                    left = margin
                    
                    optionView.frame = CGRect(x: left,
                                              y: top,
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    index += 1
                    optionView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }
                index = 0
                for labelView in self.optionViews.values
                {
                    left = margin
                    
                    labelView.frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: labelTop,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    index += 1
                    labelView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! String]?.frame = CGRect(x: margin,
                                                                               y: margin,
                                                                               width: self.frame.width - (margin * 2),
                                                                               height: self.field!.labelHeight)
                    
                }
            }

            break
        case FBOrientation.PlaceHolder:
            self.label?.frame = CGRect(x: margin,
                                       y: margin,
                                       width: self.frame.width - ((margin * 3) + self.field!.requiredWidth),
                                       height: self.field!.labelHeight)
            self.requiredView?.frame = CGRect(x: self.frame.width - (self.field!.requiredWidth + margin),
                                              y: margin + ((self.field!.labelHeight / 2.0) - (self.field!.requiredHeight / 2.0)),
                                              width: self.field!.requiredWidth,
                                              height: self.field!.requiredHeight)
            if (self.field!.editing)
            {
                var left:CGFloat = 0.0
                let count:Int = self.optionViews.count
                var index:Int = 0
                let width:CGFloat = self.frame.width / CGFloat(count)
                for optionView in self.optionViews.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    index += 1
                    optionView.setNeedsDisplay()
                }
                index = 0
                for labelView in self.optionLabels.values
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    labelView.frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    labelView.setNeedsDisplay()
                }

            }
            else
            {
                if (self.field!.data != nil)
                {
                    let width:CGFloat = (self.optionLabels[self.field!.data as! String]?.text?.width(withConstrainedHeight: (self.field?.labelHeight)!, font: self.optionLabels.first!.value.font!))!
                    
                    self.optionLabels[self.field!.data as! String]?.frame = CGRect(x: self.frame.width - (width + (margin * 2) + self.field!.requiredWidth),
                                                                               y: margin,
                                                                               width: width,
                                                                               height: self.field!.labelHeight)
                    
                }
            }

            break
        }
    }
}
