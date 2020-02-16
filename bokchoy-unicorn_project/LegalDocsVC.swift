//
//  LegalDocsVC.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/29/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

class LegalDocsVC: UIViewController {
    /*
    let file = termsandconditions.rtf
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contentsOf: file)
        //if segueIdentifier == "SignUpToTerms" {
        
        //readFromDocumentsFile(fileName: file)
        
        
        
    }*/
    /*
    func readFromDocumentsFile(fileName:String) -> String {
        let text = String(contentsOfFile: String, error: nil)
        print(text)
        return text
        
    }
*/
    @IBAction func closeDoc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
