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
    var optionViews:Array<OptionView> = Array<OptionView>()
    var optionLabels:Array<UILabel> = Array<UILabel>()
    var buttons:Array<UITapGestureRecognizer> = Array<UITapGestureRecognizer>()
    var labelButtons:Array<UITapGestureRecognizer> = Array<UITapGestureRecognizer>()
    
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

    func updateDisplay(label:String, optionSet:FBOptionSet, index:Int?, required: Bool)
    {
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
        var count:Int = 0
        for option in self.field!.optionSet!.options
        {
            let optionView:OptionView = UIView.fromNib(withName: "OptionView")!
            optionView.text = option.value
            self.optionViews.append(optionView)
            self.addSubview(optionView)
            optionView.setNeedsDisplay()
            let label:UILabel = UILabel()
            label.font = UIFont(name: self.field?.style!.value(forKey: "input-font-family") as! String,
                                      size: self.field?.style!.value(forKey: "input-font-size") as! CGFloat)
            label.textColor = UIColor.init(hexString: self.field?.style!.value(forKey: "input-foreground-color") as! String)
            label.text = option.value
            label.sizeToFit()
            self.optionLabels.append(label)
            let button = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            button.delegate = self
            optionView.addGestureRecognizer(button)
            optionView.isUserInteractionEnabled = self.field!.editing
            let labelButton = UITapGestureRecognizer(target: self, action: #selector(self.handleLabelTap(_:)))
            labelButton.delegate = self
            label.addGestureRecognizer(labelButton)
            label.isUserInteractionEnabled = self.field!.editing
            self.buttons.append(button)
            self.labelButtons.append(labelButton)
            self.addSubview(label)
            if (index != nil)
            {
                if (count == index)
                {
                    optionView.state = FBCheckState.Checked
                }
            }
            count += 1
        }
        if (self.field!.editing)
        {
            // set this field to edit mode
            self.requiredView?.isHidden = !required
            for optionView in self.optionViews
            {
                optionView.isHidden = false
            }
            for label in self.optionLabels
            {
                label.isHidden = false
            }
        }
        else
        {
            // set this field to view mode
            self.requiredView?.isHidden = true
            for optionView in self.optionViews
            {
                optionView.isHidden = true
            }
            for label in self.optionLabels
            {
                label.isHidden = true
            }
            if (index != nil)
            {
                self.optionLabels[index!].isHidden = false
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
            
            for option in self.optionViews
            {
                option.state = FBCheckState.Unchecked
            }
            self.optionViews[index].state = FBCheckState.Checked
            for option in self.optionViews
            {
                option.setNeedsDisplay()
            }
            self.field!.input = index
            //self.delegate?.optionSelected(field: self.field!, option: index)
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
            
            for option in self.optionViews
            {
                option.state = FBCheckState.Unchecked
            }
            self.optionViews[index].state = FBCheckState.Checked
            for option in self.optionViews
            {
                option.setNeedsDisplay()
            }
            self.field!.input = index
            //self.delegate?.optionSelected(field: self.field!, option: index)
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
                for optionView in self.optionViews
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    self.optionLabels[index].frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    let width:CGFloat = (self.optionLabels[self.field!.data as! Int].text?.width(withConstrainedHeight: (self.field?.labelHeight)!, font: self.optionLabels[0].font!))!
                    
                    self.optionLabels[self.field!.data as! Int].frame = CGRect(x: self.frame.width - (width + (margin * 2) + self.field!.requiredWidth),
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
                for optionView in self.optionViews
                {
                    left = margin
                    
                    optionView.frame = CGRect(x: left,
                                              y: top,
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    self.optionLabels[index].frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: labelTop,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! Int].frame = CGRect(x: margin,
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
                for optionView in self.optionViews
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    self.optionLabels[index].frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! Int].frame = CGRect(x: margin,
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
                for optionView in self.optionViews
                {
                    left = margin
                    
                    optionView.frame = CGRect(x: left,
                                              y: top,
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    self.optionLabels[index].frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: labelTop,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                    top += margin + self.field!.labelHeight
                    labelTop += margin + self.field!.labelHeight
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    self.optionLabels[self.field!.data as! Int].frame = CGRect(x: margin,
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
                for optionView in self.optionViews
                {
                    left = (width * CGFloat(index)) + (margin * CGFloat(index + 1))
                    optionView.frame = CGRect(x: left,
                                              y: (margin * 2) + self.field!.labelHeight + ((self.field!.labelHeight / 2.0) - self.field!.labelHeight / 4.0),
                                              width: self.field!.labelHeight / 2.0,
                                              height: self.field!.labelHeight / 2.0)
                    self.optionLabels[index].frame = CGRect(x: left + (self.field!.labelHeight / 2.0) + margin,
                                                            y: (margin * 2) + self.field!.labelHeight,
                                                            width: width - (self.field!.labelHeight + margin),
                                                            height: self.field!.labelHeight)
                    
                    index += 1
                    optionView.setNeedsDisplay()
                }
            }
            else
            {
                if (self.field!.data != nil)
                {
                    let width:CGFloat = (self.optionLabels[self.field!.data as! Int].text?.width(withConstrainedHeight: (self.field?.labelHeight)!, font: self.optionLabels[0].font!))!
                    
                    self.optionLabels[self.field!.data as! Int].frame = CGRect(x: self.frame.width - (width + (margin * 2) + self.field!.requiredWidth),
                                                                               y: margin,
                                                                               width: width,
                                                                               height: self.field!.labelHeight)
                    
                }
            }

            break
        }
    }
}
