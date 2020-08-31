//
//  HomeViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    var list = [Information]()
    var resourceList: Array<Array<Resource>> = []
    
    var nutritionList: Array<Array<Resource>> = []
    var longevityList: Array<Array<Resource>> = []
    var meditationList: Array<Array<Resource>> = []
    var supplementList: Array<Array<Resource>> = []
    var dnaList: Array<Array<Resource>> = []
    
    
    
    var showInfo = "ShowInformation"
    var dietSegue = "DietSegue"
    var workoutSegue = "WorkoutSegue"
    
    var infoImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        InformationList.loadInformation()
        list = InformationList.getList()
        
        NutritionResourceList.loadInformation()
        nutritionList = NutritionResourceList.getList()
        
        LongevityResourceList.loadInformation()
        longevityList = LongevityResourceList.getList()
        
        MeditationResourceList.loadInformation()
        meditationList = MeditationResourceList.getList()
        
        SupplementResourceList.loadInformation()
        supplementList = SupplementResourceList.getList()
        
        DNAResourceList.loadInformation()
        dnaList = DNAResourceList.getList()
        
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // Define TableView attributes of Home.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns two total section for the Feed.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns 2 rows for Home.
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determines which type of cell to instantiate depending on the row in Home.
        
        if indexPath.row == 0 {
            // Cell is "HeaderTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(header: "Personalized Suggestions")
            return cell
        } else if indexPath.row == 1 {
            // Cell is "PersonalTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(category: "Diet and Water", info: list[0])

            return cell
        } else if indexPath.row == 2 {
            // Cell is "PersonalTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(category: "Workout", info: list[1])

            return cell
        } else if indexPath.row == 3 {
            // Cell is "HeaderTableViewCell".
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            // Set the attributes of the cell based on the Personal protocol.
            cell.setAttributes(header: "General Information")
            return cell
            
        } else if indexPath.row == 4 {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            cell.layer.cornerRadius = 50
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Nutrition", info: list[2])

            return cell
        } else if indexPath.row == 5 {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Longevity", info: list[3])

            return cell
        } else if indexPath.row == 6 {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Meditation", info: list[4])
            return cell
        } else if indexPath.row == 7 {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Supplements", info: list[5])
            return cell
        } else {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "DNA", info: list[6])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Stylize each header so that they appear only as space between each business section.
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: dietSegue, sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: workoutSegue, sender: nil)
        } else if indexPath.row == 4 {
            resourceList = nutritionList
            performSegue(withIdentifier: showInfo, sender: nil)
        } else if indexPath.row == 5 {
            resourceList = longevityList
            performSegue(withIdentifier: showInfo, sender: nil)
        } else if indexPath.row == 6 {
            resourceList = meditationList
            performSegue(withIdentifier: showInfo, sender: nil)
        } else if indexPath.row == 7 {
            resourceList = supplementList
            performSegue(withIdentifier: showInfo, sender: nil)
        } else if indexPath.row == 8 {
            resourceList = dnaList
            performSegue(withIdentifier: showInfo, sender: nil)
        }
        // Deselect the row so that it does not stay highlighted after segue.
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showInfo {
            let detailVC = segue.destination as? InformationViewController
            detailVC?.linksList = resourceList
        }
    }
}
