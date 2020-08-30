//
//  SettingsTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            // Execute Firebase Signout.
            try Auth.auth().signOut()
            // Modally present the Base View Controller through the Initial Navigation Controller.
            let initialViewController = (mainStoryboard.instantiateViewController(withIdentifier: "InitialNavigationController") as? InitialNavigationController)!
            initialViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(initialViewController, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
}
