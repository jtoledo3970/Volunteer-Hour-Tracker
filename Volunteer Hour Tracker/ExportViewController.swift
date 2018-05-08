//
//  ExportViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 11/18/17.
//  Copyright © 2017 Toledo's IT Solution's. All rights reserved.
//

import UIKit
import CoreData
import Eureka

class ExportViewController: FormViewController {
    //  Time Vars
    var tempHour = 0
    var tempHourR = 0
    var tempMin = 0
    var finalTotalHours = 0
    var finalTotalMin = 0
    
    // Core Data Information
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []

    var eventInfo = [[String : String]]()
    var event = [String:String]()
    
    var pdfComposer : PDFComposer!
    
    var HTMLContent : String!
    
    var selection = "PDF"
    
    var total : String!
    
    var filePath : NSURL!
    
//  fileName = "\(AppDelegate.getAppDelegate().getDocDir())/eventList.pdf"
//  fileName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Export Data"

        form
            +++ Section("Export Information")
            <<< TextAreaRow() { row in
                row.value = "This tool will allow you to export all of your data to a file and send it off from there. Click the file type then export and send it from the pop up."
                row.disabled = true
            }
            +++ Section("Export Options")
            <<< ActionSheetRow<String>() {
                $0.tag = "type"
                $0.title = "Select a File Type"
                $0.selectorTitle = "Please select a file type"
                $0.options = ["PDF", "Spreadsheet"]
                $0.value = "PDF"
            }
            +++ Section()
            <<< ButtonRow("Export") {
                $0.title = $0.tag
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.getData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        loadToDictionary()
    }
    
    func loadToDictionary() {
        var valuesDictionary = form.values()
        
        print(tasks.count)
        eventInfo.removeAll()
        for i in 0..<tasks.count {
            event.removeAll()
            
            tempHour += Int(tasks[i].timeSpentHours)
            tempMin += Int(tasks[i].timeSpentMinutes)
            
            event["name"] = tasks[i].eventName
            event["date"] = tasks[i].eventDate?.dateToString()
            event["start"] = tasks[i].timeStart?.timeToString()
            event["end"] = tasks[i].timeEnded?.timeToString()
            event["description"] = tasks[i].eventDescription
            
            eventInfo.append(event)
        }
        print(tasks)
        print(eventInfo.count)
        selection = valuesDictionary["type"] as! String
        print("Your selection was \(selection)")
        
        finalTime()
        
        if selection == "PDF" {
            createEventAsHTML()
        } else if selection == "Spreadsheet" {
            createEventAsCSV()
        }
    }
    
    func createEventAsHTML() {
        pdfComposer = PDFComposer()
        total = "\(finalTotalHours) Hours and \(finalTotalMin) Minutes"
        if let eventHTML = pdfComposer.renderInvoice(items: eventInfo, totalAmount: total) {
            HTMLContent = eventHTML
        } else {
            print("no load fam")
        }
        pdfComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        filePath = NSURL(fileURLWithPath: "\(AppDelegate.getAppDelegate().getDocDir())/eventList.pdf")
        
        shareFile()
    }
    
    func createEventAsCSV() {
        let fileName = "eventList.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "Event Name,Date,Start Time,End Time,Description\n"
        
        for i in 0..<tasks.count {
            let task = tasks[i]
            var tempDescription = ""
            if task.eventDescription == nil {
                tempDescription = " "
            } else {
                tempDescription = task.eventDescription!
            }
            
            let newLine = "\(task.eventName!),\"\(task.eventDate!.dateToString())\",\(task.timeStart!.timeToString()),\(task.timeEnded!.timeToString()),\(tempDescription)\n"
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            print(path)
            filePath = path as! NSURL
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        filePath = path as! NSURL
        shareFile()
    }
    
    func shareFile() {
        let interactionController = UIDocumentInteractionController(url: filePath as URL)
        let messageStr:String  = "Hey check out this my volunteer events"
        let shareItems:Array = [messageStr, filePath] as [Any]
        let activityController = UIActivityViewController(activityItems:shareItems, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = self.view
        }
        self.present(activityController, animated: true,completion: nil)
    }
    
    //  Time Functions
    func finalTime() {
        finalTotalHours = (tempMin / 60) + tempHour
        finalTotalMin = tempMin % 60
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
