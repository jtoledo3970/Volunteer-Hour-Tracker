//
//  InformationViewController.swift
//  Volunteer Hour Tracker
//
//  Created by Jose Toledo on 7/25/17.
//  Copyright © 2017 Toledo's IT Solutions, Inc. All rights reserved.
//

import UIKit
import Eureka
import MessageUI
import StoreKit
import CoreData

class InformationViewController: FormViewController, MFMailComposeViewControllerDelegate {
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
    var taskCount = 0
    
    var selection = ""
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Information"

        let strVersion = Bundle .main .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let strBuild = Bundle .main .object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let version = strVersion! + "." + strBuild!

        form
            +++ Section("Application Information")
            <<< TextRow() { row in
                row.title = "Application Version"
                row.value = version
                row.disabled = true
            }
            <<< DateTimeRow() { row in
                row.title = "Current Date"
                row.value = Date()
                row.disabled = true
            }
            <<< LabelRow() { row in
                row.title = "2019 © Toledo's IT Solutions, Inc."
            }
            
            +++ Section("Your Statistics")
            <<< TextRow() { row in
                row.title = "Total Events"
                row.value = String(taskCount)
                row.disabled = true
            }
            <<< TextRow() { row in
                row.title = "Total Hours"
                row.value = ""
                row.disabled = true
            }

            +++ Section()
            <<< ButtonRow("Send Feedback") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "FeedbackViewControllerSegue", onDismiss: nil)
            }
            <<< ButtonRow("Share this App") {
                $0.title = $0.tag
            }
                .onCellSelection { [weak self] (cell, row) in
                    self?.share()
            }
            <<< ButtonRow("Write a Review") {
                $0.title = $0.tag
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.review()
            }

            +++ Section("Legal")
            <<< ButtonRow("Terms of Use") {
                $0.title = $0.tag
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.selection = "terms"
                    self?.move()
                }
            <<< ButtonRow("Privacy Policy") {
                $0.title = $0.tag
            }
                .onCellSelection { [weak self] (cell, row) in
                    self?.selection = "privacy"
                    self?.move()
            }
            <<< ButtonRow("Disclaimers") {
                $0.title = $0.tag

            }
            .onCellSelection { [weak self] (cell, row) in
                self?.selection = "disclaimer"
                self?.move()
            }
            <<< ButtonRow("Open Source Libraries") {
                $0.title = $0.tag

                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.selection = "libraries"
                    self?.move()
            }
    }

    func move() {
        performSegue(withIdentifier: "LegalSegue", sender: self)
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
        taskCount = tasks.count
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
        self.tableView.reloadData()
    }

    // Share Function
    func share() {
        let message = "Check out this Volunteer Hour Tracker"
        if let link = NSURL(string: "https://itunes.apple.com/us/app/volunteer-hour-tracker/id1263708134?mt=8")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    // Review Functionality
    func review() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string : "itms-apps://itunes.apple.com/us/app/volunteer-hour-tracker/id1263708134?mt=8")!);
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LegalSegue") {
            let nextScene = segue.destination as? LegalViewController
            var selectedLegal = selection
            nextScene?.selection = selectedLegal
        }
    }
}

class FeedbackViewController: FormViewController, MFMailComposeViewControllerDelegate {

    var finalBody = ""
    var selection = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Send Feedback"

        // Back Button
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton

        var specs = true

        let strVersion = Bundle .main .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let strBuild = Bundle .main .object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let version = strVersion! + "." + strBuild!

        var systemVersion = UIDevice.current.systemVersion;
        var device = UIDevice.current.modelName

