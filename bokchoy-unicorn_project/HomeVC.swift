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
    //var author: String //Idk if this actually needs to be in the struct? Unless we use the author at some point. So probably.
    var details: String
    var startDate: Array<Int>
    var startTime: Array<Int>
    var endDate: Array<Int>
    var endTime: Array<Int>
    //var location: String //Might have to change type later, research how location works?
}

//Make Events equatable (can check if they are equal)
extension Event: Equatable {
    static func == (firstEvent: Event, secondEvent: Event) -> Bool {
        return
            firstEvent.title == secondEvent.title &&
                firstEvent.details == secondEvent.details &&
                firstEvent.startDate == secondEvent.startDate &&
                firstEvent.startTime == secondEvent.startTime &&
                firstEvent.endDate == secondEvent.endDate &&
                firstEvent.endTime == secondEvent.endTime
    }
}


class HomeVC: UITableViewController, UISearchResultsUpdating {
    
    //Variables
    var ref: DatabaseReference!
    var events = [Event]()
    var filteredEvents = [Event]()
    var uniqueDates = [Array<Int>]()
    var sectionedEvents = [[Event]]()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    fileprivate func addDatabaseToEvents() {
        //This function takes the information from the database and adds it to the list of events in this view controller, so that it can use it later
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Search bar setup
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Gigs"
        
        addDatabaseToEvents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    //Search and filter functions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
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
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    // Determining characteristics of table (sections, rows, etc.)
    func calculateSections() {
        uniqueDates = [Array<Int>]()
        sectionedEvents = [[Event]]()
        //Iterates through all events and checks if they occur on a new date or not. If not, add date to list of dates when events occur (uniqueDates). Also checks if event is already in sectioned events section
        for event in events {
            if uniqueDates.contains(event.startDate) {
                let index = uniqueDates.firstIndex(of: event.startDate)
                //if sectionedEvents[index!].contains(event) {
                    sectionedEvents[index!].append(event)
                //}
            }
            else {
                uniqueDates.append(event.startDate)
                sectionedEvents.append([event])
            }
        }
        print(sectionedEvents)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        calculateSections()
        return uniqueDates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEvents.count
        }
        else {
            return sectionedEvents[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(uniqueDates[section][0])/\(uniqueDates[section][1])/\(uniqueDates[section][2])"
    }
    
    // creates cells according to Prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let event: Event
        
        /*if isFiltering() {
            event = filteredEvents[indexPath.section][indexPath.row]
        } else {*/
            event = sectionedEvents[indexPath.section][indexPath.row]
        //}
        
        // title cell text: title
        cell.textLabel?.text = event.title
        
        // TODO: format time here
        
        // convert start time value to array
        let startTime = event.startTime
        
        // detail cell text: start time
        if startTime[1] < 10 {
            cell.detailTextLabel?.text = "\(startTime[0]):0\(startTime[1])"
        }
        else {
            cell.detailTextLabel?.text = "\(startTime[0]):\(startTime[1])"
        }
        
        return cell
    }
    
    //When cell is selected, show event detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "homeToDetail", sender: self)
    }
    
    // Passing data when segue happens to event detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let viewController = segue.destination as? EventDetailVC,
            let index = self.tableView.indexPathForSelectedRow {
                viewController.eventData = self.sectionedEvents[index.section][index.row]
            }
    }
 
}

