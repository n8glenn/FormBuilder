//
//  SignView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 2/10/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol SignViewDelegate: class
{
    func signatureUpdated(image:UIImage)
    func cleared()
    func dismiss()
}

class SignView: UIView
{
    @IBOutlet var signatureView:SwiftSignatureView?
    @IBOutlet var button:UIButton?
    @IBOutlet var deleteButton:UIButton?
    var textColor:UIColor = UIColor.white
    private var _buttonColor:UIColor = UIColor.gray

    weak var delegate:SignViewDelegate?
    
    func updateDisplay()
    {
        let bundle = Bundle.init(for: self.classForCoder)
        // create "ok" button
        self.backgroundColor = UIColor.white
        self.button = UIButton()
        self.button!.layer.cornerRadius = 7.5
        self.button?.addTarget(self, action: #selector(okButtonPressed), for: UIControlEvents.touchUpInside)
        //_buttonColor = buttonColor
        self.button?.backgroundColor = _buttonColor
        self.button?.setTitle("Ok", for: UIControlState.normal)
        self.button?.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.addSubview(self.button!)
        // create delete button
        self.deleteButton = UIButton()
        self.deleteButton!.layer.cornerRadius = 7.5
        self.deleteButton?.addTarget(self, action: #selector(deleteButtonPressed), for: UIControlEvents.touchUpInside)
        //_buttonColor = buttonColor
        self.deleteButton?.backgroundColor = _buttonColor
        self.deleteButton?.setImage(UIImage.init(named: "trash-white", in: bundle, compatibleWith: nil), for: UIControlState.normal)
        self.deleteButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.addSubview(self.deleteButton!)
        // create signature view
        self.signatureView = SwiftSignatureView(frame: CGRect(x:0, y:0, width: self.frame.width, height: self.frame.height - 70.0))
        self.addSubview(self.signatureView!)
        self.signatureView!.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews()
    {
        self.signatureView?.frame = CGRect(x: 0.0,
                                        y: 0.0,
                                        width: self.frame.width,
                                        height: self.frame.height - 70.0)
        self.deleteButton?.frame = CGRect(x: 5.0, y: (self.frame.height - 65.0), width: 50.0, height: 50.0)
        self.button?.frame = CGRect(x:(self.frame.width / 2.0) - ((self.frame.width - 10.0) / 2.0) + 55.0,
                                    y:(self.frame.height - 65.0),
                                    width:(self.frame.width - (10.0 + 50.0 + 5.0)),
                                    height:50.0)
    }
    
    @objc @IBAction func okButtonPressed()
    {
        self.delegate?.signatureUpdated(image:self.signatureView!.signature!)
        self.delegate?.dismiss()
    }
    
    @objc @IBAction func deleteButtonPressed()
    {
        self.signatureView?.signature = UIImage()
        self.signatureView?.setNeedsDisplay()
        self.delegate?.cleared()
    }
}
