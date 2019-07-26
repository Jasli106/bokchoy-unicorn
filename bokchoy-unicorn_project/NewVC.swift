//
//  NewVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/30/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewVC: UIViewController {
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextView!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    // public var events : Array<Dictionary<String, Any>> = []
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    
    
    //Convert times to time zone of poster + store in database as that time
    
    @IBAction func timerTest() {
        print("\(startTimePicker.date.getDateTime().hour) : \(startTimePicker.date.getDateTime().minute)")
    }

    //clicking "post" button will postEvent()
    //postEvent() makes userInput into newEvent (dict), adds newEvent to events in database
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
        
        let user = Auth.auth().currentUser?.uid
        
        //Getting date and time components as ints
        let startDate = startTimePicker.date.getDateTime()
        let endDate = startTimePicker.date.getDateTime()
        
        let newEvent = [
            "title" : titleTextField.text!,
            "start date" : [startDate.month, startDate.day, startDate.year],
            "start time" : [startDate.hour, startDate.minute],
            "end date" : [endDate.month, endDate.day, endDate.year],
            "end time" : [endDate.hour, endDate.minute],
            "details" : detailsTextField.text!,
            
            "author" : user!
            ] as [String : Any]
        
        
        
        var necessaryTextFields = newEvent
        //removing traits that are not necessary for posting
        necessaryTextFields.removeValue(forKey: "author")
        necessaryTextFields.removeValue(forKey: "start date")
        necessaryTextFields.removeValue(forKey: "start time")
        necessaryTextFields.removeValue(forKey: "end date")
        necessaryTextFields.removeValue(forKey: "end time")
        
        //checking if any textfields were left blank
        for textField in necessaryTextFields.values {
            
            //if a textfield is blank...
            if (textField as! String).isEmpty {
                
                //alert user
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
                //if no error, alerts user that post was successful
                let alertController = UIAlertController(title: "Posted!", message: "Data saved successfully", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
