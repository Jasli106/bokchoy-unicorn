//
//  NewVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/30/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewVC: UIViewController {
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var detailsTextField: UITextView!
    
    // public var events : Array<Dictionary<String, Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //clicking "post" button will postEvent()
    //postEvent() makes userInput into newEvent (dict), adds newEvent to events (list), and forces Home table to reload
    @IBAction func postEvent(_ sender: Any) {
        
        /*
        //gives who the post author is (useful later)
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let user = User(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        */
        
        //coding newEvent based on user input in text fields
        
        
        
        let newEvent = [
            "title" : titleTextField.text!,
            "time" : timeTextField.text!,
            "details" : detailsTextField.text!
            ] as [String : Any]
        
        //checking if any textfields were left blank
        for textField in newEvent.values {
            //if a textfield is blank...
            if (textField as! String).isEmpty {
                
                //if a textfield is blank, show alert
                let alertController = UIAlertController(title: "Text fields are empty", message: "Please add more information", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                //stop 'postEvent' function
                return
            }
        }
        
        //referencing "events" in database
        let refEvents = Database.database().reference().child("events")
    
        //adding newEvent to database with automatically assigned unique ID
        refEvents.childByAutoId().setValue(newEvent){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                let alertController = UIAlertController(title: "Posted!", message: "Data saved successfully", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
}
