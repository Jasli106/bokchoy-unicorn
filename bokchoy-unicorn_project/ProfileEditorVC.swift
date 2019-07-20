//
//  ProfileEditorVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 7/20/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

class ProfileEditorVC: UIViewController, UINavigationBarDelegate {
    
    //Objects
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var agePicker: UIPickerView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var instrumentsField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    @IBOutlet weak var contactButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Setting nav bar programmatically because XCode is stupid
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style:   UIBarButtonItem.Style.plain, target: self, action: #selector(cancelEditing))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style:   UIBarButtonItem.Style.plain, target: self, action: #selector(doneEditing))
    }
    
    //Doing everything programmatically because XCode has to make things COMPLICATED
    //Going back to profile screen after cancelling
    @objc func cancelEditing() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Going back to profile screen after done
    @objc func doneEditing() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
