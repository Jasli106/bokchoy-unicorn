//
//  EventDetailVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/3/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    //referencing all Labels in scene
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var interestedButton: UIButton!
    
    //recieving eventData from TableVC as a dictionary
    public var eventData = Event(title: "", details: "", startDate: [], startTime: [], endDate: [], endTime: [])
    
    /*
     //may be useful later to pull event details from database
    refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
    // ...
    })
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startDate = eventData.startDate
        let startTime = eventData.startTime
        
        //Customizing labels to eventData
        titleLabel.text = eventData.title
        timeLabel.text = "time: \(startTime[0]):\(startTime[1])"
        dateLabel.text = "date: \(startDate[0])/\(startDate[1])/\(startDate[2])"
        detailLabel.text = eventData.details
    }
    
    //@IBAction func interested(_ sender: Any) {
    //}
    
}
