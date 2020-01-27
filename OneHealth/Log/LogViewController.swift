//
//  LogViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Make today the default value when the viewcontroller is shown
    // fix the ability to tap out of the datepicker

    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker: UIDatePicker?
    
    var categories = ["water", "meditation", "workout", "fast", "meals", "supplements"]
    var values = ["", "", "", "", "", ""]
    
    var categoryExectued: String!
    var dayMonthYearString: String!
    var dayMonthYearNum: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: Date())
        
        // Check todays logs
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var results: [LogDate]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        if results.count != 0 {
            print(results)
            for num in 0...results.count {
                if results[num].dateOfLog == dateFormatter.string(from: Date()) {
                    // today is stored in core data
                    // If they open up the logviewcontroller for the first time, then they log something, when they press back
                    // viewcontroller needs to update to show that they logged something
                    values[0] = results[num].water ?? ""
                    values[1] = results[num].meditation ?? ""
                    values[2] = results[num].workout ?? ""
                    values[3] = results[num].fast ?? ""
                    values[4] = results[num].meals ?? ""
                    values[5] = results[num].supplements ?? ""
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                    break
                }
                if num == results.count - 1 {
                    let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                    
                    // Store today's date as dateOfLog attribute in Core Data.
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
                    values[0] = results[num].water ?? ""
                    values[1] = results[num].meditation ?? ""
                    values[2] = results[num].workout ?? ""
                    values[3] = results[num].fast ?? ""
                    values[4] = results[num].meals ?? ""
                    values[5] = results[num].supplements ?? ""
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                }
            }
            // Save new date to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        
        logTableView.delegate = self
        logTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(LogViewController.dateChanged(datePicker: )), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var results: [LogDate]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        if results.count != 0 {
            for num in 0...(results.count - 1) {
                if String(num) == dayMonthYearNum {
                    values[0] = results[num].water ?? ""
                    values[1] = results[num].meditation ?? ""
                    values[2] = results[num].workout ?? ""
                    values[3] = results[num].fast ?? ""
                    values[4] = results[num].meals ?? ""
                    values[5] = results[num].supplements ?? ""
                    logTableView.reloadData()
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                    break
                }
            }
        }
        
        // Causing tap in tableview to break
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LogViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
         */
        logTableView.reloadData()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var results: [LogDate]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        if results.count != 0 {
            for num in 0...(results.count - 1) {
                if results[num].dateOfLog == dateFormatter.string(from: datePicker.date) {
                    values[0] = results[num].water ?? ""
                    values[1] = results[num].meditation ?? ""
                    values[2] = results[num].workout ?? ""
                    values[3] = results[num].fast ?? ""
                    values[4] = results[num].meals ?? ""
                    values[5] = results[num].supplements ?? ""
                    logTableView.reloadData()
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                    break
                }
                if num == results.count - 1 {
                    let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                    
                    // Store today's date as dateOfLog attribute in Core Data.
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: datePicker.date), forKey: "dateOfLog")
                    
                    values[0] = results[num].water ?? ""
                    values[1] = results[num].meditation ?? ""
                    values[2] = results[num].workout ?? ""
                    values[3] = results[num].fast ?? ""
                    values[4] = results[num].meals ?? ""
                    values[5] = results[num].supplements ?? ""
                    logTableView.reloadData()
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                }
            }
        }
        
        // Save new date to Core Data.
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        view.endEditing(true)
    }
    
    
   func numberOfSections(in tableView: UITableView) -> Int {
       // Returns one total section for the log.
       return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 6
   }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = logTableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        // Set the attributes of the cell based on the Places To Eat protocol.
        cell.setAttributes(category: categories[indexPath.row], value: values[indexPath.row])
        return cell
   }
   
   // Segue for each item per day. going to get segue information from core data based on the day selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Associate business attributes with each collectionViewCell.
        categoryExectued = categories[indexPath.row]
        
        // Perform segue to instantiate a BusinessTableViewController using the previously initialized business attributes.
        self.performSegue(withIdentifier: "logSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logSegue" {
            let detailVC = segue.destination as! InsertInfoViewController
            detailVC.logDate = dayMonthYearString
            detailVC.category = categoryExectued
            detailVC.dateNum = dayMonthYearNum
        }
    }
    
}


