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
    
    @IBOutlet weak var interestedButton: UIButton!
    
    //recieving eventData from TableVC as a dictionary
    public var eventData : Dictionary<String, Any> = [:]
    
    /*
     //may be useful later to pull event details from database
    refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
    let postDict = snapshot.value as? [String : AnyObject] ?? [:]
    // ...
    })
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customizing labels to eventData
        titleLabel.text = eventData["title"] as? String
        timeLabel.text = "time: \(eventData["time"] as! String)"
        detailLabel.text = eventData["details"] as? String
    }
    
    //@IBAction func interested(_ sender: Any) {
    //}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
