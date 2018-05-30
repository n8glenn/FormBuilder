//
//  MyCombo.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit
import FormBuilder

class MyCombo: FBComboBoxFieldView
{
    override func height() -> CGFloat
    {
        // height is where we decide how high this field should be
        return 50.0
    }
    
    override func updateDisplay(label:String, text:String, required:Bool)
    {
        // updateDisplay is where we add subviews to our field view programmatically and set up the behaviors for buttons, etc.
    }
    
    override func layoutSubviews()
    {
        // layoutSubviews is where we position all of the subviews of the form in relation to each other.
    }
}
