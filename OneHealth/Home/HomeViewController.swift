//
//  HomeViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // Define TableView attributes of Home.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns two total section for the Feed.
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns 2 rows for Home.
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determines which type of cell to instantiate depending on the row in Home.
        
        if indexPath.section == 0 {
            // Cell is "HeaderTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(header: "Personalized Suggestions")
            return cell
        } else if indexPath.section == 1 {
            // Cell is "PersonalTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(category: "Diet")
            return cell
        } else if indexPath.section == 2 {
            // Cell is "HeaderTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(header: "General Information")
            return cell
        } else {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Information")
            return cell
        }
    }
}
