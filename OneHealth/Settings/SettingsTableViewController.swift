//
//  SettingsTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            //let baseViewController = (mainStoryboard.instantiateViewController(withIdentifier: "BaseViewController") as? BaseViewController)!
            //baseViewController.modalPresentationStyle = .fullScreen
            let initialViewController = (mainStoryboard.instantiateViewController(withIdentifier: "InitialNavigationController") as? InitialNavigationController)!
            initialViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(initialViewController, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
}
