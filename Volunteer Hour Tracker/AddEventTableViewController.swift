//
//  AddEventTableViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 7/24/17.
//  Copyright © 2017 Toledo's IT Solution's. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation

// MARK: Extensions for Date and String
extension NSDate{
    var stringTimeValue : String {
        return self.timeToString()
    }
    
    var stringDateValue : String {
        return self.dateToString()
    }
    
    func timeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let str = formatter.string(from: self as Date)
        return str
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        let str = formatter.string(from: self as Date)
        return str
    }
}

extension String{
    var dateValue: NSDate? {
        return self.toDate()
    }
    
    var timeValue: NSDate? {
        return self.toTime()
    }
    
    func toDate() -> NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let date = formatter.date(from: self) {
            return date as NSDate
        } else {
            return nil
        }
    }
    
    func toTime() -> NSDate? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: self) {
            return date as NSDate
        } else {
            return nil
        }
    }
}

class AddEventFormViewController: FormViewController {
    // MARK: External Reources
    
    // MARK: Variables
    
    var complete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Event"
        
        // Back Button
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        
        form
            +++ Section("Event Information")
            <<< TextRow() { row in
                row.tag = "eventName"
                row.title = "Event Name"
                row.placeholder = "Enter text here"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.contentView.backgroundColor = UIColor.red
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
//            <<< PushRow<String>() { row in
//                row.title = "Organization"
//                row.options = ["1","2","3","4"]
//                row.selectorTitle = "Choose an Organization"
//        }
            <<< DateRow() { row in
                row.tag = "eventDate"
                row.value = Date()
                row.title = "Event Date"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                    }
                }
            <<< TimeRow() { row in
                row.tag = "startTime"
                row.value = Date()
                row.title = "Start Time"
            }
            <<< TimeRow() { row in
                row.tag = "endTime"
                row.value = Date()
                row.title = "End Time"
            }
            <<< TextAreaRow() { row in
                row.tag = "description"
                row.placeholder = "Enter a description of what you did here"
                row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
            }
        
        +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Done"
                }
                .onCellSelection { [weak self] (cell, row) in
                    row.section?.form?.validate()
                    self?.saveInformation()
                }
//            <<< LocationRow() {
//                row.title = "LocationRow"
//                row.value = CLLocation(latitude: -34.91, longitude: -56.1646)
//        }
    }
    
    func saveInformation() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var valuesDictionary = form.values()
        print(valuesDictionary["eventName"])
        var value = valuesDictionary["eventName"] as? String
        
        if (value != nil) {
            let timeStart = valuesDictionary["startTime"] as? Date
            let timeEnded = valuesDictionary["endTime"] as? Date
            let temp4 = timeEnded?.timeIntervalSince(timeStart!)
            print(temp4)
            let timeSpent = secondsToHoursMinutesSeconds(seconds: Int(temp4!))
            print(timeSpent)
            
            let task = Task(context: context)
            task.eventName = valuesDictionary["eventName"] as? String
            task.eventDate = valuesDictionary["eventDate"] as! NSDate
            task.timeStart = timeStart as! NSDate
            task.timeEnded = timeEnded as! NSDate
            task.timeSpentHours = Double(timeSpent.0)
            task.timeSpentMinutes = Double(timeSpent.1)
            task.eventDescription = valuesDictionary["description"] as? String
            
            
            
    //        // MARK: Difference in times
    //        let temp4 = timeEnded.timeIntervalSince(timeStart as Date)
    //        print(temp4)
    //        let timeSpent = secondsToHoursMinutesSeconds(seconds: Int(temp4))
    //        print(timeSpent)
    //        
    //        
    //        let task = Task(context: context)
    //        task.eventName = taskTextField.text!
    //        task.eventDate = eventDates
    //        task.timeStart = timeStartTextField.text!
    //        task.timeEnded = timeEndedTextField.text!
    //        task.timeSpentHours = Double(timeSpent.0)
    //        task.timeSpentMinutes = Double(timeSpent.1)
    //        // Save the data to coredata
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
//            performSegue(withIdentifier: "newEventBackSegue", sender: self)
        } else if (value == nil) {
            SCLAlertView().showWarning("You forgot something", subTitle: "Please enter data into every field. Thank you.")
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    
}
