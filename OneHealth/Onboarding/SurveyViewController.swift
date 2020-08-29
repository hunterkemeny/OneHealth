//
//  SurveyViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore



class SurveyViewController: UIViewController, UITextFieldDelegate {
    //TODO: keyboard blocks textfield: codewithchris video
    // MARK: - Properties
    
    var db: Firestore!
    let userID: String? = Auth.auth().currentUser?.uid
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sexSwitch: UISegmentedControl!
    @IBOutlet weak var currentWeightTextField: UITextField!
    @IBOutlet weak var weightSwitch: UISegmentedControl!
    @IBOutlet weak var weightGoalTextField: UITextField!
    @IBOutlet weak var weekSlider: UISlider!
    @IBOutlet weak var mealSlider: UISlider!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    

    override func viewDidLoad() {
        // Setup ViewController.
        
        super.viewDidLoad()
        setupElements()
        db = Firestore.firestore()
        
        currentWeightTextField.delegate = self
        weightGoalTextField.delegate = self
        ageTextField.delegate = self
        heightTextField.delegate = self
    }
    
    @IBAction func completeSurvey(_ sender: Any) {
        
        // Inititalize reference to storyboard.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Validates text fields.
        if ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || currentWeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || weightGoalTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || heightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showError("Please fill in all fields")
            return
        }
        
        // Store text field input values.
        let height = heightTextField.text!
        let age: String? = ageTextField.text!
        let weight: String? = currentWeightTextField.text!
        let weightChangeGoal: String? = weightGoalTextField.text!
        
        // Store values for segmented controls.
        var userSex: String = ""
        var goalType: String = ""
        
        if sexSwitch.selectedSegmentIndex == 0 {
            userSex = "Male"
        } else {
            userSex = "Female"
        }
        
        if weightSwitch.selectedSegmentIndex == 0 {
            goalType = "gain"
        } else if weightSwitch.selectedSegmentIndex == 1 {
            goalType = "lose"
        } else {
            goalType = "maintain"
        }
        
        // Store values for sliders.
        let time: Float = weekSlider.value
        let meals: Float = mealSlider.value
        
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
        
        results[0].setValue(age, forKey: "age")
        results[0].setValue(userSex, forKey: "sex")
        results[0].setValue(goalType, forKey: "goalType")
        results[0].setValue(String(Int(time*7)), forKey: "weeksToComplete")
        results[0].setValue(height, forKey: "height")
        results[0].setValue(weight, forKey: "weight")
        results[0].setValue(weightChangeGoal, forKey: "weightGoal")
        results[0].setValue(String(Int(meals)), forKey: "meals")
        
        // Save new user to Core Data.
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // Store values in Firestore DB.
        db.collection("surveyInfo").document(userID!).setData(["age": age!, "sex": userSex, "weight": weight!, "height": height, "goal-type": goalType, "weight-change-goal": weightChangeGoal!, "time-to-complete": time, "num-meals": meals]) { err in
            
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                // Segue to main Tab View Controller.
                let homeViewController = (mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController)!
                homeViewController.modalPresentationStyle = .fullScreen
                
                self.navigationController?.present(homeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        
        currentWeightTextField.resignFirstResponder()
        weightGoalTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        heightTextField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helper Methods
    
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
