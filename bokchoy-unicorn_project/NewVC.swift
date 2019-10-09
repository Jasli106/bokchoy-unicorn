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
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    //Declaring eventData as an Event; data recieved from eventDetailVC through segue
    public var eventData = Event(ID: "", title: "", author: "", interested: 25, location: "", details: "", startDate: Date(timeIntervalSince1970: 0), startTime: [], endDate: Date(timeIntervalSince1970: 0), endTime: [])
    
    var eventInDatabase = false
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        if eventData.ID != ""{
            titleTextField.text = eventData.title
        }
    }
    
    
    //Convert times to time zone of poster + store in database as that time

    //clicking "post" button will postEvent()
    //postEvent() makes userInput into newEvent (dict), adds newEvent to events in database
    @IBAction func postEvent(_ sender: Any) {
        
        //coding newEvent based on user input in text fields
        
        let user = Auth.auth().currentUser?.uid
        let randomID = Database.database().reference().childByAutoId().key!
        
        //Getting date and time components as ints
        let startDate = startTimePicker.date.getDateTime()
        let endDate = endTimePicker.date.getDateTime()
        
        var ident = randomID
        if eventData.ID != ""{
            ident = eventData.ID
        }
        
        let newEvent = [
            "ID" : ident,
            "title" : titleTextField.text!,
            "start date" : "\(startDate.month)/\(startDate.day)/\(startDate.year)",
            "start time" : [startDate.hour, startDate.minute],
            "end date" : "\(endDate.month)/\(endDate.day)/\(endDate.year)",
            "end time" : [endDate.hour, endDate.minute],
            "details" : detailsTextView.text!,
            "location" : locationTextField.text!,
            
            "author" : user!,
            "interested" : 0
            ] as [String : Any]
        
        var necessaryTextFields = newEvent
        //removing traits that are not necessary for posting
        necessaryTextFields.removeValue(forKey: "ID")
        necessaryTextFields.removeValue(forKey: "author")
        necessaryTextFields.removeValue(forKey: "interested")
        necessaryTextFields.removeValue(forKey: "start date")
        necessaryTextFields.removeValue(forKey: "start time")
        necessaryTextFields.removeValue(forKey: "end date")
        necessaryTextFields.removeValue(forKey: "end time")
        necessaryTextFields.removeValue(forKey: "details")
        
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
        let refEventsByUser = Database.database().reference().child("eventsByUser").child(user!)
        
        if eventData.ID != ""{
            eventInDatabase = true
            refEvents.child(self.eventData.ID).setValue(newEvent){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                }
            }
        }
        
       
        if self.eventInDatabase == false {
            //adding newEvent to database with automatically assigned unique ID
            refEvents.child(randomID).setValue(newEvent){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    refEventsByUser.child("authored").child(randomID).setValue(randomID)
                }
            }
        }
        
        //if no error, alerts user that post was successful
        let alert = UIAlertController(title: "Posted!",
                                      message: "Data saved successfully",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "newToHome", sender: nil)
            })
        })
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
        
    }

}
