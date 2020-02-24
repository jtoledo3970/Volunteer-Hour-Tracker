//
//  DashboardViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose M Toledo on 3/7/19.
//  Copyright © 2019 Toledo's IT Solution's. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
//  IB Outlets
    @IBOutlet weak var totalEventsTextField: UITextField!
    @IBOutlet weak var totalHoursTextField: UITextField!
//  Core Data Information
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []
    var eventInfo = [[String : String]]()
    var event = [String:String]()
    // Time Vars
    var tempHour = 0
    var tempHourR = 0
    var tempMin = 0
    var finalTotalHours = 0
    var finalTotalMin = 0
    var taskCount = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
        totalEventsTextField.text = taskCount
        let totalHours = "\(finalTotalHours) Hours and \(finalTotalMin) Minutes"
        totalHoursTextField.text = totalHours
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Data Functions
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
        taskCount = String(tasks.count)
        tempHour = 0
        tempMin = 0
        for i in 0..<tasks.count {
            print(tasks[i].eventName!)
            tempHour += Int(tasks[i].timeSpentHours)
            tempMin += Int(tasks[i].timeSpentMinutes)
        }
        finalTime()
    }
    
    func finalTime() {
        finalTotalHours = (tempMin / 60) + tempHour
        finalTotalMin = tempMin % 60
        print("Final total hours \(finalTotalHours)")
    }
}
