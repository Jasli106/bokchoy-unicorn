//
//  CollectionViewCell.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 8/6/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    let profile = ProfileVC()
    
    func handleButtons() {
        if editing.editingMedia {
            deleteButton.isHidden = false
        }
        else if editing.editingMedia == false {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func getSender (_ sender: UIButton) {
        //print("SENDER: ")
        editing.sender = sender
        //Need to post notification after alert is confirmed
        NotificationCenter.default.addObserver(self, selector: #selector(self.onDidConfirmDelete(_:)), name: Notification.Name.didConfirmDelete, object: nil)
        
    }
    @objc func onDidConfirmDelete (_ notification:Notification) {
        print("POSTING NOTIFICATION")
        NotificationCenter.default.post(name: .didReceiveData, object: nil, userInfo: ["sender": editing.sender])
    }
    
}
