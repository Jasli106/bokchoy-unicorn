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
    
    //recieving newProfile from ProfileEditorVC
    public var newProfile : Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        //Store user ID in Firebase
        user = Auth.auth().currentUser
        
        
        let userProfileRef = Database.database().reference().child("users").child(userDatabaseID!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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

