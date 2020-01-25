//
//  LogViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet weak var logTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var categories = ["Water", "Meditation", "Workout", "Fasting", "Meals"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logTableView.delegate = self
        logTableView.dataSource = self
    }
    

   
}


extension LogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = logTableView.dequeueReusableCell(withIdentifier: "LogTableViewCell", for: indexPath) as! LogTableViewCell
        // Set the attributes of the cell based on the Places To Eat protocol.
        cell.setAttributes(category: categories[indexPath.row])
        return cell
    }
    
    
}
