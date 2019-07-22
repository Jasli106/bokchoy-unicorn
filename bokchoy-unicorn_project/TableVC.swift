//
//  TableViewController.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/1/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {
    
    //creating database reference for TableVC class
    var ref: DatabaseReference!
    
    var events = [
        ["title": "Rock Concert", "time": "9-12pm", "text": "Please come, we can't afford the venue without an audience. $5 entry."],
        ["title": "Jam Session", "time": "16:20", "text": "Meet community members and have fun!"],
        ["title": "Open mic", "time": "noon", "text": "Good musicians preffered, but all are welcome."],
        ["title": "Meeting??", "time": "whenever", "text": "I'm bored. pls hang out w/ me"]
    ]
    
    //Loading 1st time app opens
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let refEvents = Database.database().reference().child("events");
        
        //observing the data changes
        refEvents.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.events.removeAll()
                
                //iterating through all the values
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let eventObject = events.value as? [String: AnyObject]
                    
                    let eventTitle  = eventObject?["title"] as! String?
                    //let eventText  = eventObject?["text"] as! String?
                    let eventTime = eventObject?["time"] as! String?
                    
                    //creating event object with model and fetched values
                    let event = ["title": eventTitle, "time": eventTime]
                    
                    //appending it to list
                    self.events.append(event as! [String : String])
                    
                    print(self.events)
                }
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
        
    }
   

    //call self.tableView.reloadData() to reset table contents
    func reloadData() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        //future code to hopefully update table according to database
        //let eventsRef : Dictionary<String, Any> = Database.database().reference()
        
        /*
        // Listen for new comments in the Firebase database
        eventsRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.events.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.events.count-1, section: self.kSectionEvents)], with: UITableView.RowAnimation.automatic)
        })
        // Listen for deleted comments in the Firebase database
        eventsRef.observe(.childRemoved, with: { (snapshot) -> Void in
            let index = self.indexOfEvent(snapshot)
            self.events.remove(at: index)
        self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionEvents)], with: UITableView.RowAnimation.automatic)
        })
        */
        
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    // creates cells according to Prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
    
        // title cell text
        cell.textLabel?.text = self.events[indexPath.row]["title"]
        
        // detail cell text
        cell.detailTextLabel?.text = self.events[indexPath.row]["time"]
        
        return cell
    }
        
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "Segue", sender: self)
        
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let viewController = segue.destination as? EventDetailVC,
            let index = self.tableView.indexPathForSelectedRow?.row {
            
            viewController.eventData = self.events[index]
    
        }
        
    }
 

}

