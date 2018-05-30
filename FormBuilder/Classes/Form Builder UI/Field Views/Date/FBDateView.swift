//
//  DateView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/1/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol FBDateViewDelegate: class
{
    func selected(date:Date)
    func cleared()
    func dismiss()
}

open class FBDateView: UIView
{
    @IBOutlet var datePicker:UIDatePicker?
    @IBOutlet var button:UIButton?
    @IBOutlet var deleteButton:UIButton?
    var textColor:UIColor = UIColor.white
    private var _buttonColor:UIColor = UIColor.gray
    var pickerWidth:CGFloat = 0.0
    var pickerHeight:CGFloat = 0.0
    var minimum:Date? = nil
    var maximum:Date? = nil
    weak var delegate:FBDateViewDelegate?

    override open func layoutSubviews()
    {
        self.datePicker!.frame = CGRect(x: 0.0,
                                       y: 0.0,
                                       width: self.frame.width,
                                       height: self.frame.height - 60.0)
        self.deleteButton?.frame = CGRect(x: 5.0, y: (self.frame.height - 65.0), width: 50.0, height: 50.0)
        self.button?.frame = CGRect(x:(self.frame.width / 2.0) - ((self.frame.width - 10.0) / 2.0) + 55.0,
                                    y:(self.frame.height - 65.0),
                                    width:(self.frame.width - (10.0 + 50.0 + 5.0)),
                                    height:50.0)
        
    }
    
    open func updateDisplay(date:Date, buttonColor:UIColor, dateType:FBDateType)
    {
        let bundle = Bundle.init(for: self.classForCoder)
        // create "ok" button
        self.button = UIButton()
        self.button!.layer.cornerRadius = 7.5
        self.button?.addTarget(self, action: #selector(okButtonPressed), for: UIControlEvents.touchUpInside)
        _buttonColor = buttonColor
        self.button?.backgroundColor = _buttonColor
        self.button?.setTitle("Ok", for: UIControlState.normal)
        self.button?.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.addSubview(self.button!)
        // create delete button
        self.deleteButton = UIButton()
        self.deleteButton!.layer.cornerRadius = 7.5
        self.deleteButton?.addTarget(self, action: #selector(deleteButtonPressed), for: UIControlEvents.touchUpInside)
        _buttonColor = buttonColor
        self.deleteButton?.backgroundColor = _buttonColor
        self.deleteButton?.setImage(UIImage.init(named: "trash-white", in: bundle, compatibleWith: nil), for: UIControlState.normal)
        self.deleteButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.addSubview(self.deleteButton!)
        // create date picker
        self.datePicker = UIDatePicker()
        self.datePicker?.setValue(self.textColor, forKey: "textColor")
        self.datePicker?.setValue(false, forKey: "highlightsToday")
        self.datePicker?.setDate(date, animated: false)
        switch (dateType)
        {
        case FBDateType.Date:
            self.datePicker?.datePickerMode = UIDatePickerMode.date
            break
        case FBDateType.Time:
            self.datePicker?.datePickerMode = UIDatePickerMode.time
            break
        case FBDateType.DateTime:
            self.datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
            break
        }
        self.datePicker?.addTarget(self, action: #selector(dateChanged), for: UIControlEvents.valueChanged)
        self.addSubview(self.datePicker!)
        
        if (minimum != nil)
        {
            self.datePicker?.minimumDate = minimum
        }
        if (maximum != nil)
        {
            self.datePicker?.maximumDate = maximum 
        }
    }
    
    @objc @IBAction func okButtonPressed()
    {
        if (self.delegate != nil)
        {
            self.delegate!.selected(date: self.datePicker!.date)
            self.delegate?.dismiss()
        }
    }

    @objc @IBAction func deleteButtonPressed()
    {
        if (self.delegate != nil)
        {
            self.delegate!.cleared()
            self.delegate?.dismiss()
        }
    }

    @objc @IBAction func dateChanged()
    {
        if (self.delegate != nil)
        {
            self.delegate!.selected(date: self.datePicker!.date)
        }
    }
}
