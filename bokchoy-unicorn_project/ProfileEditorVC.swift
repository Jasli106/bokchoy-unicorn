//
//  ProfileEditorVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/20/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileEditorVC: UIViewController, UINavigationBarDelegate {
    
    //Objects
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var instrumentsField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var doneEditingButton: UIBarButtonItem!
    
    //Variables
    var userDatabaseID = Auth.auth().currentUser?.uid
    let userProfileRef = Database.database().reference().child("users")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneEditing(_ sender: Any) {
        let editedProfile = ["name": self.nameField.text,
                             "instruments": self.instrumentsField.text,
                             "bio": self.bioField.text]
        
        //adding changes to database
        userProfileRef.child(userDatabaseID!).setValue(editedProfile)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