        form
            +++ Section("Type of Feedback")
                <<< TextAreaRow() { row in
                    row.tag = "feedback"
                    row.placeholder = "Enter your feedback here"
                    row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                    row.add(rule: RuleRequired())
                    row.validationOptions = .validatesOnChange
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

            +++ Section("Device Information")
                <<< DateTimeRow("Date and Time") {
                    $0.title = $0.tag
                    $0.value = Date()
                }
                <<< SwitchRow("specificationRowTag") { row in
                    row.title = "Include Device Specifications"
                    row.value = true
                } .onChange() { row in
                    if (row.value == true) {
                        specs = true
                    } else if(row.value == false) {
                        specs = false
                    }
                }

                <<< TextRow() { row in
                    row.hidden = Condition.function(["specificationRowTag"], { form in
                        return !((form.rowBy(tag: "specificationRowTag") as? SwitchRow)?.value ?? false)
                    })
                    row.title = "Device"
                    row.value = device
                    row.disabled = true

                }
                <<< TextRow() { row in
                    row.hidden = Condition.function(["specificationRowTag"], { form in
                        return !((form.rowBy(tag: "specificationRowTag") as? SwitchRow)?.value ?? false)
                    })
                    row.title = "iOS Version"
                    row.value = systemVersion
                    row.disabled = true

                }
                <<< TextRow() { row in
                    row.hidden = Condition.function(["specificationRowTag"], { form in
                        return !((form.rowBy(tag: "specificationRowTag") as? SwitchRow)?.value ?? false)
                    })
                    row.title = "Application Version"
                    row.value = version
                    row.disabled = true

                }
            +++ Section()
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Send"
                    }
                    .onCellSelection { [weak self] (cell, row) in
                        let row: TextAreaRow? = self?.form.rowBy(tag: "feedback")
                        let value = row?.value
                        print(value)
                        if (value != nil) {
                            row?.section?.form?.validate()
                            if (specs == true) {
                                self?.finalBody = value! + "\r\n" + "\r\n" + "This is my device information:" + "\r\n" + "Device: " + device + "\r\n" + "iOS Version: " + systemVersion + "\r\n" + "This is the app version: " + version
                            } else if (specs == false) {
                                self?.finalBody = value!
                            }

                            self!.sendMail()
                        } else if (value == nil){
                            SCLAlertView().showWarning("You forgot something", subTitle: "Please enter data into every field. Thank you.")
                        }
                    }
            +++ Section("We take your privacy seriously")
                <<< ButtonRow("Privacy Policy") {
                    $0.title = $0.tag
                    }
                    .onCellSelection { [weak self] (cell, row) in
                        self?.selection = "privacy"
                        self?.move()
                }
        }

    func move() {
        performSegue(withIdentifier: "LegalSegue", sender: self)
    }

    func sendMail() {
//        var finalBody = ""
        let subjectText = "Feedback for Volunteer Hour Tracker"
//        if (specs == true) {
//            finalBody = Body + "\r\n" + "\r\n" + "This is my device information:" + "\r\n" + "Device: " + device + "\r\n" + "iOS Version: " + systemVersion + "\r\n" + "This is the app version: " + version
//        } else if (specs == false) {
//            finalBody = Body
//        }
        if MFMailComposeViewController.canSendMail() {
            print("Can send mail")
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setSubject(subjectText)
            mail.setToRecipients(["jose@toledositsolutions.com"])
            mail.setMessageBody(finalBody, isHTML: false)

            self.present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            print("cannot send mail")
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("controller reached")
        switch (result.rawValue) {
//        case .cancelled:
            case MFMailComposeResult.cancelled.rawValue:
                controller.dismiss(animated: true, completion: nil)
                NSLog("Mail Cancelled")
            case MFMailComposeResult.saved.rawValue:
                controller.dismiss(animated: true, completion: nil)
                NSLog("Mail Saved")
            case MFMailComposeResult.sent.rawValue:
                controller.dismiss(animated: true, completion: nil)
                NSLog("Mail Sent")
            case MFMailComposeResult.failed.rawValue:
                controller.dismiss(animated: true, completion: nil)
                NSLog("Sending Mail Failed")
            default:
                break
        }

        controller.dismiss(animated: true, completion: nil)
    }
}

class LegalViewController: UIViewController {
    @IBOutlet weak var webView:UIWebView!

    var selection = "privacy"

    override func viewDidLoad() {
        title = "Legal"

        // Back Button
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton

        print(selection)

        let url = Bundle.main.url(forResource: selection, withExtension: "html")
        let request = NSURLRequest(url: url as! URL)
        webView.loadRequest(request as URLRequest)
    }

}
