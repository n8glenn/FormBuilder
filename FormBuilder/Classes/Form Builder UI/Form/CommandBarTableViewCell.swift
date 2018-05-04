//
//  CommandBarTableViewCell.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/19/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

protocol CommandBarDelegate: class
{
    func saveSelected()
    func cancelSelected()
    func isEditing() -> Bool
    func setForm(mode:FBFormMode)
}

class CommandBarTableViewCell: UITableViewCell
{
    @IBOutlet var cancelButton:UIButton?
    @IBOutlet var doneButton:UIButton?
    weak var delegate:CommandBarDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func doneButtonPressed()
    {
        if (delegate != nil)
        {
            if (delegate!.isEditing())
            {
                delegate?.saveSelected()
            }
            else
            {
                delegate!.setForm(mode:FBFormMode.Edit)
            }
        }
    }
    
    @IBAction func cancelButtonPressed()
    {
        if (delegate != nil)
        {
            delegate?.cancelSelected()
        }
    }
}
