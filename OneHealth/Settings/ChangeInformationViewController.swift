//
//  ChangeInformationViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

// ERROR1: If they enter a numerical value for a string text field or vice versa, show Error.
// TODO: Change results to have days instead of weeks to complete goal?

import UIKit
import CoreData
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class ChangeInformationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sexSwitch: UISegmentedControl!
    @IBOutlet weak var goalTypeSwitch: UISegmentedControl!
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var weightGoalTextField: UITextField!
    @IBOutlet weak var weeksTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    
    var database: Firestore!
    let userID: String? = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize reference to Firestore database.
        database = Firestore.firestore()
        
        // Make error label transluscent until an error is thrown.
        errorLabel.alpha = 0
        
        currentWeightTextField.delegate = self
        weightGoalTextField.delegate = self
        weeksTextField.delegate = self
    }
    
    // MARK: - Helper functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        currentWeightTextField.resignFirstResponder()
        weightGoalTextField.resignFirstResponder()
        weeksTextField.resignFirstResponder()
        return true
    }

    func showError(_ message : String)  {
        errorLabel.text! = message
        errorLabel.alpha = 1
    }
    
    func writeData(data: String) {
        // Write data to the Firestore Database. Print error in the console.
        database.collection("userInfo").document(userID!).setData(["sex": data], merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // MARK: - Methods
    
    @IBAction func updateTouched(_ sender: Any) {
        // Update data in Core Data as well as in the Firestore Database.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        // Fetch the "User" object.
        var results: [User]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        // Declare variables for segmented controls.
        var userSex: String = ""
        var goalType: String = ""
        
        // Update sex in Core Data, Firestore Database and PersonInfo.
        if sexSwitch.selectedSegmentIndex == 0 {
            userSex = "Male"
            PersonInfo.setSex(sex: 1)
        } else {
            userSex = "Female"
            PersonInfo.setSex(sex: 0)
        }
        results[0].setValue(userSex, forKey: "sex")
        writeData(data: userSex)
        
        // Update goal type in Core Data, PersonInfo in Firestore Database.
        if goalTypeSwitch.selectedSegmentIndex == 0 {
            goalType = "gain"
            PersonInfo.setGainLoseMaintain(gainLoseMaintain: goalType)
        } else if goalTypeSwitch.selectedSegmentIndex == 1 {
            goalType = "lose"
            PersonInfo.setGainLoseMaintain(gainLoseMaintain: goalType)
        } else {
            goalType = "maintain"
            PersonInfo.setGainLoseMaintain(gainLoseMaintain: goalType)
        }
        results[0].setValue(goalType, forKey: "goalType")
        writeData(data: goalType)
        
        // Update desired number of weeks until goal is achieved in Core Data and Firestore Database.
        if weeksTextField.text != "" {
            let weeksToComplete = Int(weeksTextField.text!)!*7
            results[0].setValue(weeksTextField.text, forKey: "weeksToComplete")
            writeData(data: String(weeksToComplete))
            PersonInfo.setWeeksToComplete(weeksToComplete: weeksToComplete)
        }
        
        // Update weight goal in Core Data and Firestore Database.
        if weightGoalTextField.text != "" {
            results[0].setValue(weightGoalTextField.text, forKey: "weightGoal")
            writeData(data: weightGoalTextField.text!)
            PersonInfo.setWeightChangeGoal(weightChangeGoal: String(abs(Double(weightGoalTextField.text!)! - PersonInfo.getWeight())))
        }
        
        // Update current weight in Core Data and Firestore Database.
        if currentWeightTextField.text != "" {
            results[0].setValue(currentWeightTextField.text, forKey: "weight")
            writeData(data: currentWeightTextField.text!)
            PersonInfo.setWeight(weight: Double(currentWeightTextField.text!)!)
        }
        
        do {
            try context.save()
            showError("Information Changed Successfully!")
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // After data is updated, pop current view controller and move back to Settings TableView Controller.
        let controllers = self.navigationController?.viewControllers
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           for vc in controllers! {
              if vc is SettingsTableViewController {
                _ = self.navigationController?.popToViewController(vc as! SettingsTableViewController, animated: true)
              }
           }
        }
    }
    

}
