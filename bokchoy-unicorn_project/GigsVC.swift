//
//  TableViewController.swift
//  bokchoy-unicorn_project
//
//  Created by Verdande on 7/1/19.
//  Copyright © 2019 Jasmine Li. All rights reserved.
//

import UIKit
import FirebaseDatabase


class GigsVC: UITableViewController, UISearchResultsUpdating {
    //TODO: Store old posts in database but remove from gigs table
    //TODO: Sort posts by time as well (within each section)
    //TODO: Format dates sort of...(ew)
    
    //Variables
    var ref: DatabaseReference!
    var events = [Event]()
    var filteredEvents = [[Event]]()
    var uniqueDates = [Date]()
    var sectionedEvents = [[Event]]()
    var orderedUniqueDates = [Date]()
    var orderedSectionedEvents = [[Event]]()
    
    let dateFormatter = DateFormatter()
    
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
                    
                    let startDateFormatted = self.dateFormatter.date(from: value!["start date"] as! String)
                    let endDateFormatted = self.dateFormatter.date(from: value!["end date"] as! String)
                    
                    //Converting to custom object of type Event
                    let eventObject = Event(title: value!["title"] as! String, details: value!["details"] as! String, startDate: startDateFormatted!, startTime: value!["start time"] as! Array<Int>, endDate: endDateFormatted!, endTime: value!["end time"] as! Array<Int>)
                    
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
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
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
            print(filteredEvents)
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
    
    //When cell is selected, show event detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "gigsToDetail", sender: self)
    }
    
    // Passing data when segue happens to event detail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let viewController = segue.destination as? EventDetailVC,
            let index = self.tableView.indexPathForSelectedRow {
            viewController.eventData = self.orderedSectionedEvents[index.section][index.row]
        }
    }
    
}

