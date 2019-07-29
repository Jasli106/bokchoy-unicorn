//
//  SettingsVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/29/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // This will show in the next view controller being pushed
        let backItem = UIBarButtonItem()
        backItem.title = "Close"
        navigationItem.backBarButtonItem = backItem
    }
}
