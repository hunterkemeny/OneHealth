//
//  ChangeInformationViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit
import CoreData
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class ChangeInformationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sexSwitch: UISegmentedControl!
    @IBOutlet weak var goalTypeSwitch: UISegmentedControl!
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var weightGoalTextField: UITextField!
    @IBOutlet weak var weeksTextField: UITextField!
    @IBOutlet weak var mealsTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var db: Firestore!
    let userID:String? = Auth.auth().currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        db = Firestore.firestore()
        
        currentWeightTextField.delegate = self
        weightGoalTextField.delegate = self
        weeksTextField.delegate = self
        mealsTextField.delegate = self
    }
    
    @IBAction func updateTouched(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Store values for segmented controls.
        var userSex: String = ""
        var goalType: String = ""
        
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
        
        if sexSwitch.selectedSegmentIndex == 0 {
            userSex = "Male"
        } else {
            userSex = "Female"
        }
        results[0].setValue(userSex, forKey: "sex")
        db.collection("userInfo").document(userID!).setData(["sex": userSex], merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        if goalTypeSwitch.selectedSegmentIndex == 0 {
            goalType = "gain"
        } else if goalTypeSwitch.selectedSegmentIndex == 1 {
            goalType = "lose"
        } else {
            goalType = "maintain"
        }
        results[0].setValue(goalType, forKey: "goalType")
        db.collection("userInfo").document(userID!).setData(["goal-type": goalType], merge:true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        if weeksTextField.text != "" {
            results[0].setValue(weeksTextField.text, forKey: "weeksToComplete")
            db.collection("userInfo").document(userID!).setData(["time-to-complete": weeksTextField.text!], merge:true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        if weightGoalTextField.text != "" {
            results[0].setValue(weightGoalTextField.text, forKey: "weightGoal")
            db.collection("userInfo").document(userID!).setData(["weight-change-goal": weightGoalTextField.text!], merge:true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        if currentWeightTextField.text != "" {
            results[0].setValue(currentWeightTextField.text, forKey: "weight")
            //ProfileTableViewController.currentWeightLabel.text = results[0].weight
            db.collection("userInfo").document(userID!).setData(["weight": currentWeightTextField.text!], merge:true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        if mealsTextField.text != "" {
            results[0].setValue(mealsTextField.text, forKey: "meals")
            db.collection("userInfo").document(userID!).setData(["num-meals": mealsTextField.text!], merge:true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        do {
            try context.save()
            showError("Information Changed Successfully!")
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        let controllers = self.navigationController?.viewControllers
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
           for vc in controllers! {
              if vc is SettingsTableViewController {
                _ = self.navigationController?.popToViewController(vc as! SettingsTableViewController, animated: true)
              }
           }
        }
        
        
        //self.navigationController?.popViewController(animated: false)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        
        currentWeightTextField.resignFirstResponder()
        weightGoalTextField.resignFirstResponder()
        weeksTextField.resignFirstResponder()
        mealsTextField.resignFirstResponder()
        return true
    }
    
    //TODO: If they enter a numerical value for a string text field or vice versa, show Error.
    
    func setupElements() {
        errorLabel.alpha = 0
    }
    
    func showError(_ message : String)  {
        errorLabel.text! = message
        errorLabel.alpha = 1
    }

}
