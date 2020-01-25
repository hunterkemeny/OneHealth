//
//  LogViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import CoreData

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Make today the default value when the viewcontroller is opened

    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    
    var datePicker: UIDatePicker?
    
    var categories = ["Water:", "Meditation:", "Workout:", "Fasting:", "Meals:", "Supplements"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: Date())
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(LogViewController.dateChanged(datePicker: )), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LogViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        logTableView.delegate = self
        logTableView.dataSource = self
        
        
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
        
        for num in 0...results.count {
            if results[num].dateOfLog == dateFormatter.string(from: datePicker.date) {
                // the date chosen is stored in core data
                break
            }
            if num == results.count - 1 {
                // the date chosen is not stored in core data
                // need to find a way to reload the view controller after this is chosen
            }
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
       cell.setAttributes(category: categories[indexPath.row])
       return cell
   }
   
   // Segue for each item per day
}


