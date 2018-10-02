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
        case "FBCheckBoxView":
            bundle = Bundle.init(for: FBCheckBoxView.self)
            break
        case "FBCheckView":
            bundle = Bundle.init(for: FBCheckView.self)
            break
        case "FBComboBoxFieldView":
            bundle = Bundle.init(for: FBComboBoxFieldView.self)
            break
        case "FBDatePickerView":
            bundle = Bundle.init(for: FBDatePickerView.self)
            break
        case "FBDateView":
            bundle = Bundle.init(for: FBDateView.self)
            break
        case "FBDropDownView":
            bundle = Bundle.init(for: FBDropDownView.self)
            break
        case "FBSectionHeaderView":
            bundle = Bundle.init(for: FBSectionHeaderView.self)
            break
        case "FBHeadingView":
            bundle = Bundle.init(for: FBHeadingView.self)
            break
        case "FBImagePickerView":
            bundle = Bundle.init(for: FBImagePickerView.self)
            break
        case "FBImageView":
            bundle = Bundle.init(for: FBImageView.self)
            break
        case "FBLabelView":
            bundle = Bundle.init(for: FBLabelView.self)
            break
        case "FBOptionSetView":
            bundle = Bundle.init(for: FBOptionSetView.self)
            break
        case "FBOptionView":
            bundle = Bundle.init(for: FBOptionView.self)
            break
        case "FBRequiredView":
            bundle = Bundle.init(for: FBRequiredView.self)
            break
        case "FBSignatureView":
            bundle = Bundle.init(for: FBSignatureView.self)
            break
        case "FBSignView":
            bundle = Bundle.init(for: FBSignView.self)
            break
        case "FBTextAreaView":
            bundle = Bundle.init(for: FBTextAreaView.self)
            break
        case "FBTextFieldView":
            bundle = Bundle.init(for: FBTextFieldView.self)
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

