//
//  StartVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/19/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.7849289775, green: 1, blue: 0.9694601893, alpha: 1)
        //Check if user already logged in; if so, take to home page
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
        
    }
    
    
}
