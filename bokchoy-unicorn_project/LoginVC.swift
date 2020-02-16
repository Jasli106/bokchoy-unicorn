//
//  LoginVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/19/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    //Objects
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.7849289775, green: 1, blue: 0.9694601893, alpha: 1)
    }
   
    //Sign in existing user
    @IBAction func loginAction(sender: UIButton) {
        
        //Sign in with Firebase
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) {
            (user, error) in
            
            //if no error, sign in successfully
            if error == nil{
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            
            //if error, show alert
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
}
