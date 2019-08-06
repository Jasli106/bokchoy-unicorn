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
import FirebaseStorage

class ProfileVC: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Objects
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    //Variables
    var user: User!
    var userDatabaseID = Auth.auth().currentUser?.uid
    var profileData : Dictionary<String, Any> = [:]
    
    //References
    let videoRef = Storage.storage().reference().child("Videos")
    let ref = Database.database().reference()

//----------------------------------------------------------------------------------------------------------------
    
    //Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        //Store user ID in Firebase
        user = Auth.auth().currentUser
    }
    
    fileprivate func updateProfile() {
        let userProfileRef = ref.child("users").child(userDatabaseID!)
        
        //observing the data changes
        userProfileRef.observe(DataEventType.value, with: { (snapshot) in
            
            //iterating through all the values
            for characteristic in snapshot.children.allObjects as! [DataSnapshot] {
                
                //getting key value pairs
                let value = characteristic.value!
                let key = characteristic.key
                
                self.profileData[key] = value
            }
            //assigning text to labels
            self.nameLabel.text = self.profileData["name"] as? String
            self.instrumentsLabel.text = self.profileData["instruments"] as? String
            self.bioLabel.text = self.profileData["bio"] as? String
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateProfile()
    }
    
//----------------------------------------------------------------------------------------------------------------
    
    //Collection View
    let videos = ["Example1", "Example2"]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! CollectionViewCell
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.text = videos[indexPath.item]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addNewCell", for: indexPath) as! CollectionViewCell
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            print(indexPath.item)
        }
    }
    
    @objc func buttonPressed()
    {
        print("Add New")
    }
    
//----------------------------------------------------------------------------------------------------------------
    
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
