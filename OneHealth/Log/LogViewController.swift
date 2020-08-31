//
//  LogViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    
    // MARK: - Properties
    
    var categories = ["Weight", "Water", "Meditation", "Fast"]
    var values = ["", "", "", "", ""]
    let dateFormatter = DateFormatter()
    var categoryExectued: String!
    var dayMonthYearString: String!
    var dayMonthYearNum: String! // The index of the particular date chosen in the LogDateObjectList.
    var placeHolder: String!
    
    // MARK: - Helper Methods
    
    func getPersistentContainerContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func getLogDateObjectList() -> [LogDate] {
        // Returns the list of all LogDate objects in Core Data, where a Log Date object is an object
        // whose attributes contain information bout a user's weight, calorie consumption, burned calories,
        // etc. for a given date.
        let context = getPersistentContainerContext()
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var logDateObjectList: [LogDate]
        do {
            try logDateObjectList = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        return logDateObjectList
    }
    
    func setCategoryValues(logDateObjectList: [LogDate], index: Int) {
        values[0] = String(logDateObjectList[index].weight) ?? ""
        values[1] = logDateObjectList[index].water ?? ""
        values[2] = logDateObjectList[index].meditation ?? ""
        values[3] = logDateObjectList[index].fast ?? ""
        dayMonthYearString = logDateObjectList[index].dateOfLog
        dayMonthYearNum = String(index) // figure out what this does
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the dateFormatter object equal to a specific format.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // If a date has not been picked yet, set dateTextField to today's date.
        dateTextField.text = dateFormatter.string(from: Date())
        print(Date())
        
        let logDateObjectList = getLogDateObjectList()
        if logDateObjectList.count != 0 {
            for num in 0...(logDateObjectList.count - 1) {
                // If today is already stored as a LogDate object in Core Data, then update
                // the values associated with each category with the values stored in the LogDate Object.
                if logDateObjectList[num].dateOfLog == dateFormatter.string(from: Date()) {
                    setCategoryValues(logDateObjectList: logDateObjectList, index: num)
                    break
                }
                if num == logDateObjectList.count - 1 {
                    // When we reach the last object in logDateObjectList, this means that the date chosen is not a valid option in logDateObjectList. Therefore, store today's date as a new LogDate object in Core Data.
                    let context = getPersistentContainerContext()
                    let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
                    // Set the values for each category based on the information in the LogDateObject.
                    setCategoryValues(logDateObjectList: logDateObjectList, index: num)
                }
            }
            
            // Save the set of values for the chosen date to Core Data.
            let context = getPersistentContainerContext()
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        logTableView.delegate = self
        logTableView.dataSource = self
        logTableView.reloadData()
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        // When a new date is chosen, LogViewController must be updated with the appropriate attributes.
        let logDateObjectList = getLogDateObjectList()
        if logDateObjectList.count != 0 {
            for num in 0...(logDateObjectList.count - 1) {
                if String(num) == String(DayPicker.getDayMonthYearNum()) {
                    // Get the index for the date chosen and set the dateTextField and category values to the
                    // corresponding attributes associated with the given day in logDateObjectList.
                    dateTextField.text = logDateObjectList[num].dateOfLog
                    setCategoryValues(logDateObjectList: logDateObjectList, index: num)
                    break
                }
            }
        }
        
    // Reload the data for the table view so that it updates when a user logs info in InsertInfo ViewController.
    logTableView.reloadData()
    }
    
    // MARK: TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns one total section for the log.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns 4 rows (one per each category).
        return 4
       }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = logTableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        // Set the attributes of the cell based on the specific category and whether or not the user has logged a
        // value for that category yet.
        cell.setAttributes(category: categories[indexPath.row], logValue: values[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // InsertInfoViewController needs place holders for its text fields. The units for these placeholders are
        // determined based on the category of the particular row.
        categoryExectued = categories[indexPath.row]
        if categoryExectued == "Weight" {
            placeHolder = "lbs"
        } else if categoryExectued == "Water" {
            placeHolder = "oz drank"
        } else if categoryExectued == "Meditation" {
            placeHolder = "minutes meditated"
        } else {
            placeHolder = "hours fasted"
        }
        
        // Perform segue to instantiate an InsertInfoViewController that displays the attributes of a particular category..
        self.performSegue(withIdentifier: "logSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logSegue" {
            // Sets the attributes for InsertInfoViewController based on the category that is selected in
            // LogViewController.
            let detailVC = segue.destination as! InsertInfoViewController
            detailVC.logDate = dayMonthYearString
            detailVC.category = categoryExectued
            detailVC.dateNum = dayMonthYearNum
            detailVC.placeholder = placeHolder
        }
    }
}


