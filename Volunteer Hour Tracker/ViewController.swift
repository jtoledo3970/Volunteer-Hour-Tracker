//
//  ViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 4/29/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//

import UIKit

class VolunteerTableViewCell : UITableViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Volunteer Events"
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VolunteerTableViewCell
            
        // UITableViewCell()
        
        let task = tasks[indexPath.row]
        
        
        let myName = task.eventName
        let timeSpent = String(task.timeSpentHours) + " hours and " + String(task.timeSpentMinutes) + " minutes"
        
        cell.eventTitleLabel?.text = myName
        cell.timeSpentLabel?.text = timeSpent
        
        /*
        if let myName = task.name {
            cell.eventTitleLabel?.text = myName
        }
        if let myTime = task.timeSpent {
            var timeSpent = "Test"
            cell.timeSpentLabel?.text = timeSpent
        }
        */
        
        return cell
    }
    
    func getData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                tasks = try context.fetch(Task.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destination as! AddTaskViewController
        //Change Back Button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
