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
import PDFKit

class SettingsVC: UIViewController {

    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.7849289775, green: 1, blue: 0.9694601893, alpha: 1)
    }
    
    //theoretically allows user to delete account when user presses deleteAccountButton
    @IBAction func deleteUser() {
        //Confirming deletion
        let confirmAlert = UIAlertController(title: "Are you sure you want to delete your account?",
                                      message: "Deleting your account will delete also delete all your posts.",
                                      preferredStyle: .alert)
        //Creating actions
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            CATransaction.setCompletionBlock({
                let user = Auth.auth().currentUser!
                var email = " "
                var password = " "
                
                //Asking for credentials
                let alert = UIAlertController(title: "", message: "Please confirm your email and password.", preferredStyle: .alert)
                alert.addTextField { (emailField) in
                    emailField.text = "Email"
                }
                alert.addTextField { (passwordField) in
                    passwordField.text = "Password"
                }
                let confirm = UIAlertAction(title: "Confirm", style: .default) { [weak alert] (_) in
                    email = (alert?.textFields![0].text)!
                    password = (alert?.textFields![1].text)!
                    //Reauthenticating
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    user.reauthenticate(with: credential, completion: { (result, error) in
                        if let err = error {
                            print("ERROR: ", err)
                        }
                        else {
                            print("SUCCESS")
                            //Reauthentication successful; Proceed to deletion
                            user.delete() { error in
                                if let error = error {
                                    print("ERROR IS HERE: ",error)
                                    // An error happened alert
                                    let alertController = UIAlertController(title: "Error", message: "Something went wrong. Your account couldn't be deleted.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else {
                                    //Deletion successful
                                    print("SUCCESS!")
                                    // Account deleted alert
                                    let alertController = UIAlertController(title: "Done", message: "Your account was deleted.", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alertController.addAction(defaultAction)
                                    self.present(alertController, animated: true, completion: nil)
                                    
                                    //Go back to initial screen
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let initial = storyboard.instantiateInitialViewController()
                                    UIApplication.shared.keyWindow?.rootViewController = initial
                                }
                            }
                        }
                    })
                }
                alert.addAction(confirm)
                self.present(alert, animated: true, completion: nil)
            })
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //adding delete and cancel options to alert
        confirmAlert.addAction(delete)
        confirmAlert.addAction(cancel)
        
        //showing alert
        self.present(confirmAlert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? LegalDocsVC {
            if segue.identifier == "settingsToTerms" {
                viewController.file = "termsandconditions"
            }
            else if segue.identifier == "settingsToPrivacy" {
                viewController.file = "privacypolicy"
            }
        }
        
        // This will show in the next view controller being pushed
        let backItem = UIBarButtonItem()
        backItem.title = "Close"
        navigationItem.backBarButtonItem = backItem
    }
}
