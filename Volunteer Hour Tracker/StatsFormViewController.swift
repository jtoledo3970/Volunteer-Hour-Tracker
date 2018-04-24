//
//  StatsFormViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Administrator on 3/11/18.
//  Copyright © 2018 Toledo's IT Solution's. All rights reserved.
//

import UIKit
import Eureka
import CoreData

class StatsFormViewController : FormViewController {
    // Core Data Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []
    
    // Time Variables
    var tempHour = 0
    var tempHourR = 0
    var tempMin = 0
    var finalTotalHours = 0
    var finalTotalMin = 0
    
    var eventCount = 0
    
    // Standard Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Event Stats"
        
        getData()
        
        if (finalTotalHours == 0 && finalTotalMin == 0) {
            // TODO: Input DZNEmptyDataSet Here
            print("There was some error here")
        } else {
            loadForm()
        }
    }
    
    // Get Data Functions
    func getData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Task.eventDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            tasks = try context.fetch(fetchRequest)
        }
        catch {
            print("Fetching Failed")
        }
        
        print(tasks.count)
        eventCount = tasks.count
        for i in 0..<tasks.count {
            print(tasks[i].eventName!)
            tempHour += Int(tasks[i].timeSpentHours)
            tempMin += Int(tasks[i].timeSpentMinutes)
        }
        finalTime()
    }
    
    func loadForm() {
        form
        +++ Section("Event Stats")
        <<< TextRow() { row in
            row.title = "Total Hours Volunteered"
            row.value = String(finalTotalHours)
            row.disabled = true
        }
        <<< TextRow() { row in
            row.title = "Total Minutes Volunteered"
            row.value = String(finalTotalMin)
            row.disabled = true
        }
        <<< TextRow() { row in
            row.title = "Total Number of Events"
            row.value = String(eventCount)
            row.disabled = true
        }
    }
    
//    // DZN Empty Dataset
//    tableView.emptyDataSetSource = self
//    tableView.emptyDataSetDelegate = self
//    tableView.tableFooterView = UIView()
//
//    tableView.delegate = self
//    tableView.dataSource = self
    
    // Time Functions
    func finalTime() {
        finalTotalHours = (tempMin / 60) + tempHour
        finalTotalMin = tempMin % 60
    }
}
