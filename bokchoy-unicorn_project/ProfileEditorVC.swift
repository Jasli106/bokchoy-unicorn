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
import FirebaseStorage
import MobileCoreServices

class ProfileEditorVC: UIViewController, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Objects
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var instrumentsField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    
    @IBOutlet weak var contactField: UITextField!
    
    @IBOutlet weak var doneEditingButton: UIBarButtonItem!
    
    
    
    //Variables
    var user: User!
    var userDatabaseID = Auth.auth().currentUser?.uid
    let userProfileRef = Database.database().reference().child("users")
    var profileData : Dictionary<String, Any> = [:]
    
    let storagePicRef = Storage.storage().reference().child("Profile Pics")
    var urlString : String = ""
    
    var agePickerData: [String] = [String]()
    var genderPickerData: [String] = [String]()
    
    var age: String? = "1"
    var gender: String? = "Prefer not to say"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.7849289775, green: 1, blue: 0.9694601893, alpha: 1)
        
        user = Auth.auth().currentUser
        
        //Fill in previous information
        fillTextFields()
        
        //Set up pickers
        agePickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        genderPickerData = ["Female", "Male", "Non-binary", "Other", "Prefer not to say"]
        
        self.agePicker.delegate = self
        self.agePicker.dataSource = self
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        
        self.hideKeyboardWhenTappedAround() 
        
    }
    
    //checks user profile in database and inserts textfield text accordingly
    func fillTextFields(){
        userProfileRef.child(userDatabaseID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get values
            let value = snapshot.value as? NSDictionary
            
            //assigning values to textfields and pickers
            self.nameField.text = value?["name"] as? String ?? ""
            let ageIndex = self.agePickerData.firstIndex(of: value?["age"] as? String ?? "1")
            let genderIndex = self.genderPickerData.firstIndex(of: value?["gender"] as? String ?? "Prefer not to say")
            self.agePicker.selectRow(ageIndex! , inComponent: 0, animated: true)
            self.genderPicker.selectRow(genderIndex!, inComponent: 0, animated: true)
            self.instrumentsField.text = value?["instruments"] as? String ?? ""
            self.bioField.text = value?["bio"] as? String ?? ""
            self.contactField.text = value?["contact"] as? String ?? self.user.email
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------
    
    //Setting up picker views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return agePickerData.count
        }
        else {
            return genderPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(agePickerData[row])"
        } else {
            return "\(genderPickerData[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            age = agePickerData[row]
        }
        else {
            gender = genderPickerData[row]
        }
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------
    
    //Set profile image
    @IBAction func setProfilePic() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage] as [String]
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        handleImageSelectedForImage(image: pickedImage) {
            picker.dismiss(animated: true, completion: nil)
            self.profilePicButton.setBackgroundImage(pickedImage, for: .normal)
        }
        
    }
    
    fileprivate func handleImageSelectedForImage(image: UIImage, completion: @escaping () -> ()) {
        let filename = "\(String(describing: userDatabaseID)).png"
        if let imageData = image.pngData() {
            storagePicRef.child(filename).putData(imageData, metadata: nil) { (metadata, error) in
                let imageRef = self.storagePicRef.child(filename)
                imageRef.downloadURL(completion: { url , error in
                    if let error = error {
                        print(error)
                    } else {
                        let downloadURL = url!
                        self.urlString = downloadURL.absoluteString
                    }
                })
                completion()
            }
        }
    }

//-----------------------------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func doneEditing(_ sender: Any) {
        let editedProfile = ["name": self.nameField.text!,
                             "age": age,
                             "gender": gender,
                             "instruments": self.instrumentsField.text!,
                             "bio": self.bioField.text!,
                             "contact": self.contactField.text!, 
                             "profile pic": urlString]
        
        //adding changes to database
        userProfileRef.child(userDatabaseID!).setValue(editedProfile)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
