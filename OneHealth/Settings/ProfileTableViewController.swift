//
//  ProfileTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit
import CoreData

class ProfileTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var gainLoseMaintainLabel: UILabel!
    @IBOutlet weak var currentWeightLabel: UILabel!
    @IBOutlet weak var weightGoalLabel: UILabel!
    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Access Core Data and create a reference to the "User" object.
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "User" object.
        var results: [User]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        // Fill all labels with User information.
        nameLabel.text = results[0].firstName
        emailLabel.text = results[0].email
        ageLabel.text = results[0].age
        sexLabel.text = results[0].sex
        heightLabel.text = results[0].height
        gainLoseMaintainLabel.text = results[0].goalType
        currentWeightLabel.text = results[0].weight
        weightGoalLabel.text = results[0].weightGoal
        weeksLabel.text = results[0].weeksToComplete
        mealsLabel.text = results[0].meals
    }
    

}
