//
//  DayPickerViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import UIKit
import CoreData

class DayPickerViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Properties
    
    var dateSelected = ""
    var values = ["", "", "", "", ""]
    let dateFormatter = DateFormatter()
    var dayMonthYearString: String!
    var dayMonthYearNum: String!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectTouched(_ sender: Any) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateSelected = dateFormatter.string(from: datePicker.date)
        
        // Fetch the list of all LogDate objects in Core Data, where a Log Date object is an object
        // whose attributes contain information bout a user's weight, calorie consumption, burned calories,
        // etc. for a given date.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        var logDateObjectList: [LogDate]
        do {
            try logDateObjectList = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        if logDateObjectList.count != 0 {
            for num in 0...(logDateObjectList.count - 1) {
                if logDateObjectList[num].dateOfLog == dateFormatter.string(from: datePicker.date) {
                    // Temporarily set the index value in logDateObjectList for this particular date in DayPicker
                    // so that this index can be accessed by LogViewController and the correct attributes
                    // can be displayed.
                    DayPicker.setDayMonthYearNum(dayMonthYearNum: num)
                    break
                }
                if num == logDateObjectList.count - 1 {
                    // When we reach the last object in logDateObjectList, this means that the date chosen is not a valid option in logDateObjectList. Therefore, store today's date as a new LogDate object in Core Data.
                    let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: datePicker.date), forKey: "dateOfLog")
                    // Temporarily set the index value in logDateObjectList for this particular date in DayPicker
                    // so that this index can be accessed by LogViewController and the correct attributes
                    // can be displayed.
                    DayPicker.setDayMonthYearNum(dayMonthYearNum: num)
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
        // When date is chosen, go back to to LogViewController.
        
        navigationController?.popViewController(animated: true)
        
    }

}
