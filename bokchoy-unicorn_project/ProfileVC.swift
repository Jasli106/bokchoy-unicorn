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



class ProfileVC: UIViewController, UINavigationControllerDelegate, KeepProfileInfoDelegate {
    
    //Objects
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //Variables
    var user: User!
    var userDatabaseID = Auth.auth().currentUser?.uid
    var nameLabelText: String! //Supposed to be variable to store data in but it doesn't work
    let ref = Database.database().reference()
    var databaseHandle: DatabaseHandle?
    
    
    //Delegate functions
    func transferInfo(data: String) {
        //let delegateRef = Database.database().reference()
        //delegateRef.child("users").child(self.user.uid).setValue(data)
        print("type of data: ",type(of: data))
        self.nameLabelText = data as String
        print("1: ",nameLabelText!)
        self.ref.child("users").child(userDatabaseID!).setValue(["name": self.nameLabelText])
        print("2: ",nameLabelText!)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        //Store user ID in Firebase
        user = Auth.auth().currentUser
        
        //New code under here
        /*
        let refUsers = Database.database().reference().child("users").child(userDatabaseID!)
        
        //observing the data changes
        refUsers.observe(DataEventType.value, with: { (snapshot) in
        
            //getting values
            let userObject = refUsers.value as? [String: AnyObject]
        
            let userName  = userObject?["name"]
            let userAge  = userObject?["age"]
            let userGender = userObject?["gender"]
            let userInstruments = userObject?["instruments"]
            let userBio = userObject?["bio"]
           
        })
 */
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("3: ",self.nameLabelText ?? "...")
        /*databaseHandle = ref.child("users").child(self.user.uid).observe(.value) { (snapshot) in
            let username = snapshot.value as! String ?? ""
            self.nameLabel.text = username
        }*/
        nameLabel.text = self.nameLabelText
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

