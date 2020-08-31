//
//  LoginViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction func loginTapped(_ sender: Any) {
        // Login existing user stored in Firestore DB.
        
        // Create reference to storyboard.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Check that textFields are filled in and contain usable, correctly formatted data.
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            // Create cleaned versions of the data.
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create reference to Core Data "Email" Entity.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            
            // Store entered email address as email attribute in Core Data.
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(email, forKey: "email")
            
            // Save new user to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // Save emailTextField to UserDefaults in order to change the initial ViewController condition in AppDelegate.
            UserDefaults.standard.set(emailTextField.text, forKey: "email")
            
            // Signin user.
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                // Check for errors.
                if err != nil {
                    // Couldn't sign in.
                    print(err!)
                    self.showError(err!.localizedDescription)
                } else {
                    print("Logged in successfully")
                    // User was signed in successfully. Now move on to the app tutorial.
                    let tabViewController = (mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController)!
                    tabViewController.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(tabViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Enable functionality for return key.
        
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
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure. If password is not secure enough, return error message.
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if LoginViewController.isPasswordValid(cleanedPassword) == false {
            // Pasword is not secure enough.
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    func showError(_ message : String)  {
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
