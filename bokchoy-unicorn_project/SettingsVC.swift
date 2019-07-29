//
//  SettingsVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/29/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsVC: UIViewController {

    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //theoretically allows user to delete account when user presses deleteAccountButton
    @IBAction func deleteUser() {
        //alert asks if sure
        let alert = UIAlertController(title: "Are you sure you want to delete your account?",
                                      message: "Deleting your account will delete also delete all your posts.",
                                      preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                let user = Auth.auth().currentUser!
                
                //delete user in database
                
                //DOESN'T WORK... USER RECIEVES ERROR EVERY TIME B/C USER NEEDS TO REAUTHENTICATE ACCOUNT
                user.delete() { error in
                    if let error = error {
                        
                        /*
                        //REAUTHENTICATION
                        //Alert asking for password
                        let alert = UIAlertController(title: "Verification required", message: "Please enter password to confirm account deletion.", preferredStyle: .alert)
                        //adding text field to alert
                        alert.addTextField { (textField) in
                            textField.text = "password"
                        }
                        //Grab the value from the text field, to be submitted as password when user clicks "ok"
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let userProvidedPassword = alert?.textFields![0]
                         
                         //TODO
                         //now how to check if userProvidedPassword is authentic??
                        */
                            
                        
                        
                        
                        
                        
                        print("ERROR IS HERE: ",error)
                        // An error happened alert
                        let alertController = UIAlertController(title: "Error", message: "Something went wrong. Your account couldn't be deleted.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        // Account deleted alert
                        let alertController = UIAlertController(title: "Done", message: "Your account was deleted.", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        //Go back to first screen
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initial = storyboard.instantiateInitialViewController()
                        UIApplication.shared.keyWindow?.rootViewController = initial
                    }
 
                }
                
            })
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //adding delete and cancel options to alert
        alert.addAction(delete)
        alert.addAction(cancel)
        
        //showing alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // This will show in the next view controller being pushed
        let backItem = UIBarButtonItem()
        backItem.title = "Close"
        navigationItem.backBarButtonItem = backItem
    }
}
