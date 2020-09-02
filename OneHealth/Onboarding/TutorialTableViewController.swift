//
//  TutorialTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 9/1/20.
//

import UIKit

class TutorialTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        // Inititalize reference to storyboard.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Segue to main Tab View Controller.
        let homeViewController = (mainStoryboard.instantiateViewController(withIdentifier: "TabViewController") as? TabViewController)!
        homeViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(homeViewController, animated: true, completion: nil)
    }
    
}
