//
//  NewVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/30/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

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
        
        
        struct Variables {
            static var newEvent = [
                //"title" : eventTitleUserInput,
                "title" : "new title!!",
                "time" : "the best time",
                "text" : "cats allowed"
            ]
        }
        
        
    }
    
}
