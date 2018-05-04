//
//  UIView+fromNib.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/22/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    class func fromNib<T>(withName nibName: String) -> T?
    {
        var bundle = Bundle.main
        
        switch nibName
        {
        case "CheckBoxView":
            bundle = Bundle.init(for: CheckBoxView.self)
            break
        case "CheckView":
            bundle = Bundle.init(for: CheckView.self)
            break
        case "ComboBoxFieldView":
            bundle = Bundle.init(for: ComboBoxFieldView.self)
            break
        case "DatePickerView":
            bundle = Bundle.init(for: DatePickerView.self)
            break
        case "DateView":
            bundle = Bundle.init(for: DateView.self)
            break
        case "DropDownView":
            bundle = Bundle.init(for: DropDownView.self)
            break
        case "SectionHeaderView":
            bundle = Bundle.init(for: SectionHeaderView.self)
            break
        case "HeadingView":
            bundle = Bundle.init(for: HeadingView.self)
            break
        case "ImagePickerView":
            bundle = Bundle.init(for: ImagePickerView.self)
            break
        case "ImageView":
            bundle = Bundle.init(for: ImageView.self)
            break
        case "LabelView":
            bundle = Bundle.init(for: LabelView.self)
            break
        case "OptionSetView":
            bundle = Bundle.init(for: OptionSetView.self)
            break
        case "OptionView":
            bundle = Bundle.init(for: OptionView.self)
            break
        case "RequiredView":
            bundle = Bundle.init(for: RequiredView.self)
            break
        case "SignatureView":
            bundle = Bundle.init(for: SignatureView.self)
            break
        case "SignView":
            bundle = Bundle.init(for: SignView.self)
            break
        case "TextAreaView":
            bundle = Bundle.init(for: TextAreaView.self)
            break
        case "TextFieldView":
            bundle = Bundle.init(for: TextFieldView.self)
            break

        default:
            
            break
        }
        let nib  = UINib.init(nibName: nibName, bundle: bundle)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        for object in nibObjects
        {
            if let result = object as? T
            {
                return result
            }
        }
        return nil
    }
}

