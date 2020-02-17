//
//  NewVC.swift
//  bokchoy-unicorn_project
//
//  Created by Jasmine Li on 6/30/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices


class NewVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    //Declaring eventData as an Event; data recieved from eventDetailVC through segue
    public var eventData = Event(ID: "", title: "", author: "", interested: 25, location: "", details: "", startDate: Date(timeIntervalSince1970: 0), startTime: [], endDate: Date(timeIntervalSince1970: 0), endTime: [], imageURL: "")
    
    var eventInDatabase = false
    var userDatabaseID = Auth.auth().currentUser?.uid
    var urlString : String = ""
    
    let storageImgRef = Storage.storage().reference().child("Event Pics")
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.5575887561, green: 0.9717493653, blue: 0.9496586919, alpha: 1)
        // Do any additional setup after loading the view
        if eventData.ID != ""{
            titleTextField.text = eventData.title
            detailsTextView.text = eventData.details
            locationTextField.text = eventData.location
            
            //Set time pickers to correct dates and times
            let startTimeInterval: TimeInterval = TimeInterval(eventData.startTime[0] * 60 * 60 + eventData.startTime[1] * 60)
            let startDate = eventData.startDate.addingTimeInterval(startTimeInterval)
            let endTimeInterval: TimeInterval = TimeInterval(eventData.endTime[0] * 60 * 60 + eventData.endTime[1] * 60)
            let endDate = eventData.startDate.addingTimeInterval(endTimeInterval)
            
            startTimePicker.date = startDate
            endTimePicker.date = endDate
            
            //Setting add image button image
            let imageURL = NSURL(string: self.eventData.imageURL)! as URL
            print(imageURL)
            let imageData = try? Data(contentsOf: imageURL)
            if let data = imageData {
                let image = UIImage(data: data) as UIImage?
                imageButton.setBackgroundImage(image, for: .normal)
            }

        }
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------

    var addImgButton: UIButton!
    
    //Set event image
    @IBAction func setEventImage(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage] as [String]
        imagePicker.sourceType = .photoLibrary
        
        addImgButton = sender
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        handleImageSelectedForImage(image: pickedImage) {
            picker.dismiss(animated: true, completion: nil)
            self.addImgButton.setBackgroundImage(pickedImage, for: .normal)
        }
        
    }
    
    fileprivate func handleImageSelectedForImage(image: UIImage, completion: @escaping () -> ()) {
        let filename = "\(ident).png"
        print(ident)
        if let imageData = image.pngData() {
            storageImgRef.child(filename).putData(imageData, metadata: nil) { (metadata, error) in
                let imageRef = self.storageImgRef.child(filename)
                imageRef.downloadURL(completion: { url , error in
                    if let error = error {
                        print(error)
                    } else {
                        let downloadURL = url!
                        self.urlString = downloadURL.absoluteString
                    }
                })
                completion()
            }
        }
    }
    
//-----------------------------------------------------------------------------------------------------------------------------------------------

let user = Auth.auth().currentUser?.uid

var ident = Database.database().reference().childByAutoId().key!
    
    //clicking "post" button will postEvent()
    //postEvent() makes userInput into newEvent (dict), adds newEvent to events in database
    @IBAction func postEvent(_ sender: Any) {
        
        //coding newEvent based on user input in text fields
        
        //Getting date and time components as ints
        let startDate = startTimePicker.date.getDateTime()
        let endDate = endTimePicker.date.getDateTime()
        
        if eventData.ID != ""{
            self.ident = eventData.ID
        }
        
        let newEvent = [
            "ID" : ident,
            "title" : titleTextField.text!,
            "start date" : "\(startDate.month)/\(startDate.day)/\(startDate.year)",
            "start time" : [startDate.hour, startDate.minute],
            "end date" : "\(endDate.month)/\(endDate.day)/\(endDate.year)",
            "end time" : [endDate.hour, endDate.minute],
            "details" : detailsTextView.text!,
            "location" : locationTextField.text!,
            "imageURL" : urlString,
            
            "author" : user!,
            "interested" : 0
            ] as [String : Any]
        
        var necessaryTextFields = newEvent
        //removing traits that are not necessary for posting
        necessaryTextFields.removeValue(forKey: "ID")
        necessaryTextFields.removeValue(forKey: "author")
        necessaryTextFields.removeValue(forKey: "interested")
        necessaryTextFields.removeValue(forKey: "start date")
        necessaryTextFields.removeValue(forKey: "start time")
        necessaryTextFields.removeValue(forKey: "end date")
        necessaryTextFields.removeValue(forKey: "end time")
        necessaryTextFields.removeValue(forKey: "details")
        
        //checking if any textfields were left blank
        for textField in necessaryTextFields.values {
            
            //if a textfield is blank...
            if (textField as! String).isEmpty {
                
                //alert user
                let alertController = UIAlertController(title: "Text fields are empty", message: "Please add more information", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
                //stop 'postEvent' function
                return
            }
        }
        
        //referencing "events" in database
        let refEvents = Database.database().reference().child("events")
        let refEventsByUser = Database.database().reference().child("eventsByUser").child(user!)
        
        if eventData.ID != ""{
            eventInDatabase = true
            refEvents.child(self.eventData.ID).setValue(newEvent){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                }
            }
        }
        
       
        if self.eventInDatabase == false {
            //adding newEvent to database with automatically assigned unique ID
            refEvents.child(ident).setValue(newEvent){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    refEventsByUser.child("authored").child(self.ident).setValue(self.ident)
                }
            }
        }
        
        //if no error, alerts user that post was successful
        let alert = UIAlertController(title: "Posted!",
                                      message: "Data saved successfully",
                                      preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "newToHome", sender: nil)
            })
        })
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
        
    }

}
