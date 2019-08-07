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
    
    //referencing all Labels in scene
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    
    @IBOutlet weak var interestedButton: UIButton!
    
    let user = Auth.auth().currentUser?.uid
    
    //Declaring eventData as an Event; data recieved from HomeVC through segue
    public var eventData = Event(ID: "", title: "", author: "", interested: 25, details: "", startDate: Date(timeIntervalSince1970: 0), startTime: [], endDate: Date(timeIntervalSince1970: 0), endTime: [])
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let startDate = dateFormatter.string(from: eventData.startDate)
        let startTime = eventData.startTime
        
        //Customizing labels to eventData
        titleLabel.text = eventData.title
        timeLabel.text = "time: \(startTime[0]):\(startTime[1])"
        dateLabel.text = "date: " + startDate
        detailLabel.text = eventData.details
        interestedLabel.text = String(eventData.interested) + " people have expressed interest"
    }
    @IBAction func backToHomeTable(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func interested(_ sender: Any) {
        let refEventsByUser = Database.database().reference().child("eventsByUser").child(user!)
        let refEvents = Database.database().reference().child("events")
        var interestCounter : Int = 0
        
        var alreadyBookmarked = false
        
        //checking if this event is already bookmarked
        refEventsByUser.child("bookmarked").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {//if user does have bookmarked events
                //iterating through events to see if this event already exists
                for bookmarkedEvent in snapshot.children.allObjects as! [DataSnapshot] {
                    //if event already exists
                    if bookmarkedEvent.value as! String == self.eventData.ID {
                        alreadyBookmarked = true
                        break
                    }
                }
            }
            if alreadyBookmarked == false {
                //adding event to bookmarked list
                refEventsByUser.child("bookmarked").child(self.eventData.ID).setValue(self.eventData.ID)
                
                refEvents.child(self.eventData.ID).child("interested").observeSingleEvent(of: DataEventType.value, with: { (interestedSnapshot) in
                    
                    interestCounter = interestedSnapshot.value as! Int
                    interestCounter = interestCounter + 1
                    refEvents.child(self.eventData.ID).child("interested").setValue(interestCounter)
                    
                    self.interestedLabel.text = String(interestCounter) + " people have expressed interest"
                })
                
            }
            let alertController = UIAlertController(title: "Saved!", message: "This event was added to your bookmarks", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        })
     
    }
    
}
