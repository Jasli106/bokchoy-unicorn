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
    
   // public var events : Array<Dictionary<String, Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //clicking "post" button will postEvent()
    //postEvent() makes userInput into newEvent (dict), adds newEvent to events (list), and forces Home table to reload
    
    var TableVC:TableViewController?
    @IBAction func postEvent(_ sender: Any) {
        
        //let eventTitleUserInput = "exampletitlelol"
        //UserDefaults.standard.set(eventTitleUserInput, forKey: "title")
        
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
        
        
        let newEvent = [
            //"title" : eventTitleUserInput,
            "title" : "new title!!",
            "time" : "the best time",
            "text" : "cats allowed"
        ]
        
        
        let eventRef = Database.database().reference()
        
        let eventIDNumber = "101"
        
        let eventID = "events/event"+eventIDNumber
        eventRef.child(eventID).setValue(newEvent){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
        
        
    }
    
}
