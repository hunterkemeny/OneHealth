//
//  InsertInfoViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/25/20.
//

import UIKit
import CoreData

class InsertInfoViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var categoryExecuted: UILabel!
    @IBOutlet weak var dayMonthYear: UILabel!
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    
    var category: String!
    var logDate: String!
    var information: String!
    var placeholder: String!
    var dateNum: String! // The index of the particular date chosen in the LogDateObjectList.
    var logType: String!
    
    // MARK: - Helper Functions
    
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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryExecuted.text = category
        dayMonthYear.text = logDate
        enterTextField.placeholder = placeholder
        enterTextField.delegate = self
    }
    
    @IBAction func logTapped(_ sender: Any) {
        // Logs information to Core Data.
        
        // Fetch a list of all LogDate objects Core Data, where a Log Date object is an object
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
        
        // Validates text fields.
        if enterTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showError("Please fill in all fields")
            return
        }
        information = enterTextField.text!
        if category == "Calories Consumed" {
            logDateObjectList[Int(dateNum)!].setValue(Double(information), forKey: "calsIntake")
        } else if category == "Weight" {
            logDateObjectList[Int(dateNum)!].setValue(Double(information), forKey: "\(category ?? "")")
        } else {
            logDateObjectList[Int(dateNum)!].setValue(information, forKey: "\(category ?? "")")
        }
        
        // Save information to Core Data
        do {
            try context.save()
            print("successfully saved to coredata")
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        view.endEditing(true)
        
        // When information is logged, go back to to LogViewController.
        navigationController?.popViewController(animated: true)
    }
    
}
