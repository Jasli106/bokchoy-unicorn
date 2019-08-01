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
    var profileData : Dictionary<String, Any> = [:]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fillTextFields()
    }
    
    //checks user profile in database and inserts textfield text accordingly
    func fillTextFields(){
        userProfileRef.child(userDatabaseID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get values
            let value = snapshot.value as? NSDictionary
            
            //assigning values to textfields
            self.nameField.text = value?["name"] as? String ?? ""
            self.instrumentsField.text = value?["instruments"] as? String ?? ""
            self.bioField.text = value?["bio"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
