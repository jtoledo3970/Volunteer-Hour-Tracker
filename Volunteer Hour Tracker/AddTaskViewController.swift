//
//  AddTaskViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 4/29/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//

import UIKit

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


class AddTaskViewController: UITableViewController {
    
    // MARK: Variables
    var eventDate = NSDate()
    var timeStart = NSDate()
    var timeEnded = NSDate()
    var timeStarted : String = ""
    var timeEnd : String = ""
    var eventDates : String = ""
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var timeStartTextField: UITextField!
    @IBOutlet weak var timeEndedTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    
    var selected = ""

    @IBAction func timeStartedDidBeginEditing(_ sender: UITextField) {
        selected = "a"
        toolbarInitiation()
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(), animated: true)
        datePicker.datePickerMode = .time
        timeStartTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("Time Start Did Begin Editing")
    }
    
    @IBAction func timeEndedDidBeginEditing(_ sender: UITextField) {
        selected = "b"
        toolbarInitiation()
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(), animated: true)
        datePicker.datePickerMode = .time
        timeEndedTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("Time Ended Did Begin Editing")
    }
    
    @IBAction func eventDateDidBeginEditing(_ sender: UITextField) {
        selected = "c"
        toolbarInitiation()
        let datePicker = UIDatePicker()
        datePicker.setDate(Date(), animated: true)
        datePicker.datePickerMode = .date
        eventDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("Event Date Did Begin Editing")
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        toolbarInitiation()
        if (selected == "a") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeStarted = dateFormatter.string(from: sender.date)
            timeStartTextField.text = timeStarted
            timeStart = timeStarted.timeValue!
            print(timeStart)
        } else if (selected == "b") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            timeEnd = dateFormatter.string(from: sender.date)
            timeEndedTextField.text = timeEnd
            timeEnded = timeEnd.timeValue!
            print(timeEnded)
        } else if (selected == "c") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            eventDates = dateFormatter.string(from: sender.date)
            eventDateTextField.text = eventDates
            eventDate = eventDates.dateValue!
            print(eventDate)
        }
    }
    
    // MARK: - Tool Bar Functions Begin
    
    func toolbarInitiation() {
        // - MARK : Toolbar Function Information
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let todayBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTaskViewController.tappedToolBarBtn))
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddTaskViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Please make a selection"
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayBtn,flexSpace,textBtn,flexSpace,okBarBtn], animated: true)
        
        if (selected == "a") {
            timeStartTextField.inputAccessoryView = toolBar
        } else if (selected == "b") {
            timeEndedTextField.inputAccessoryView = toolBar
        } else if (selected == "c") {
            eventDateTextField.inputAccessoryView = toolBar
        }
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        if (selected == "a") {
            timeStartTextField.resignFirstResponder()
        } else if (selected == "b") {
            timeEndedTextField.resignFirstResponder()
        } else if (selected == "c") {
            eventDateTextField.resignFirstResponder()
        }
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        if (selected == "a") {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            timeStartTextField.text = dateformatter.string(from: Date())
            timeStartTextField.resignFirstResponder()
        } else if (selected == "b") {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "HH:mm"
            timeEndedTextField.text = dateformatter.string(from: Date())
            timeEndedTextField.resignFirstResponder()
        } else if (selected == "c") {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.medium
            eventDateTextField.text = dateformatter.string(from: Date())
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // End toolbar

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        title = "Add a New Event"
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // MARK: Difference in times
        var temp4 = timeEnded.timeIntervalSince(timeStart as Date)
        print(temp4)
        var timeSpent = secondsToHoursMinutesSeconds(seconds: Int(temp4))
        print(timeSpent)

        
        let task = Task(context: context)
        task.eventName = taskTextField.text!
        task.eventDate = eventDates
        task.timeStart = timeStartTextField.text!
        task.timeEnded = timeEndedTextField.text!
        task.timeSpentHours = Double(timeSpent.0)
        task.timeSpentMinutes = Double(timeSpent.1)
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
        }
}
