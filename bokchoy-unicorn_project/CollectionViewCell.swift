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
        if profile.editingMedia {
            deleteButton.isHidden = false
        }
        else {
            deleteButton.isHidden = true
        }
    }
    
}
