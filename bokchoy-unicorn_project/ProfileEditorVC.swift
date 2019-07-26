//
//  ProfileEditorVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/20/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase

//Protocol
protocol KeepProfileInfoDelegate: AnyObject {
    func transferInfo(data: String)
}

class ProfileEditorVC: UIViewController, UINavigationBarDelegate {
    
    //Objects
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var instrumentsField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //Variables
    var delegate: KeepProfileInfoDelegate?
    
    let ref = Database.database().reference()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = ProfileVC()
        
        /*
        //Setting nav bar programmatically because XCode is stupid
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style:   UIBarButtonItem.Style.plain, target: self, action: #selector(cancelEditing))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style:   UIBarButtonItem.Style.plain, target: self, action: #selector(doneEditing))
 */
    }
    
    @IBAction func cancelEditing(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
 
    
    @IBAction func doneEditing(_ sender: Any) {
        var textValue: String
        textValue = nameField.text ?? ""
        self.navigationController?.popViewController(animated: true)
        delegate?.transferInfo(data: textValue)
    }
    
    /*
    //Doing everything programmatically because XCode has to make things COMPLICATED
    //Going back to profile screen after cancelling
    @objc func cancelEditing() {
        self.navigationController?.popViewController(animated: true)
    }
    */
    /*
    //Going back to profile screen after done
    @objc func doneEditing() {
        var textValue: String
        textValue = nameField.text ?? ""
        self.navigationController?.popViewController(animated: true)
        delegate?.transferInfo(data: textValue)
    }
    */
}
