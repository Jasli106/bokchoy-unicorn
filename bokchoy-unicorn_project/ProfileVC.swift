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



class ProfileVC: UIViewController, UINavigationControllerDelegate{
    
    //Objects
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    //Variables
    var user: User!
    var userDatabaseID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var profileData : Dictionary<String, Any> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Store user ID in Firebase
        user = Auth.auth().currentUser
        
        
        updateProfile()
        
        print("working?", profileData)
        
        nameLabel.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("VIEWDIDAPPEAR WAS CALLED")
        
        nameLabel.text = self.profileData["name"] as? String
        instrumentsLabel.text = self.profileData["instruments"] as? String
        bioLabel.text = self.profileData["bio"] as? String
        
        print("this is profile data 1: ",profileData)
    }
    
    //checks database for any profile changes and changes local "profileData" dict accordingly
    func updateProfile(){
        
        print("UPDATE PROFILE WAS CALLED")
        let userProfileRef = Database.database().reference().child("users").child(userDatabaseID!)
        
        //observing the data changes
        userProfileRef.observe(DataEventType.value, with: { (snapshot) in
            
            //iterating through all the values
            for characteristic in snapshot.children.allObjects as! [DataSnapshot] {
                
                //getting key value pairs
                let value = characteristic.value!
                let key = characteristic.key
                
                self.profileData[key] = value
            }
        })
        print(self.profileData)
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


