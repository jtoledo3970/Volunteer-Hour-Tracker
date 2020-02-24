//
//  EventViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 4/29/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//

import UIKit
import CoreData

class VolunteerTableViewCell : UITableViewCell {
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class TotalTableViewCell : UITableViewCell {
    @IBOutlet weak var totalLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FloatyDelegate, UITabBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks: [Task] = []
    var sendingIndex: Int = 0
    var show = false
    
    var eventInfo = [[String : String]]()
    var event = [String:String]()
    var pdfComposer : PDFComposer!
    var HTMLContent : String!
    var total = "0"
    
//    Time Vars
    var tempHour = 0
    var tempHourR = 0
    var tempMin = 0
    var finalTotalHours = 0
    var finalTotalMin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        // DZN Empty Dataset
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Events"
        
        tableView.rowHeight = 60.0
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    // MARK: DZNEmptyDataSet
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the button below to add your first event!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "LaunchIcon")
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        let str = "Add Event!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        performSegue(withIdentifier: "eventToNewEventSegue", sender: self)

    }
    
    
    // MARK: Table View Data Set
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VolunteerTableViewCell
            
        // UITableViewCell()
        
        let task = tasks[indexPath.row]
        
        
        let myName = task.eventName
        let timeSpent = String(task.timeSpentHours) + " hours " + String(task.timeSpentMinutes) + " minutes"
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
        tempHour = 0
        tempMin = 0
        for i in 0..<tasks.count {
            print(tasks[i].eventName!)
            tempHour += Int(tasks[i].timeSpentHours)
            tempMin += Int(tasks[i].timeSpentMinutes)
        }
        finalTime()
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendingIndex = indexPath.row
        show = true
        performSegue(withIdentifier: "showEventSegue", sender: sendingIndex)
    }
    
    //  Time Functions
    func finalTime() {
        finalTotalHours = (tempMin / 60) + tempHour
        finalTotalMin = tempMin % 60
        print("Final total hours \(finalTotalHours)")
    }
    
    // Tab Bar Selection
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //This method will be called when user changes tab.
        print(item.tag)
    }
    
    func didPressLeftButton() {
        performSegue(withIdentifier: "eventToDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareForSegue")
        let detailViewController = segue.destination as! AddEventFormViewController
        if (segue.identifier == "eventToNewEventSegue") {
            detailViewController.new = true
        }
        if (segue.identifier == "showEventSegue") {
            print("Segue has begun for show")
            detailViewController.index = sendingIndex
            detailViewController.show = true
            print(sendingIndex)
        }
        //Change Back Button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
