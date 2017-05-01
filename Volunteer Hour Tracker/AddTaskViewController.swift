//
//  AddTaskViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Administrator on 4/29/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//

 import UIKit
 
class AddTaskViewController: UITableViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var timeStartTextField: UITextField!
    @IBOutlet weak var timeEndedTextField: UITextField!
    @IBOutlet weak var eventDateTextField: UITextField!
    
    var selected = ""

    @IBAction func timeStartedDidBeginEditing(_ sender: UITextField) {
        selected = "a"
        let datePicker = UIDatePicker()
        timeStartTextField.inputView = datePicker
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("This Worked")
    }
    
    @IBAction func timeEndedDidBeginEditing(_ sender: UITextField) {
        selected = "b"
        let datePicker = UIDatePicker()
        timeEndedTextField.inputView = datePicker
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("This Worked")
    }
    
    @IBAction func eventDateDidBeginEditing(_ sender: UITextField) {
        selected = "c"
        let datePicker = UIDatePicker()
        eventDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        print("This Worked")
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if (selected == "a") {
            timeStartTextField.text = dateFormatter.string(from: sender.date)
        } else if (selected == "b") {
            timeEndedTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        // - MARK : Toolbar Function Information
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let todayBtn = UIBarButtonItem(title: "Today/Current Time", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddTaskViewController.tappedToolBarBtn))
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
        if (selected == "a") {
            timeStartTextField.resignFirstResponder()
        } else if (selected == "b") {
            timeEndedTextField.resignFirstResponder()
        }
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        if (selected == "a") {
            timeStartTextField.text = dateformatter.string(from: Date())
            timeStartTextField.resignFirstResponder()
        } else if (selected == "b") {
            timeEndedTextField.text = dateformatter.string(from: Date())
            timeEndedTextField.resignFirstResponder()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // End toolbar
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Task(context: context)
        task.name = taskTextField.text!
        task.timeSpent = Double(timeStartTextField.text!)!
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
        }
}
