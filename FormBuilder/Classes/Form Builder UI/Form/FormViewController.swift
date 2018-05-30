//
//  FormViewController.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/16/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

open class FormViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    FormLineDelegate,
    FormDelegate,
    FBSectionHeaderDelegate
{
    // --------------------------------------------------------->
    // -- ATTENTION: If you want to use the form builder, you must
    // --            make a new table view controller and set this
    // --            class as the parent class, then implement the
    // --            methods listed below in your class.
    // --------------------------------------------------------->
    // -- Form delegate methods -------------------------------->
    // -- populate() -------------------------------------------> load an object we want to display into the form (called automatically after form is loaded).
    // -- fieldValueChanged(field: FBField, value: Any) --------> handle user input into the form (you may need to update form based on user input -- or not).
    // -- validationFailed(exceptions:Array<FBException>) ------> (!!! optional !!!) handle errors in data input or missing data (maybe show a popup describing errors).
    // -- save() -----------------------------------------------> save the input data back into our object.
    // -- discard() --------------------------------------------> dismiss this form without saving any data (our object should not be altered in any way).
    // -- That's all, folks! ----------------------------------->

    @IBOutlet var tableView:UITableView?
    public var form:FBForm? = nil // the form represents the data we went to display, divided up into sections, lines, and fields.
    var modified:Bool = false // has this form been modified?  If so we may need to save it, if not, then why bother?
    var displayCommandBar:Bool = true // should we display the "edit", "save", "cancel" buttons at the bottom?
    
    open override func viewDidLoad()
    {
        super.viewDidLoad()

        let bundle = Bundle.init(for: FormLineTableViewCell.self)
        self.tableView?.register(UINib(nibName: "FBFormCell", bundle: bundle), forCellReuseIdentifier: "FormCell")
    }

    open override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView!.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView!.backgroundColor = UIColor.init(hexString: form?.style?.value(forKey: "border-color") as! String)
    }
    
    open override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return form?.visibleSections().count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return form!.visibleSections()[section].lineCount()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // we will calculate the height for each field based on the style and data contained in it, and set the height of the containing row accordingly.
        if (self.form?.visibleSections()[indexPath.section].collapsed == true)
        {
            return 0.0
        }
        else
        {
            return (self.form?.visibleSections()[indexPath.section].visibleLines()[indexPath.row].height())!
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // create a line of data in the form...
        let cell:FormLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FormCell", for: indexPath) as! FormLineTableViewCell
        // Configure the cell...
        cell.line = form?.visibleSections()[indexPath.section].visibleLines()[indexPath.row]
        cell.backgroundColor = UIColor.init(hexString: form?.style?.value(forKey: "border-color") as! String)
        cell.setupFields()
        cell.delegate = self
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view:FBSectionHeaderView = UIView.fromNib(withName: self.form!.sections[section].style!.viewFor(type: FBFieldType.Section))!
        view.updateDisplay(index: section, section: self.form!.sections[section])
        view.delegate = self
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let view:FBSectionHeaderView = UIView.fromNib(withName: self.form!.sections[section].style!.viewFor(type: FBFieldType.Section))!
        view.updateDisplay(index: section, section: self.form!.sections[section])
        return view.height() + (self.form?.visibleSections()[section].style?.value(forKey: "border") as! CGFloat) + ((self.form?.visibleSections()[section].style?.value(forKey: "margin") as! CGFloat) * 2)
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let line:FBLine = (form?.visibleSections()[indexPath.section].visibleLines()[indexPath.row])!
        return line.allowsRemove
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let line:FBLine = (form?.visibleSections()[indexPath.section].visibleLines()[indexPath.row])!
            self.removeItem(indexPath: indexPath, type: line.visibleFields().first!.fieldType)
        }
    }
    
    public func loadSpecification(named:String)
    {
        // load the sections, lines, fields, requirements, layout, etc for this form from a data file.
        self.form = FBForm(file: named, delegate:self)
        formLoaded()
        self.form?.tableView = self.tableView
        self.form?.mode = FBFormMode.View
    }

    public func formLoaded()
    {
        // when the form is loaded, we should allow the user to add any data they want to display...  I guess...
        self.populate()
        self.modified = false // we just loaded the form so it hasn't been modified yet
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        self.updateDisplay()
    }
    
    public func updateDisplay()
    {
        // shortcut to update the display after the form has changed.
        self.tableView!.reloadData()
    }
    
    // form line delegate methods
    open func updated(field: FBField, withValue: Any?)
    {
        self.modified = true
        self.fieldValueChanged(field: field, value: withValue)
    }
    
    open func fieldValueChanged(field: FBField, value: Any?)
    {
        // this should be overridden in child forms.
        // IF you want to provide custonm behavior based on data input.
    }

    func editing() -> Bool
    {
        return self.form?.mode == FBFormMode.Edit
    }
    
    func setForm(mode: FBFormMode)
    {
        self.form?.mode = mode
        self.updateDisplay()
    }
    
    func editSelected(section:Int)
    {
        self.form?.visibleSections()[section].mode = FBFormMode.Edit
        self.tableView?.reloadSections([section], with: UITableViewRowAnimation.fade)
    }
    
    func saveSelected(section:Int)
    {
        // user wants to save the form
        let exceptions:Array<FBException> = self.form!.validate()
        
        if (exceptions.count > 0)
        {
            self.validationFailed(exceptions: exceptions)
        }
        else
        {
            if (self.modified)
            {
                self.update()
                self.save()
            }
            self.form?.visibleSections()[section].mode = FBFormMode.View
            self.tableView?.reloadSections([section], with: UITableViewRowAnimation.fade)
        }
    }
    
    func cancelSelected(section:Int)
    {
        // user wants to cancel and discard changes
        for field in self.form!.fields()
        {
            field.clear()
        }
        self.form?.visibleSections()[section].mode = FBFormMode.View
        self.discard()
        self.populate()
        self.tableView?.reloadSections([section], with: UITableViewRowAnimation.fade)
    }
    
    open func populate()
    {
        // this should be overridden by the child form.
        assert(false, "This method must be overriden by the subclass")
    }

    open func validationFailed(exceptions:Array<FBException>)
    {
        // this can be overridden in the child form, if you want to change the way the validation errors are displayed.
        // validation failed, so we should handle the errors here however the developer wants.
        var message:String = ""
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
        let alert:UIAlertController = UIAlertController(title: "Validation Failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(alertAction)
        if let presenter = alert.popoverPresentationController
        {
            presenter.sourceView = self.view!
        }
        present(alert, animated: true, completion: nil)
    }
    
    func update()
    {
        for field in self.form!.fields()
        {
            field.data = field.input
        }
    }
    
    open func save()
    {
        // this should be overridden in the child form.
        assert(false, "This method must be overriden by the subclass")
    }
    
    open func discard()
    {
        // cancel changes and dismiss form, this should leave the object displayed in the form as is
    }

    func collapse(section: Int)
    {
        // collapse a collapsible section
        self.form!.sections[section].collapsed = true
        var indexSet:IndexSet = IndexSet()
        indexSet.insert(section)
        self.tableView!.reloadSections(indexSet, with: UITableViewRowAnimation.fade)
    }
    
    func expand(section: Int)
    {
        // expand a collapsed section
        self.form!.sections[section].collapsed = false
        var indexSet:IndexSet = IndexSet()
        indexSet.insert(section)
        self.tableView!.reloadSections(indexSet, with: UITableViewRowAnimation.fade)
    }

    func addItem(section: Int, type: FBFieldType)
    {
        // add a new section, or item to a section.
        switch (type)
        {
        case FBFieldType.Section:
            let s:FBSection = FBSection(form: self.form!, lines: self.form!.sections[section].range)
            s.allowsRemove = true
            self.form!.sections.insert(s, at: section + 1)
            self.tableView!.reloadData()
            
            break
        case FBFieldType.Image:
            let alert:UIAlertController = UIAlertController(title: "Image Label Text", message: "Enter text for the label of this image.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Image Label Text"
            })
            let action = UIAlertAction(title: "Ok",
                                       style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
                                        if let textFields = alert.textFields{
                                            let theTextFields = textFields as [UITextField]
                                            let enteredText = theTextFields[0].text
                                            let currentSection:FBSection = self!.form!.sections[section]
                                            let count:Int = currentSection.lines!.count
                                            let line:FBLine = FBLine().initWith(section: currentSection, id: "Line." + String(count + 1))
                                            line.allowsRemove = true
                                            let field:FBImagePickerField = FBImagePickerField().initWith(line: line,
                                                                                                     id: "Field." + String(count + 1),
                                                                                                     label:enteredText ?? "",
                                                                                                     type: FBFieldType.ImagePicker) as! FBImagePickerField
                                            line.fields.insert(field, at: 0)
                                            currentSection.lines?.insert(line, at: count)
                                            self?.tableView!.beginUpdates()
                                            self?.tableView!.insertRows(at: [IndexPath(row: currentSection.visibleLines().count - 1, section:section)], with: UITableViewRowAnimation.none)
                                            self?.tableView!.endUpdates()
                                            
                                        }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            if let presenter = alert.popoverPresentationController
            {
                presenter.sourceView = self.view!
            }
            present(alert, animated: true, completion: nil)
            
            break
        case FBFieldType.Label:
            let alert:UIAlertController = UIAlertController(title: "Label Text", message: "Enter text for the label.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Label Text"
            })
            let action = UIAlertAction(title: "Ok",
                                       style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
                                        if let textFields = alert.textFields{
                                            let theTextFields = textFields as [UITextField]
                                            let enteredText = theTextFields[0].text
                                            
                                            let currentSection:FBSection = self!.form!.sections[section]
                                            let count:Int = currentSection.lines!.count
                                            let line:FBLine = FBLine().initWith(section: currentSection, id: "Line." + String(count + 1))
                                            line.allowsRemove = true
                                            let field:FBLabelField = FBLabelField().initWith(line: line,
                                                                                         id: "Field." + String(count + 1),
                                                                                         label:enteredText ?? "",
                                                                                         type: FBFieldType.Label) as! FBLabelField
                                            
                                            line.fields.insert(field, at: 0)
                                            currentSection.lines?.insert(line, at: count)
                                            self?.tableView!.beginUpdates()
                                            self?.tableView!.insertRows(at: [IndexPath(row: currentSection.visibleLines().count - 1, section:section)], with: UITableViewRowAnimation.none)
                                            self?.tableView!.endUpdates()
                                        }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            if let presenter = alert.popoverPresentationController
            {
                presenter.sourceView = self.view!
            }
            present(alert, animated: true, completion: nil)
            
            break
        case FBFieldType.Signature:
            let alert:UIAlertController = UIAlertController(title: "Signature Label Text", message: "Enter text for the label of this signature.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(
                configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Signature Label Text"
            })
            let action = UIAlertAction(title: "Ok",
                                       style: UIAlertActionStyle.default,
                                       handler: {[weak self]
                                        (paramAction:UIAlertAction!) in
                                        if let textFields = alert.textFields{
                                            let theTextFields = textFields as [UITextField]
                                            let enteredText = theTextFields[0].text
                                            
                                            let currentSection:FBSection = self!.form!.sections[section]
                                            let count:Int = currentSection.lines!.count
                                            let line:FBLine = FBLine().initWith(section: currentSection, id: "Line." + String(count + 1))
                                            line.allowsRemove = true
                                            let field:FBSignatureField = FBSignatureField().initWith(line: line,
                                                                                                 id: "Field." + String(count + 1),
                                                                                                 label:enteredText ?? "",
                                                                                                 type: FBFieldType.Signature) as! FBSignatureField
                                            line.fields.insert(field, at: 0)
                                            currentSection.lines?.insert(line, at: count)
                                            self?.tableView!.beginUpdates()
                                            self?.tableView!.insertRows(at: [IndexPath(row: currentSection.visibleLines().count - 1, section:section)], with: UITableViewRowAnimation.none)
                                            self?.tableView!.endUpdates()
                                        }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            if let presenter = alert.popoverPresentationController
            {
                presenter.sourceView = self.view!
            }
            present(alert, animated: true, completion: nil)
            
            break
        default:
            
            break
        }
    }

    func removeItem(indexPath: IndexPath, type: FBFieldType)
    {
        // remove a section or an item from a section
        switch (type)
        {
        case FBFieldType.Section:
            let alert:UIAlertController = UIAlertController(title: "Remove", message: "Remove this section?", preferredStyle: UIAlertControllerStyle.alert)
            let okAction:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (UIAlertAction) in
                self.form!.sections.remove(at: indexPath.section)
                self.tableView!.reloadData()
            }
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) in

            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            if let presenter = alert.popoverPresentationController
            {
                presenter.sourceView = self.view!
            }
            self.present(alert, animated: true, completion: nil)

            break
        case FBFieldType.ImagePicker:
            self.form!.sections[indexPath.section].removeLine(row: indexPath.row)
            self.tableView?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            break
        case FBFieldType.Label:
            self.form!.sections[indexPath.section].removeLine(row: indexPath.row)
            self.tableView?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            break
        case FBFieldType.Signature:
            self.form!.sections[indexPath.section].removeLine(row: indexPath.row)
            self.tableView?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
            break
        default:
            
            break
        }
    }
    
    func lineHeightChanged(line: FBLine)
    {
        var i:Int = 0
        var j:Int = 0
        for section in self.form!.visibleSections()
        {
            for l in section.visibleLines()
            {
                if ((section.id == line.section?.id) && (l.id == line.id))
                {
                    self.tableView!.reloadRows(at: [IndexPath.init(row: j, section: i)], with: UITableViewRowAnimation.none)
                    return
                }
                j += 1
            }
            i += 1
        }
    }
}
