//
//  ProfileOtherVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 11/8/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices
import AVKit
import AVFoundation

class ProfileOtherVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var instrumentsLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicView: UIImageView!
    
    public var profileData : Dictionary<String, String> = ["bio" : "Bio", "instruments" : "Instruments", "name" : "Name", "profile pic" : "", "age" : "1", "gender" : "Prefer not to say", "contact" : "", "user" : "User"]
    
    //References
    let storageRef = Storage.storage().reference()
    let videoRef = Storage.storage().reference().child("Videos")
    let imageRef = Storage.storage().reference().child("Images")
    let databaseRef = Database.database().reference()
    
    public var user : String = "User"
    
//----------------------------------------------------------------------------------------------------------------
    
    //Setup
    override func viewDidLoad() {
        self.view.backgroundColor = #colorLiteral(red: 0.7849289775, green: 1, blue: 0.9694601893, alpha: 1)
        user = profileData["user"]!
        print("LOADING VIEW")
        super.viewDidLoad()
        //Store user ID in Firebase
        self.profilePicView.frame = CGRect(x: 14, y: 109, width: 130, height: 130)
        profilePicView.clipsToBounds = true
        updateProfile()
        updateMedia(completion: {
            self.collectionView.reloadData()
            self.removeSpinner()
        })
        //Loading spinner
        self.showSpinner(onView: self.view)
    }
    
    fileprivate func updateProfile() {
        let userProfileRef = databaseRef.child("users").child(user)
        
        //observing the data changes
        userProfileRef.observe(DataEventType.value, with: { (snapshot) in
            
            //iterating through all the values
            for characteristic in snapshot.children.allObjects as! [DataSnapshot] {
                
                //getting key value pairs
                let value = characteristic.value!
                let key = characteristic.key
                
                self.profileData[key] = value as? String
            }
            //assigning text to labels
            self.nameLabel.text = "Name: " + self.profileData["name"]!
            self.instrumentsLabel.text = "Instruments: " + self.profileData["instruments"]!
            self.bioLabel.text = self.profileData["bio"] ?? " "
            self.ageLabel.text = "Age: " + self.profileData["age"]!
            self.genderLabel.text = "Gender: " + self.profileData["gender"]!
            if self.profileData["contact"] == "" {
                self.profileData["contact"] = self.profileData["contact"]
            }
            self.contactLabel.text = "Contact: " + self.profileData["contact"]!
            
            //Setting profile image
            let imageURL = NSURL(string: self.profileData["profile pic"]!)! as URL
            let imageData = try? Data(contentsOf: imageURL)
            if let data = imageData {
                self.profilePicView.image = UIImage(data: data)
            }
            else {
                self.profilePicView.image = nil
            }
            
        })
    }
    
    
    fileprivate func updateMedia(completion: @escaping () -> ()) {
        print("UPDATING MEDIA")
        getVideosFromDatabase(completion: {
            self.getImagesFromDatabase(completion: {
                self.getMediaFromDatabase(completion: {
                    completion()
                })
            })
        })
    }
    
//----------------------------------------------------------------------------------------------------------------
    
    //Getting info from database
    fileprivate func getVideosFromDatabase(completion: @escaping () -> ()) {
        //Get videos
        let refVideos = Database.database().reference().child("users").child(user).child("videos")
        refVideos.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.videos.removeAll()
                for snapshotVideo in snapshot.children.allObjects as! [DataSnapshot] {
                    let videoAsURL = NSURL(string: snapshotVideo.value as! String)! as URL
                    self.videos.append(videoAsURL)
                }
                //print(self.videos)
                
            }
            completion()
        }
    }
    
    fileprivate func getImagesFromDatabase(completion: @escaping () -> ()) {
        //Get images
        let refImages = Database.database().reference().child("users").child(user).child("images")
        refImages.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.images.removeAll()
                for snapshotImage in snapshot.children.allObjects as! [DataSnapshot] {
                    //let data = try? Data(contentsOf: NSURL(string: snapshotImage.value as! String)! as URL)
                    //let imageAsUIImage = UIImage(data: data!)
                    let imageURL = NSURL(string: snapshotImage.value as! String)! as URL
                    self.images.append(imageURL)
                }
                //print(self.images)
            }
            completion()
        }
    }
    
    fileprivate func getMediaFromDatabase(completion: @escaping () -> ()) {
        //Get whole media list
        let refMedia = Database.database().reference().child("users").child(user).child("media")
        refMedia.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.media.removeAll()
                for snapshotMedia in snapshot.children.allObjects as! [DataSnapshot] {
                    let URL = NSURL(string: snapshotMedia.value as! String)! as URL
                    self.media.append(URL)
                }
                //print(self.media)
            }
            completion()
        }
    }
    
//----------------------------------------------------------------------------------------------------------------
    
    //Collection View
    var videos: [URL] = []
    var images: [URL] = []
    var media: [URL] = []
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    //Creating cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CREATING CELLS")
        //Cells displaying media
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! CollectionViewCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        //If item is a video
        if videos.contains(media[indexPath.item]) {
            //imageView.image = TODO: Get video thumbnail
            let thumbnailImage = thumbnailImageForURL(url: media[indexPath.item])
            cell.imageView.image = thumbnailImage
        }
            
            //If item is an image
        else if images.contains(media[indexPath.item]) {
            let imageData = try? Data(contentsOf: media[indexPath.item])
            let imageAsImage = UIImage(data: imageData!)
            cell.imageView.image = imageAsImage
        }
        return cell
    
        
    }
    
//----------------------------------------------------------------------------------------------------------------
    
    //Picking/interacting with media
    
    //When cell tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            //If item is a video
            if videos.contains(media[indexPath.item]) {
                let video = AVPlayer(url: videos[indexPath.item])
                let videoPlayer = AVPlayerViewController()
                videoPlayer.player = video
                present(videoPlayer, animated: true) {
                    video.play()
                }
            }
                //If item is an image
            else if images.contains(media[indexPath.item]) {
                
                performZoom(imageView: cell.imageView)
            }
        }
    }
    
    func thumbnailImageForURL(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnail = try assetGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnail)
        } catch let error {
            print(error)
            return nil
        }
    }
    
//----------------------------------------------------------------------------------------------------------------
    
    var startingFrame: CGRect?
    var blackBackground: UIView?
    
    //Handling image zoom
    func performZoom(imageView: UIImageView) {
        //Setting up views
        startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = imageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            //Setting up subviews
            blackBackground = UIView(frame: keyWindow.frame)
            blackBackground!.backgroundColor = UIColor.black
            keyWindow.addSubview(blackBackground!)
            blackBackground!.alpha = 0
            keyWindow.addSubview(zoomingImageView)
            
            //Math: h1/w1 = h2/w2
            //Solve for h2
            //h2 = (h1*w2)/w1
            let height = startingFrame!.height / startingFrame!.width * keyWindow.frame.width//(startingFrame!.height * keyWindow.frame.width)/startingFrame!.width
            
            //Performing animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackground!.alpha = 1
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //Animating zoom out
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackground!.alpha = 0
            }) { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.blackBackground?.removeFromSuperview()
            }
        }
    }
    

}
