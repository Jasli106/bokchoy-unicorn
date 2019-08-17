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

class ProfileEditorVC: UIViewController, UINavigationBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    let storagePicRef = Storage.storage().reference().child("Profile Pics")
    var urlString : String = ""
    
    

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
    
    @IBAction func doneEditing(_ sender: Any) {
        let editedProfile = ["name": self.nameField.text!,
                             "instruments": self.instrumentsField.text!,
                             "bio": self.bioField.text!,
                             "profile pic": urlString]
        
        //adding changes to database
        userProfileRef.child(userDatabaseID!).setValue(editedProfile)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
