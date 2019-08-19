//
//  EventDetailVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/3/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EventDetailVC: UIViewController {
    
    //UI Declarations
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var interestedButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let user = Auth.auth().currentUser?.uid
    
    //Declaring eventData as an Event; data recieved from HomeVC through segue
    public var eventData = Event(ID: "", title: "", author: "", interested: 25, details: "", startDate: Date(timeIntervalSince1970: 0), startTime: [], endDate: Date(timeIntervalSince1970: 0), endTime: [])
    
    //References
    let refEvents = Database.database().reference().child("events")
    
    //setting default
    var alreadyBookmarked = false
    
    let dateFormatter = DateFormatter()

//-----------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if eventData.author == user {
            deleteButton.isHidden = false
        }
        else {
            deleteButton.isHidden = true
        }
        
        //Formatting date stuff
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let startDate = dateFormatter.string(from: eventData.startDate)
        let startTime = eventData.startTime
        
        //Customizing labels to eventData
        titleLabel.text = eventData.title
        timeLabel.text = "time: \(startTime[0]):\(startTime[1])"
        dateLabel.text = "date: " + startDate
        detailLabel.text = eventData.details
        interestedLabel.text = String(eventData.interested) + " people have expressed interest"
        
        //checking if this event is already bookmarked
        let refEventsByUser = Database.database().reference().child("eventsByUser").child(user!)
        refEventsByUser.child("bookmarked").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {//if user does have bookmarked events
                //iterating through events to see if this event already exists
                for bookmarkedEvent in snapshot.children.allObjects as! [DataSnapshot] {
                    //if event already exists
                    if bookmarkedEvent.value as! String == self.eventData.ID {
                        self.alreadyBookmarked = true
                        self.interestedButton.setTitle("I'm no longer interested.", for: .normal)
                        break
                    }
                }
            }
        })
        
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------
    
    //Delete event
    @IBAction func deleteEvent() {
        let eventID = eventData.ID
        let deleteConfirmAlert = UIAlertController(title: "Are you sure you want to delete this event?", message: "This action cannot be undone.", preferredStyle: .alert)
        deleteConfirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        deleteConfirmAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            self.refEvents.child(eventID).removeValue()
            let refEventsByUser = Database.database().reference().child("eventsByUser").child(self.user!)
            refEventsByUser.child("authored").child(eventID).removeValue()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(deleteConfirmAlert, animated: true, completion: nil)
    }
    
    //Dismiss details
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Bookmarking events
    @IBAction func interested(_ sender: Any) {
        let refEventsByUser = Database.database().reference().child("eventsByUser").child(user!)
        var interestCounter : Int = 0
        
        if alreadyBookmarked == true {
            
            refEventsByUser.child("bookmarked").child(self.eventData.ID).removeValue()
            
            
            refEvents.child(self.eventData.ID).child("interested").observeSingleEvent(of: DataEventType.value, with: { (interestedSnapshot) in
                
                interestCounter = interestedSnapshot.value as! Int
                interestCounter = interestCounter - 1
                self.refEvents.child(self.eventData.ID).child("interested").setValue(interestCounter)
                
                //resetting values on eventDetails
                self.interestedButton.setTitle("I'm interested!", for: .normal)
                self.interestedLabel.text = String(interestCounter) + " people have expressed interest"
                self.alreadyBookmarked = false
            })
            
            let alertController = UIAlertController(title: "Removed", message: "This event was deleted from your bookmarks", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            //adding event to bookmarked list
            refEventsByUser.child("bookmarked").child(self.eventData.ID).setValue(self.eventData.ID)
            
            refEvents.child(self.eventData.ID).child("interested").observeSingleEvent(of: DataEventType.value, with: { (interestedSnapshot) in
                
                interestCounter = interestedSnapshot.value as! Int
                interestCounter = interestCounter + 1
                self.refEvents.child(self.eventData.ID).child("interested").setValue(interestCounter)
                
                //resetting values on eventDetails
                self.interestedButton.setTitle("I'm no longer interested.", for: .normal)
                self.interestedLabel.text = String(interestCounter) + " people have expressed interest"
                self.alreadyBookmarked = true
            })
            let alertController = UIAlertController(title: "Saved!", message: "This event was added to your bookmarks", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
     
    }
    
}
