//
//  ProfileVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/27/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userRef = Database.database().reference()
        
        userRef.child("users/username").setValue("user123")
    }


}

