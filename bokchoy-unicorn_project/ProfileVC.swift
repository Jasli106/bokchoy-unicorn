//
//  ProfileVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/27/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileVC: UIViewController {
    
    //Objects
    
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Store user ID in Firebase
        let ref = Database.database().reference()
        user = Auth.auth().currentUser
        
        ref.child("users").child(self.user.uid).setValue("TempValue")
    }

    //Logout button
    @IBAction func logOutAction(sender: UIButton) {
        //Sign out on Firebase
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //Go back to first screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }


}

