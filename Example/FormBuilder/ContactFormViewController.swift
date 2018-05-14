//
//  ContactFormViewController.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit
import FormBuilder

class ContactFormViewController: FormViewController
{

    let address:Address = Address() // this is the object to be represented on this form.
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // You must call "self.loadForm(named:"MyForm")" in order to load the form into this view.
        // Once the form is loaded, it will call "populate" in this form, so you should use
        // the populate method to load the properties of the objects you want to represent on this form
        // into the form fields.
        address.street = "123 some street"
        address.city = "cityville"
        address.county = "jones county"
        address.province = "british columbia"
        address.state = "MS"
        address.zipcode = "11111"
        address.postalcode = "11111"
        address.business = false
        address.country = 1
        address.deliveryType = 1
        self.loadSpecification(named: "Contact")
    }

    // -- Form delegate methods --------------------------->
    // -- populate() --------------------------------------> load an object we want to display into the form (called automatically after form is loaded).
    // -- fieldValueChanged(field: FBField, value: Any?) --> handle user input into the form (you may need to update form based on user input -- or not).
    // -- validationFailed(exceptions:Array<FBException>) -> (!!! optional !!!) handle errors in data input or missing data (maybe show a popup describing errors).
    // -- save() ------------------------------------------> save the input data back into our object.
    // -- discard() ---------------------------------------> dismiss this form without saving any data (our object should not be altered in any way).
    // -- That's all, folks! ------------------------------>
    
    // load an object we want to display into the form (called automatically after form is loaded)
    override func populate()
    {
        // load form data now that the form has been built.
        // initialize a test object
        
        // load the test object into the form
        self.form?.field(withPath: "address.street")?.data = address.street
        self.form?.field(withPath: "address.province")?.data = address.province
        self.form?.field(withPath: "address.city")?.data = address.city
        self.form?.field(withPath: "address.postalcode")?.data = address.postalcode
        self.form?.field(withPath: "address.zipcode")?.data = address.zipcode
        self.form?.field(withPath: "address.county")?.data = address.county
        self.form?.field(withPath: "address.state")?.data = address.state
        if (address.business == true)
        {
            self.form?.field(withPath: "address.businessaddress")?.data = true
        }
        else
        {
            self.form?.field(withPath: "address.businessaddress")?.data = nil
        }
        self.form?.field(withPath: "address.country")?.data = address.country
        self.form?.field(withPath: "address.delivery")?.data = address.deliveryType
    }

    // handle user input into the form (you may need to update form based on user input -- or not)
    override func fieldValueChanged(field: FBField, value: Any?)
    {
        // whenever the user interacts with the form in any way, by changing field values, selecting items
        // in combo boxes, selecting option items, adding images, etc. this will be called.  This will
        // give you an opportunity to update the form fields based on the input data or options selected by
        // the user.  For instance if a user selects a country in a combo box on an address form, you will
        // need to update the form fields to represent the properties of the address for that country, and
        // you can also do things like change which fields are required, etc.
        
        switch (field.id.lowercased())
        {
        case "country": // the user changed the country for this address, oops, we better update the address fields!
            let section:FBSection = field.line!.section!
            switch (value as! Int)
            {
            case 0:
                // canada
                section.line(named: "county")?.visible = false
                section.line(named: "province")?.visible = true
                section.line(named: "state")?.visible = false
                section.line(named: "zipcode")?.visible = false
                section.line(named: "postalcode")?.visible = false

                // set required
                section.field(withPath: "street")?.required = true // fyi: we don't need to provide the field name if there is only one field on a line.
                section.field(withPath: "province.province")?.required = true // but we can if we want to.
                section.field(withPath: "city")?.required = true
                section.field(withPath: "postalcode")?.required = true

                break
            case 1:
                // spain
                section.line(named: "county")?.visible = false
                section.line(named: "province")?.visible = false
                section.line(named: "state")?.visible = false
                section.line(named: "zipcode")?.visible = false
                section.line(named: "postalcode")?.visible = true

                // set required
                section.field(withPath: "street")?.required = true
                section.field(withPath: "city")?.required = true
                section.field(withPath: "postalcode")?.required = true

                break
            case 2:
                // other
                section.line(named: "county")?.visible = false
                section.line(named: "province")?.visible = true
                section.line(named: "state")?.visible = false
                section.line(named: "zipcode")?.visible = false
                section.line(named: "postalcode")?.visible = true

                // set required
                section.field(withPath: "street")?.required = false
                section.field(withPath: "province")?.required = false
                section.field(withPath: "city")?.required = false
                section.field(withPath: "postalcode")?.required = false

                break
            case 3:
                // united states
                section.line(named: "county")?.visible = true
                section.line(named: "province")?.visible = false
                section.line(named: "state")?.visible = true
                section.line(named: "zipcode")?.visible = true
                section.line(named: "postalcode")?.visible = false

                // set required
                section.field(withPath: "street")?.required = true
                section.field(withPath: "city")?.required = true
                section.field(withPath: "state")?.required = true
                section.field(withPath: "zipcode")?.required = true

                break
            default:
                break
            }
            self.updateDisplay() // once the form is updated, it needs to be reloaded into the table.

            break
            
        default:
            
            break
        }
    }
    
    /*
    // handle errors in data input or missing data (maybe show a popup describing errors)
    override func validationFailed(exceptions:Array<FBException>)
    {
        // validation failed, so we should handle the errors here however the developer wants.
        var message:String = "Validation Failed...\n"
        for exception:FBException in exceptions
        {
            for type in exception.errors
            {
                switch (type)
                {
                case FBRequirementType.Required:
                    message = message + (exception.field?.caption)! + " is required.\n"
                    break
                case FBRequirementType.Maximum:
                    message = message + (exception.field?.caption)! + " exceeds the maximum.\n"
                    break
                case FBRequirementType.Minimum:
                    message = message + (exception.field?.caption)! + " does not meet the minimum.\n"
                    break
                case FBRequirementType.Format:
                    message = message + (exception.field?.caption)! + " is not valid.\n"
                    break
                case FBRequirementType.MemberOf:
                    message = message + (exception.field?.caption)! + " is not one of the available options.\n"
                    break
                default:
                    break
                }
            }
        }
        let hud:SwiftHUD = SwiftHUD.show(message, view: self.view, style: SwiftHUDStyle.error)
        hud.hide(message, after: 3)
    }
    */
    
    // save the input data back into our object.
    override func save()
    {
        // validation succeeded, so we should take the data from the form and shove it back into the objects represented on the form and save them.
        /*
        let hud:SwiftHUD = SwiftHUD.show("Validation Successful", view: self.view, style: SwiftHUDStyle.success)
        hud.hide("Validation Successful", after: 3000)
        */
        
        // save the form data back into the test object
        address.street = self.form?.field(withPath: "address.street")?.data as? String
        address.province = self.form?.field(withPath: "address.province")?.data as? String
        address.city = self.form?.field(withPath: "address.city")?.data as? String
        address.postalcode = self.form?.field(withPath: "address.postalcode")?.data as? String
        address.zipcode = self.form?.field(withPath: "address.zipcode")?.data as? String
        address.county = self.form?.field(withPath: "address.county")?.data as? String
        address.state = self.form?.field(withPath: "address.state")?.data as? String
        if ((self.form?.field(withPath: "address.businessaddress")?.data as! Bool) == true)
        {
            address.business =  true
        }
        else
        {
            address.business = false 
        }
        address.country = self.form?.field(withPath: "address.country")?.data as? Int
        address.deliveryType = self.form?.field(withPath: "address.delivery")?.data as! Int?
    }
    
    // dismiss this form without saving any data (our object should not be altered in any way)
    override func discard()
    {
        // cancel changes and dismiss form, this should leave the object displayed in the form as is
    }

    // -- End of the form delegate methods ------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
