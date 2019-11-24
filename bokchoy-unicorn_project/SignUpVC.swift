//
//  SignUpVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/19/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpVC: UIViewController {
    
    //Objects
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Sign up new user
    @IBAction func signupAction(sender:UIButton) {
        
        //Check if passwords match
        if password.text != passwordConfirm.text {
            //If not, show alert
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            //Create user with email and password
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) {
                (user, error) in
                
                //If no error in provided info -> home
                if error == nil {
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                
                //If error, show alert
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This will show in the next view controller being pushed
        let backItem = UIBarButtonItem()
        backItem.title = "Close"
        navigationItem.backBarButtonItem = backItem
    }
    
}
