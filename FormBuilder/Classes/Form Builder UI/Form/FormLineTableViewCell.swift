//
//  FormLineTableViewCell.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/17/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol FormLineDelegate: class
{
    func fieldValueChanged(field: FBField, value: Any?)
    func lineHeightChanged(line: FBLine)
}

class FormLineTableViewCell: UITableViewCell, FBFieldViewDelegate
{
    var line:FBLine?
    weak var delegate:FormLineDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.setupFields()
    }

    func setupFields()
    {
        for field in self.contentView.subviews
        {
            field.removeFromSuperview()
        }
        var fieldCount:CGFloat = CGFloat(self.line!.visibleFields().count)
        if (fieldCount < 1.0)
        {
            fieldCount = 1.0
        }
        
        
        let width:CGFloat = self.contentView.frame.width / fieldCount
        var left:CGFloat = 0.0
        for field in (self.line?.visibleFields())!
        {
            let border:CGFloat = field.style?.value(forKey: "border") as? CGFloat ?? 1.5
            var backgroundColor:UIColor = UIColor.init(hexString: field.style?.value(forKey: "background-color") as! String)!
            if ((field.style?.value(forKey: "alternate-colors") as? String)?.lowercased() == "true")
            {
                backgroundColor = field.line!.section!.colorFor(line: field.line!)
            }
            let borderColor:UIColor = UIColor.init(hexString: field.style?.value(forKey: "border-color") as! String)!
            var leftOffset:CGFloat = 0.0;
            var rightOffset:CGFloat = 0.0;
            if ((field == self.line?.visibleFields().first) && (field == self.line?.visibleFields().last))
            {
                leftOffset = border
                rightOffset = border
            }
            else if (field == self.line?.visibleFields().first)
            {
                leftOffset = border
                if (border > 0)
                {
                    rightOffset = border / 2
                }
            }
            else if (field == self.line?.visibleFields().last)
            {
                if (border > 0)
                {
                    leftOffset = border / 2
                }
                rightOffset = border
            }
            else
            {
                if (border > 0)
                {
                    leftOffset = border / 2
                    rightOffset = border / 2
                }
            }
            switch (field.fieldType)
            {
            case FBFieldType.Section:
                break
                
            case FBFieldType.Heading:
                // header field
                let headingView:FBHeadingView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = headingView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                headingView.frame = cellFrame
                left += width
                headingView.field = field as? FBHeadingField
                headingView.updateDisplay(label: field.caption!)
                headingView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(headingView)
                
                break
                
            case FBFieldType.Label:
                // label field
                let labelView:FBLabelView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = labelView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                labelView.frame = cellFrame
                left += width
                labelView.field = field as? FBLabelField
                labelView.updateDisplay(label: field.caption!)
                labelView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(labelView)
                
                break
                
            case FBFieldType.Image:
                // image field
                let imageView:FBImageView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = imageView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                imageView.frame = cellFrame
                left += width
                imageView.field = field as? FBImageField
                imageView.updateDisplay(label: field.caption!, image:UIImage(named:"welcome")!)
                imageView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(imageView)
                
                break
                
            case FBFieldType.ImagePicker:
                // image picker field
                // image field
                let imagePickerView:FBImagePickerView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = imagePickerView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                imagePickerView.frame = cellFrame
                left += width
                imagePickerView.field = field as? FBImagePickerField
                if (field.editing)
                {
                    if (field.hasInput)
                    {
                        imagePickerView.updateDisplay(label: field.caption!, image: field.input as? UIImage)
                    }
                    else
                    {
                        imagePickerView.updateDisplay(label: field.caption!, image: nil)
                    }
                }
                else
                {
                    imagePickerView.updateDisplay(label: field.caption!, image: field.data as? UIImage)
                }
                //imageView.updateDisplay(label: field.caption!, image:UIImage(named:"welcome")!)
                imagePickerView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                imagePickerView.delegate = self
                if (field.input != nil)
                {
                    //let margin:CGFloat = field.style!.value(forKey: "margin") as? CGFloat ?? 5.0
                    //let width:CGFloat = field.caption!.width(withConstrainedHeight: (field.labelHeight), font: field.style!.font)
                    //imagePickerView.image = (field.data as! UIImage).resize(width: Double(self.field!.width - ((margin * 3) + width)))
                    //imagePickerView.image = field.input as? UIImage
                }
                self.contentView.addSubview(imagePickerView)
                
                break
                
            case FBFieldType.Text:
                // text input field
                let textFieldView:FBTextFieldView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = textFieldView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                textFieldView.frame = cellFrame
                left += width
                textFieldView.field = field as? FBTextField
                if (field.editing)
                {
                    textFieldView.updateDisplay(label: field.caption!, text: field.input as? String ?? "", required: field.required)
                }
                else
                {
                    textFieldView.updateDisplay(label: field.caption!, text: field.data as? String ?? "", required: field.required)
                }
                textFieldView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(textFieldView)
                
                break
                
            case FBFieldType.TextArea:
                // text input area
                let textAreaView:FBTextAreaView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = textAreaView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                textAreaView.frame = cellFrame
                left += width
                textAreaView.field = field as? FBTextAreaField
                textAreaView.delegate = self
                var text:String = ""
                if (field.editing)
                {
                    text = field.input as? String ?? ""
                }
                else
                {
                    text = field.data as? String ?? ""
                }
                textAreaView.updateDisplay(label: field.caption!, text: text, required: field.required)
                textAreaView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(textAreaView)
                
                break
                
            case FBFieldType.ComboBox:
                // combo box for selecting among predefined options
                let comboboxFieldView:FBComboBoxFieldView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))! 
                field.view = comboboxFieldView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                comboboxFieldView.frame = cellFrame
                left += width
                comboboxFieldView.field = field as? FBComboBoxField
                comboboxFieldView.delegate = self
                var data:String = ""
                if (field.editing)
                {
                    if (field.input != nil)
                    {
                        var option:FBOption?
                        option = field.optionSet?.option(named: field.input as! String) ?? nil
                        if (option != nil)
                        {
                            data = option!.value
                        }
                    }
                }
                else
                {
                    if (field.data != nil)
                    {
                        var option:FBOption?
                        option = field.optionSet?.option(named: field.data as! String) ?? nil
                        if (option != nil)
                        {
                            data = option!.value //(field.optionSet?.options[index!].value)!
                        }
                    }
                }
                comboboxFieldView.updateDisplay(label: field.caption!, text: data, required: field.required)
                comboboxFieldView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(comboboxFieldView)
                
                break
                
            case FBFieldType.CheckBox:
                // check box to turn an item on or off
                let checkBoxView:FBCheckBoxView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = checkBoxView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                checkBoxView.frame = cellFrame
                left += width
                checkBoxView.field = field as? FBCheckBoxField
                checkBoxView.delegate = self
                var data:FBCheckState = FBCheckState.Unchecked
                if (field.editing)
                {
                    if (field.input != nil)
                    {
                        if (field.input is FBCheckState)
                        {
                            data = field.input as! FBCheckState
                        }
                        else if (field.input is Bool)
                        {
                            if ((field.input as! Bool) == true)
                            {
                                data = FBCheckState.Checked
                            }
                            else
                            {
                                data = FBCheckState.Unchecked
                            }
                        }
                    }
                }
                else
                {
                    if (field.data != nil)
                    {
                        if (field.data is FBCheckState)
                        {
                            data = field.data as! FBCheckState
                        }
                        else if (field.data is Bool)
                        {
                            if ((field.data as! Bool) == true)
                            {
                                data = FBCheckState.Checked
                            }
                            else
                            {
                                data = FBCheckState.Unchecked
                            }
                        }
                    }
                }
                
                checkBoxView.updateDisplay(label: field.caption!, state: data, required: field.required)
                checkBoxView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(checkBoxView)
                
                break
                
            case FBFieldType.OptionSet:
                let optionSetView:FBOptionSetView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = optionSetView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                optionSetView.frame = cellFrame
                left += width
                optionSetView.field = field as? FBOptionSetField
                optionSetView.delegate = self
                if (field.editing)
                {
                    optionSetView.updateDisplay(label: field.caption!, optionSet: field.optionSet!, id: field.input as! String?, required: field.required)
                }
                else
                {
                    optionSetView.updateDisplay(label: field.caption!, optionSet: field.optionSet!, id: field.input as! String?, required: field.required)
                }
                optionSetView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(optionSetView)
                
                break
                
            case FBFieldType.Signature:
                let signatureView:FBSignatureView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = signatureView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                signatureView.frame = cellFrame
                left += width
                signatureView.field = field as? FBSignatureField
                signatureView.delegate = self
                if (field.editing)
                {
                    signatureView.updateDisplay(label: field.caption!, signature:field.input as? UIImage, required: field.required)
                }
                else
                {
                    signatureView.updateDisplay(label: field.caption!, signature:field.data as? UIImage, required: field.required)
                }
                signatureView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(signatureView)
                
                break
                
            case FBFieldType.DatePicker:
                // date picker field
                let datePickerView:FBDatePickerView = UIView.fromNib(withName: field.style!.viewFor(type: field.fieldType))!
                field.view = datePickerView as FBFieldView
                let cellFrame:CGRect = CGRect(x: left + leftOffset,
                                              y: self.contentView.frame.origin.y,
                                              width: width - (leftOffset + rightOffset),
                                              height: self.contentView.frame.size.height - border)
                datePickerView.frame = cellFrame
                left += width
                datePickerView.field = field as? FBDatePickerField
                var text:String = ""
                if (field.editing)
                {
                    if (field.input != nil && (field.input as? String) != "")
                    {
                        text = field.input as! String //dateFormatter.string(from: field.data as! Date)
                    }
                }
                else
                {
                    if (field.data != nil && (field.data as? String) != "")
                    {
                        text = field.data as! String //dateFormatter.string(from: field.data as! Date)
                    }
                }
                datePickerView.updateDisplay(label: field.caption!, text: text, required: field.required)
                datePickerView.backgroundColor = backgroundColor
                self.contentView.backgroundColor = borderColor
                self.contentView.addSubview(datePickerView)
                
                break
            case .Unknown:
                
                break
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fieldHeightChanged()
    {
        // the height of one of our fields has changed, so notify the table to redraw this cell...
        self.delegate?.lineHeightChanged(line: self.line!)
    }



}
