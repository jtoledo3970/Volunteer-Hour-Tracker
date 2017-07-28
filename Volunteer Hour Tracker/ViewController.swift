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
    @IBOutlet weak var dateLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FloatyDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Task] = []
    
//    let fab = Floaty()
//    
//    func layoutFab() {
//        fab.addItem("Organization", icon: #imageLiteral(resourceName: "Pencil-Board-Black")) { (item) in
//            self.testButton("organization", #imageLiteral(resourceName: "Pencil-Board"))
//            self.fab.close()
//        }
//        fab.addItem("Event", icon: #imageLiteral(resourceName: "CalendarBigBlack")) { (item) in
//            self.testButton("event", #imageLiteral(resourceName: "CalendarBig"))
//            self.fab.close()
//        }
//        
//        fab.sticky = true
//        fab.paddingX = self.view.frame.width/6 - fab.frame.width
//        fab.paddingY = self.view.frame.height/10 - fab.frame.height/4
//        
//        fab.fabDelegate = self
//        
//        // print(tableView!.frame)
//        
//        self.view.addSubview(fab)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Left Bar Button Item
//        let leftBar = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didPressLeftButton))
//        navigationItem.leftBarButtonItem = leftBar
        
        title = "Volunteer Events"
        
//        layoutFab()
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
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
        let date = task.eventDate
        let stringDate = date?.dateToString()
        
        cell.eventTitleLabel?.text = myName
        cell.timeSpentLabel?.text = timeSpent
        cell.dateLabel?.text = stringDate
        
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
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
    }
    
    func testButton(_ t: String, _ image: UIImage) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Add a Text Field
        let appearance = SCLAlertView.SCLAppearance(
            kCircleBackgroundTopPosition: 4,
            kCircleIconHeight: 22,
            showCircularIcon: true
            // contentViewColor: UIColor(red:0, green:0.479, blue:0.999, alpha:1)
        )
        let alert = SCLAlertView(appearance: appearance)
//        let alertViewIcon = UIImage(named: "Pencil-Board")
        let txt = alert.addTextField("Enter here")
        alert.addButton("Add") {
            // Get 1st TextField's text
            let temp = txt.text
            print("The output of temp is \(String(describing: temp))")
            if !(temp?.isEmpty)! {
                print("This is temp before the save action: \(String(describing: temp))")
                let organization = Organization(context: context)
                organization.organizationName = temp
                print(temp!)
                // Save the data to coredata
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else {
                print("The text box was empty")
            }
        }
        alert.showEdit("Please enter the name", subTitle: "of the new \(t)", closeButtonTitle: "Cancel", colorStyle: 0x2e8ffa, circleIconImage:image)
        // End New Alert
        
//        let alert = UIAlertController(title: "Please enter the name",
//                                      message: "of the new organization",
//                                      preferredStyle: .alert)
//        alert.addTextField { (textField: UITextField) in
//            textField.keyboardAppearance = .dark
//            textField.keyboardType = .default
//            textField.autocorrectionType = .default
//            textField.placeholder = "Type something here"
//            textField.clearButtonMode = .whileEditing
//        }
//        var temp = ""
//        
//        // Submit button
//        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
//            // Get 1st TextField's text
//            let textField = alert.textFields![0]
//            temp = textField.text!
//            print("The output of temp is \(temp)")
//            if !temp.isEmpty {
//                print("This is temp before the save action: \(temp)")
//                let organization = Organization(context: context)
//                organization.organizationName = temp
//                print(temp)
//                // Save the data to coredata
//                
//                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//            } else {
//                print("The text box was empty")
//            }
//        })
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
//        
//        alert.addAction(submitAction)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
        
        
    }
    
    // Tab Bar Selection
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //This method will be called when user changes tab.
        print(item.tag)
    }
    
    func didPressLeftButton() {
        performSegue(withIdentifier: "eventToDetailSegue", sender: (Any).self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destination as! AddEventFormViewController
        //Change Back Button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
