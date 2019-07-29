//
//  TableViewController.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/1/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase


//Struct for events
struct Event {
    var title: String
    //var author: String
    var details: String
    var startDate: Array<Int>
    var startTime: Array<Int>
    var endDate: Array<Int>
    var endTime: Array<Int>
}


class HomeVC: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    //Variables
    var ref: DatabaseReference!
    var events = [Event]()//[[String : AnyObject]]()
    var filteredEvents = [Event]()//[Dictionary<String, AnyObject>]()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Search bar setup
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Gigs"
        
        //Database reference
        let refEvents = Database.database().reference().child("events")
        
        //observing the data changes
        refEvents.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.events.removeAll()
                
                //iterating through all the values
                for events in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let value = events.value as? [String: AnyObject]
                    
                    //Converting to custom object of type Event
                    let eventObject = Event(title: value!["title"] as! String, details: value!["details"] as! String, startDate: value!["start date"] as! Array<Int>, startTime: value!["start time"] as! Array<Int>, endDate: value!["end date"] as! Array<Int>, endTime: value!["end time"] as! Array<Int>)
                    
                    let eventTitle  = eventObject.title
                    let eventDetails  = eventObject.details
                    let eventStartDate = eventObject.startDate
                    let eventStartTime = eventObject.startTime
                    let eventEndDate = eventObject.endDate
                    let eventEndTime = eventObject.endTime
                    
                    //creating event object with model and fetched values
                    let event = Event(title: eventTitle, details: eventDetails, startDate: eventStartDate, startTime: eventStartTime, endDate: eventEndDate, endTime: eventEndTime)
                    
                    //appending it to list
                    self.events.append(event)
                }
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    
    //Search functions
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEvents = (events.filter({( event : Event) -> Bool in
            return (event.title.lowercased().contains(searchText.lowercased()))
        }))
        
        tableView.reloadData()
    }
    
    //Updating table based on search functions
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEvents.count
        }
        else {
            return self.events.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    // creates cells according to Prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let event: Event//Dictionary<String, AnyObject>
        
        if isFiltering() {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        // title cell text: title
        cell.textLabel?.text = event.title
        
        // format time here
        
        // convert start time value to array
        let startTime = self.events[indexPath.row].startTime
        
        // detail cell text: start time
        if startTime[1] < 10 {
            cell.detailTextLabel?.text = "\(startTime[0]):0\(startTime[1])"
        }
        else {
            cell.detailTextLabel?.text = "\(startTime[0]):\(startTime[1])"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "homeToDetail", sender: self)
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

