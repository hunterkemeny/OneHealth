//
//  HomeViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/23/20.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - Properties
    
    var date = Date()
    let dateFormatter = DateFormatter()
    var docRef: DocumentReference!
    let calendar = Calendar.current
    var day: Int? = 0
    var month: Int? = 0
    var year: Int? = 0
    var completeDate: String? = ""
    var myfitnesspalDate: String? = ""
    var logDateDate: String? = ""
    
    var list = [Information]()
    var resourceList: Array<Array<Resource>> = []
    var nutritionList: Array<Array<Resource>> = []
    var meditationList: Array<Array<Resource>> = []
    var showInfo = "ShowInformation"
    var dietSegue = "DietSegue"
    var workoutSegue = "WorkoutSegue"
    var infoImage: UIImage!
    
    // var longevityList: Array<Array<Resource>> = []
    // var supplementList: Array<Array<Resource>> = []
    // var dnaList: Array<Array<Resource>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup PersonInfo.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let firstRequest: NSFetchRequest<User> = User.fetchRequest()
        firstRequest.returnsObjectsAsFaults = false
        // Fetch the "User" object.
        var user: [User]
        do {
            try user = context.fetch(firstRequest)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        let secondRequest: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        secondRequest.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var logDateObjectList: [LogDate]
        do {
            try logDateObjectList = context.fetch(secondRequest)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
     
        // Get the different date formats for the LogDate object and for Firebase.
            
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        day = calendar.component(.day, from: date)
            
        if month! < 10 {
            if day! < 10 {
                myfitnesspalDate = "\(year!)-0\(month!)-0\(day!)"
                logDateDate = "0\(month!)/0\(day!)/\(year!)"
            } else {
                myfitnesspalDate = "\(year!)-0\(month!)-\(day!)"
                logDateDate = "0\(month!)/\(day!)/\(year!)"
            }
        } else {
            if day! < 10 {
                myfitnesspalDate = "\(year!)-\(month!)-0\(day!)"
                logDateDate = "\(month!)/0\(day!)/\(year!)"
            } else {
                myfitnesspalDate = "\(year!)-\(month!)-\(day!)"
                logDateDate = "\(month!)/\(day!)/\(year!)"
            }
                
        }
        dateFormatter.dateFormat = "MM/dd/yyyy"
            
        // Check if todaysCaloriesConsumed have been logged using LogViewController. If it has not, then check Firebase to see if they have logged using myfitnesspal.
        var todaysCaloriesConsumed = ""
        for i in 0...logDateObjectList.count - 1 {
            if logDateObjectList[i].dateOfLog == logDateDate {
                if logDateObjectList[i].calsIntake != 0.0 {
                    todaysCaloriesConsumed = String(logDateObjectList[i].calsIntake)
                }
                break
            }
            if i == logDateObjectList.count - 1 {
                let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                let newDate = NSManagedObject(entity: entity!, insertInto: context)
                newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
            }
        }
        if todaysCaloriesConsumed == "" {
            docRef = Firestore.firestore().document("myfitnesspal/\(user[0].email! ?? "")")
            docRef.getDocument { (docSnapshot, error) in
                guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
                let myData = docSnapshot.data()
                todaysCaloriesConsumed = myData?[self.myfitnesspalDate!] as? String ?? ""
            }
        }
            
        var sex = 1
            
        if user[0].sex == "Male" {
            var sex = 1
        } else {
            var sex = 0
        }
            
        // It takes 0.4 seconds to get the myfitnesspal data from Firebase, so we have to delay the makePerson.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            PersonInfo.makePerson(weight: Double(user[0].weight!)!, height: user[0].height!, sex: sex, age: user[0].age!, gainLoseMaintain: user[0].goalType!, weightChangeGoal: user[0].weightGoal!, weeksToComplete: Int(user[0].weeksToComplete!)!, daysToComplete: Int(user[0].weeksToComplete!)!*7, todaysCaloriesConsumed: Double(todaysCaloriesConsumed) ?? 0.0)
            }

        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        InformationList.loadInformation()
        list = InformationList.getList()
        
        NutritionResourceList.loadInformation()
        nutritionList = NutritionResourceList.getList()
        
        /*
        LongevityResourceList.loadInformation()
        longevityList = LongevityResourceList.getList()
        
        MeditationResourceList.loadInformation()
        meditationList = MeditationResourceList.getList()
        
        SupplementResourceList.loadInformation()
        supplementList = SupplementResourceList.getList()
        
        DNAResourceList.loadInformation()
        dnaList = DNAResourceList.getList()
        
         */
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    // Define TableView attributes of Home.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns one total section for the Feed.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns 7 rows for Home.
        return 5
    }
    
    // TODO: Add sections dedicated to longevity, supplementation, meditation, and DNA testing.
    
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
        } else {
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "GeneralTableViewCell", for: indexPath) as! GeneralTableViewCell
            cell.layer.cornerRadius = 50
            // Set the attributes of the cell based on the General protocol.
            cell.setAttributes(category: "Nutrition", info: list[2])
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
            // Set the resourceList based on the item tapped.
            resourceList = nutritionList
            performSegue(withIdentifier: showInfo, sender: nil)
        } else {
            // Set the resourceList based on the item tapped.
            resourceList = meditationList
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
