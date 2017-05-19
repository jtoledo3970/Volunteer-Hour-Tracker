//
//  CategoryTableViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 5/19/17.
//  Copyright © 2017 Toledo IT Solution's. All rights reserved.
//
//

import UIKit

class CategoryTableViewCell : UITableViewCell {
    @IBOutlet weak var organizationNameLabel: UILabel!
}

class CategoryTableViewController : UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var organizations: [Organization] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Categories"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        
        // UITableViewCell()
        
        let organization = organizations[indexPath.row]
        
        
        let orgName = organization.organizationName
        
        cell.organizationNameLabel?.text = orgName
        
        return cell
    }
    
    @IBAction func testButton(_ sender: UIBarButtonItem) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        
        let alert = UIAlertController(title: "Please enter the name",
                                      message: "of the new organization",
                                      preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type something here"
            textField.clearButtonMode = .whileEditing
        }
        
        var temp = ""
        
        // Submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            temp = textField.text!
            print("The output of temp is \(temp)")
            if !temp.isEmpty {
                print("This is temp before the save action: \(temp)")
                let organization = Organization(context: context)
                organization.organizationName = temp
                print(temp)
            // Save the data to coredata
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.reloadData()
            } else {
                print("The text box was empty")
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func reloadData() {
        getData()
        self.tableView.reloadData()
    }
    
    func getData() {
        do {
            organizations = try context.fetch(Organization.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let organization = organizations[indexPath.row]
            context.delete(organization)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                organizations = try context.fetch(Organization.fetchRequest())
            }
            catch {
                print("Fetching Failed")
            }
        }
        tableView.reloadData()
    }
}
