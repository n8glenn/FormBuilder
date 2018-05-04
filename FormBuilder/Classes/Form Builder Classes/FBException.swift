//
//  FBException.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/19/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public class FBException: NSObject
{
    var field:FBField?
    var errors:Array<FBRequirementType> = Array<FBRequirementType>() 
}
