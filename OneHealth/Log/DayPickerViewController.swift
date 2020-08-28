//
//  DayPickerViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import UIKit
import CoreData

class DayPickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateSelected = ""
    
    var values = ["", "", "", "", ""]
    
    let dateFormatter = DateFormatter()
    var dayMonthYearString: String!
    var dayMonthYearNum: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func cancelTouched(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectTouched(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        print(datePicker.date)
        dateSelected = dateFormatter.string(from: datePicker.date)
        
        DayPicker.setStringDate(sd: dateSelected)
        
        
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
                    DayPicker.setWeight(w: results[num].weight)
                    DayPicker.setWater(wa: results[num].water ?? "")
                    DayPicker.setMeditation(m: results[num].meditation ?? "")
                    DayPicker.setFast(f: results[num].fast ?? "")
                    
                    //LogViewController().logTableView.reloadData()
                    dayMonthYearString = results[num].dateOfLog
                    dayMonthYearNum = String(num)
                    break
                }
                if num == results.count - 1 {
                    let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                    
                    // Store today's date as dateOfLog attribute in Core Data.
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: datePicker.date), forKey: "dateOfLog")
                    
                    DayPicker.setWeight(w: results[num].weight)
                    DayPicker.setWater(wa: results[num].water ?? "")
                    DayPicker.setMeditation(m: results[num].meditation ?? "")
                    DayPicker.setFast(f: results[num].fast ?? "")
                    //LogViewController().logTableView.reloadData()
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
    
        print("HELO")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
