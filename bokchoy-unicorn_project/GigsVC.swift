//
//  TableViewController.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/1/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class GigsVC: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var mineButton: UIBarButtonItem!
    @IBOutlet weak var bookmarkedButton: UIBarButtonItem!
    @IBOutlet weak var allButton: UIBarButtonItem!
    
    //Variables
    var ref: DatabaseReference!
    var events = [Event]()
    var authoredEvents : Array<String> = []
    var bookmarkedEvents : Array<String> = []
    
    var filteredEvents = [[Event]]()
    var uniqueDates = [Date]()
    var sectionedEvents = [[Event]]()
    var orderedUniqueDates = [Date]()
    var orderedSectionedEvents = [[Event]]()
    
    let dateFormatter = DateFormatter()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let user = Auth.auth().currentUser?.uid
    
    
    
    let refEvents = Database.database().reference().child("events")
    let refEventsByUser = Database.database().reference().child("eventsByUser")
    
    
    //scanEvents() takes input (an array) and sees if any of the array items are the keys for any "events" in database
    //events with keys from input get added to table
    func scanEvents(eventsOfInterest: Array<String>){
        
        print("SCANEVENTS BEGAN")
        //observing the data changes in events of interest
        refEvents.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.events.removeAll()
                
                //iterating through all the values
                for eachEvent in snapshot.children.allObjects as! [DataSnapshot] {
                    //if eachEvent is listed in authoredEvents
                    if eventsOfInterest.contains(eachEvent.key) {
                        
                        //getting values
                        let value = eachEvent.value as? [String: AnyObject]
                        let ID = events.key
                        
                        let startDateFormatted = self.dateFormatter.date(from: value!["start date"] as! String)
                        let endDateFormatted = self.dateFormatter.date(from: value!["end date"] as! String)
                        
                        //Converting to custom object of type Event
                        let eventObject = Event(ID: ID, title: value!["title"] as! String, details: value!["details"] as! String, startDate: startDateFormatted!, startTime: value!["start time"] as! Array<Int>, endDate: endDateFormatted!, endTime: value!["end time"] as! Array<Int>)
                        
                        let eventTitle  = eventObject.title
                        let eventDetails  = eventObject.details
                        let eventStartDate = eventObject.startDate
                        let eventStartTime = eventObject.startTime
                        let eventEndDate = eventObject.endDate
                        let eventEndTime = eventObject.endTime
                        
                        //creating event object with model and fetched values
                        let event = Event(ID: ID, title: eventTitle, details: eventDetails, startDate: eventStartDate, startTime: eventStartTime, endDate: eventEndDate, endTime: eventEndTime)
                        
                        //appending it to list
                        self.events.append(event)
                    }
                }
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        //Search bar setup
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Gigs"
        
        mineFilter()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //-----------------------------------------------------------------------
    //Search and filter functions
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredEvents = [[Event]]()
        //Filters each section, appends to filteredEvents
        for section in sectionedEvents {
            filteredEvents.append(section.filter({( event : Event) -> Bool in
                return (event.title.lowercased().contains(searchText.lowercased()))
            }))
        }
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    //--------------------------------------------------------------------------
    
    // Determining characteristics of table (sections, rows, etc.)
    func calculateSections() {
        uniqueDates = [Date]()
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
        
        //Order dates and events
        orderedUniqueDates = uniqueDates.sorted(by: <)
        for date in orderedUniqueDates {
            for eventSection in sectionedEvents {
                if eventSection[0].startDate == date {
                    orderedSectionedEvents.append(eventSection)
                }
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        calculateSections()
        return orderedUniqueDates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredEvents[section].count
        }
        else {
            return orderedSectionedEvents[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = dateFormatter.string(from: orderedUniqueDates[section])
        return date
    }
    
    // creates cells according to Prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let event: Event
        
        if isFiltering() {
            event = filteredEvents[indexPath.section][indexPath.row]
        } else {
            event = orderedSectionedEvents[indexPath.section][indexPath.row]
        }
        
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
    
    
    func mineFilter() {
        //if any changes in authoredEvents...
        refEventsByUser.child(user!).child("authored").observe(DataEventType.value, with: { (authoredSnapshot) in
            
            if authoredSnapshot.childrenCount > 0 {
                //clearing the list
                self.authoredEvents.removeAll()
                
                //iterating through and adding eventID to authoredEvents list
                for eachEvent in authoredSnapshot.children.allObjects as! [DataSnapshot] {
                    self.authoredEvents.append(eachEvent.key)
                }
                
                self.scanEvents(eventsOfInterest: self.authoredEvents)
                
            }
        })
    }
    
    func bookmarkedFilter() {
        //if any changes in bookmarkedEvents...
        refEventsByUser.child(user!).child("bookmarked").observe(DataEventType.value, with: { (bookmarkedSnapshot) in
            
            if bookmarkedSnapshot.childrenCount > 0 {
                //clearing the list
                self.bookmarkedEvents.removeAll()
                
                //iterating through and adding eventID to bookmarkedEvents list
                for eachEvent in bookmarkedSnapshot.children.allObjects as! [DataSnapshot] {
                    self.bookmarkedEvents.append(eachEvent.key)
                }
                
                self.scanEvents(eventsOfInterest: self.bookmarkedEvents)
                
            }
        })
    }

    func allFilter() {
    }
    
    @IBAction func pressedMine(_ sender: Any) {
        mineFilter()
    }
    
    @IBAction func pressedBookmarked(_ sender: Any) {
        bookmarkedFilter()
    }
    
    @IBAction func pressedAll(_ sender: Any) {
        allFilter()
    }
    
    
    
    //When cell is selected, show event detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gigsToDetail", sender: self)
    }
    
    // Passing data when segue happens to event detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let viewController = segue.destination as? EventDetailVC,
            let index = tableView.indexPathForSelectedRow {
            viewController.eventData = orderedSectionedEvents[index.section][index.row]
        }
    }
}
