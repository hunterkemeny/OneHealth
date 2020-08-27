//
//  InsertInfoViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/25/20.
//

import UIKit
import CoreData

class InsertInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var categoryExecuted: UILabel!
    @IBOutlet weak var dayMonthYear: UILabel!
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var category: String!
    var logDate: String!
    var information: String!
    var placeholder: String!
    var dateNum: String!
    var logType: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryExecuted.text = category
        dayMonthYear.text = logDate
        enterTextField.placeholder = placeholder
        
        enterTextField.delegate = self
    }
    
    @IBAction func logTapped(_ sender: Any) {
        // Validates text fields.
        if enterTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showError("Please fill in all fields")
            return
        }
        
        information = enterTextField.text!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "User" object.
        var results: [LogDate]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        if category == "weight" {
            results[Int(dateNum)!].setValue(Double(information), forKey: "\(category ?? "")")
        } else {
            results[Int(dateNum)!].setValue(information, forKey: "\(category ?? "")")
        }
        
        // Save new user to Core Data.
        do {
            try context.save()
            print("successfully saved to coredata")
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        
        enterTextField.resignFirstResponder()
        return true
    }
    
    func setupElements() {
        // Hide the error label.
        errorLabel.alpha = 0
    }
    
    func showError(_ message : String)  {
        // Show the error label.
        
        errorLabel.text! = message
        errorLabel.alpha = 1
    }
}
