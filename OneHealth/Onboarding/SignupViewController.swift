//
//  SignupViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func signupTapped(_ sender: Any) {
        // Create user with Firebase using textField inputs.
            
        // Create reference to storyboard.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
        // Check that textFields are filled in and contain usable, correctly formatted data.
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            // Create cleaned versions of the data.
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
            // Create reference to Core Data "Email" Entity.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            
            // Create a new Email entity in Core Data.
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(email, forKey: "email")
            newUser.setValue(firstName, forKey: "firstName")
            newUser.setValue(lastName, forKey: "lastName")
        
            // Save new Email to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // Save firstNameTextField to UserDefaults in order to change the initial ViewController condition in AppDelegate.
            UserDefaults.standard.set(emailTextField.text, forKey: "email")
            
            // Create the user in Firebase.
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // Check for errors.
                if err != nil {
                    // There was an error.
                    print(err!)
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, now store the first name and last name in the Firestore DB.
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["email": email, "password": password, "firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            // Show error message.
                            self.showError("Try again at a later time.")
                        }
                        print("New user stored in database")
    
                        // If the new user was successfully stored in the DB, move on to the app tutorial.
                        let tutorialViewController = (mainStoryboard.instantiateViewController(withIdentifier: "TutorialViewController") as? TutorialViewController)!
                        self.navigationController?.pushViewController(tutorialViewController, animated: true)
                    }
                }
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    //MARK: - Text Field Validation
    
    func setupElements() {
        // Hide the error label.
        
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        // Check all fields and validate that the input data is correct. If correct, method returns nil. Otherwise, it returns an error message as a String.
        
        // Check that all fields are filled in.
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure. If password is not secure enough, return error message.
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if SignupViewController.isPasswordValid(cleanedPassword) == false {
            // Pasword is not secure enough.
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    func showError(_ message : String) {
        // If called, makes error message visible.
        
        errorLabel.text! = message
        errorLabel.alpha = 1
    }

    static func isPasswordValid(_ password : String) -> Bool {
        // Determines if password meets basic standards using Regular Expressions.
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
