//
//  FieldView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/29/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol FBFieldViewDelegate: class
{
    func fieldHeightChanged()
}

open class FBFieldView: UIView
{
    weak var delegate:FBFieldViewDelegate?
    
    func height() -> CGFloat
    {
        // this should be overridden in child views.
        return 0.0
    }
}
