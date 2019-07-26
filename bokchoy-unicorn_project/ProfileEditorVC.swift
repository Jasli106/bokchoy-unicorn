//
//  ProfileEditorVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/20/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import Firebase

//Protocol
protocol KeepProfileInfoDelegate: AnyObject {
    func transferInfo(data: String)
}

class ProfileEditorVC: UIViewController, UINavigationBarDelegate {
    
    //Objects
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var instrumentsField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var contactButton: UIButton!
    
    @IBOutlet weak var doneEditingButton: UIBarButtonItem!
    
    //Variables
    var delegate: KeepProfileInfoDelegate?
    
    let ref = Database.database().reference()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = ProfileVC()
        
    }

    @IBAction func doneEditing(){
        let nameLabelText: String = nameField.text ?? "nameField didn't work, here's default"
        
        delegate?.transferInfo(data: nameLabelText)
        self.navigationController?.popToRootViewController(animated: true)
    }

    /*
    @IBAction func doneEditing(){
        print("SEGUE WAS TRIGGERED")
        self.performSegue(withIdentifier: "Segue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let viewController = segue.destination as? ProfileVC{
            
            viewController.textValue = nameField.text ?? ""
            print("hey, look, the segue happened! (at least, somewhat)")
            }
        }
    /*
    /*
    //Going back to profile screen after done
    @objc func doneEditing() {
        var textValue: String
        textValue = nameField.text ?? ""
        self.navigationController?.popViewController(animated: true)
        delegate?.transferInfo(data: textValue)
    }
    */
 }*/*/
}
