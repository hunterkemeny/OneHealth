//
//  CalendarViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/24/20.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import HealthKit

class CalendarViewController: UIViewController {

    // ERROR1: When you open the app, you have to click on one calendar day before information shows up on any other calendar day.
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    // MARK: - Properties
    
    var docRef: DocumentReference!
    
    var reverseMonths: Array = [String]()
    var reverseYears: Array = [Int]()
    
    let date = Date()
    let calendar = Calendar.current
    var day: String? = ""
    var month: Int? = 0
    var year: Int? = 0
    var completeDate: String? = ""
    var myfitnesspalDate: String? = ""
    var monthCount: Int? = 0
    
    var water: String? = ""
    var todaysCaloriesBurned: String? = ""
    var todaysCaloriesConsumed: String? = ""
    var hoursFasted: String? = ""
    var minutesMeditated: String? = ""
    var caloricSurplus: String? = ""
    var weight: String? = ""
    
    // MARK: - Helper Functions
    
    func getPersistentContainerContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func getLogDateObjectList() -> [LogDate] {
        // Returns the list of all LogDate objects in Core Data, where a Log Date object is an object
        // whose attributes contain information bout a user's weight, calorie consumption, burned calories,
        // etc. for a given date.
        let context = getPersistentContainerContext()
        let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        // Fetch the "LogDate" object.
        var logDateObjectList: [LogDate]
        do {
            try logDateObjectList = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        return logDateObjectList
    }
    
    func getMonth(monthNum: Int) -> String? {
        if monthNum == 0 {
            return "January"
        } else if monthNum == 1 {
            return "February"
        } else if monthNum == 2 {
            return "March"
        } else if monthNum == 3 {
            return "April"
        } else if monthNum == 4 {
            return "May"
        } else if monthNum == 5 {
            return "June"
        } else if monthNum == 6 {
            return "July"
        } else if monthNum == 7 {
            return "August"
        } else if monthNum == 8 {
            return "September"
        } else if monthNum == 9 {
            return "October"
        } else if monthNum == 10 {
            return "November"
        } else {
            return "December"
        }
    }
    
    func getMonthNum(month: String) -> Int? {
        if month == "January" {
            return 0
        } else if month == "February" {
            return 1
        } else if month == "March" {
            return 2
        } else if month == "April" {
            return 3
        } else if month == "May" {
            return 4
        } else if month == "June" {
            return 5
        } else if month == "July" {
            return 6
        } else if month == "August" {
            return 7
        } else if month == "September" {
            return 8
        } else if month == "October" {
            return 9
        } else if month == "November" {
            return 10
        } else {
            return 11
        }
    }
    
    func getNumberOfDaysInMonth(monthNum: Int) -> Int? {
        // Return the number of days in the month plus one to account for the 0th index.
        if monthNum == 0 {
            return 31 + 1
        } else if monthNum == 1 {
            if year! % 4 == 0 {
                return 29
            } else {
                return 28
            }
        } else if monthNum == 2 {
            return 31 + 1
        } else if monthNum == 3 {
            return 30 + 1
        } else if monthNum == 4 {
            return 31 + 1
        } else if monthNum == 5 {
            return 30 + 1
        } else if monthNum == 6 {
            return 31 + 1
        } else if monthNum == 7 {
            return 31 + 1
        } else if monthNum == 8 {
            return 30 + 1
        } else if monthNum == 9 {
            return 31 + 1
        } else if monthNum == 10 {
            return 30 + 1
        } else {
            return 31 + 1
        }
    }
    
    func setTodaysCaloriesConsumed(date: String, logDate: String) {
        // Get the user's calories consumed thus far today.
        todaysCaloriesConsumed = ""
        var email: String?
        
        // Fetch user email from Core Data object "User".
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = getPersistentContainerContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                email = data.value(forKey: "email") as! String
            }
        } catch {
            print("Failed")
        }
        
        // Fetch the number of calories consumed so far in the day from the what the user has logged thus far in myfitnesspal.
        docRef = Firestore.firestore().document("myfitnesspal/\(email! ?? "")")
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            print(myData)
            print(date)
            self.todaysCaloriesConsumed = myData?[date] as? String ?? ""
            
        }
        
        var logDateObjectList = getLogDateObjectList()
        
        for num in 0...logDateObjectList.count - 1 {
            print(num)
            print(logDateObjectList[num])
            print(logDate)
            if logDate == logDateObjectList[num].dateOfLog! {
                print(todaysCaloriesConsumed)
                if todaysCaloriesConsumed! != ""  {
                    print(Double(todaysCaloriesConsumed!))
                    logDateObjectList[num].setValue(Double(todaysCaloriesConsumed!), forKey: "calsIntake")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date) - 1
        
        let logDateObjectList = getLogDateObjectList()
        
        monthCount = PersonInfo.calculateMonthsSinceAppDownload(logDateObjectList: logDateObjectList)
        
        // We want to have a list containing, in reverse order, the "Month Year"s since the user downloaded the app. So we add all of these months to reverseMonths.
        for i in 0...monthCount! - 1 {
            // Account for when there are months from different years.
            if month! - i < 0 {
                month! += 12 * (Int(month!/i) + 1)
            }
            reverseMonths.append(getMonth(monthNum: month! - i)!)
        }
        
        // Then we iterate through reverseMonths and add the year of the month at i to the parallel array reverseYears. If we reach December, then the next 12 months belong to the previous year.
        var decemberCount = 0
        for i in 0...reverseMonths.count - 1 {
            if reverseMonths[i] == "December" && i != 0 {
                decemberCount += 1
            }
            reverseYears.append(year! - decemberCount)
            
        }
    }
}

// MARK: - TableView Methods

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns one total section for the Calendar.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows equals the number of months since the user downloaded the app.
        return monthCount!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set attribute for each row label to be the month and year.
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "MonthTableViewCell", for: indexPath) as! MonthTableViewCell
        cell.setAttributes(month: reverseMonths[indexPath.row] + " " + String(reverseYears[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Assigns dataSourceDelegate for each collection view depending on the cell it is instantiated in.
        if let cell = cell as? MonthTableViewCell {
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        }
    }
}

// MARK: - CollectionView Methods

extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in the corresponding month of the year.
        month = calendar.component(.month, from: date) - 1
        // Account for when there are months from different years.
        if month! - collectionView.tag < 0 {
            month! += 12 * (Int(month!/collectionView.tag) + 1)
        }
        return getNumberOfDaysInMonth(monthNum: month! - collectionView.tag)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fill the label in DayCollectionViewCell with the date of day of the month.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as! DayCollectionViewCell
        // Style the cell so that todays date is colored blue.
        day = String(calendar.component(.day, from: date))
        if collectionView.tag == 0 && indexPath.row == Int(day!) {
            cell.setAttributes(day: indexPath.row, today: true)
            cell.backgroundColor = UIColor.systemBlue
        } else {
            cell.setAttributes(day: indexPath.row, today: false)
        }
        // Stylize the cell.
        cell.layer.cornerRadius = 20
        return cell
    }
    
    // create segue for each day of the each month
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
         When the user taps a day on CalendarViewController, determine the attributes to be set for InfoViewController. If tapped, each cell will utilize the daySegue to instantiate a unique InfoController.
        */
        
        month = calendar.component(.month, from: date) - 1
        // Account for when there are months from different years.
        if month! - collectionView.tag < 0 { // Turn into helper method?
            month! += 12 * (Int(month!/collectionView.tag) + 1)
            
        }
        
        year = calendar.component(.year, from: date)
        if month == 12 && collectionView.tag != 0 {
            year = year! - 1
        }
        
        month = month! - collectionView.tag + 1
        day = String(indexPath.row)
        
        // Format completeDate according to the format of LogDate.dateOfLog.
        if month! < 10 {
            if Int(day!)! < 10 {
                completeDate = "0\(month!)/0\(day!)/\(year!)"
                myfitnesspalDate = "\(year!)-0\(month!)-0\(day!)"
            } else {
                completeDate = "0\(month!)/\(day!)/\(year!)"
                myfitnesspalDate = "\(year!)-0\(month!)-\(day!)"
            }
            
        } else {
            if Int(day!)! < 10 {
                completeDate = "\(month!)/0\(day!)/\(year!)"
                myfitnesspalDate = "\(year!)-\(month!)-0\(day!)"
            } else {
                completeDate = "\(month!)/\(day!)/\(year!)"
                myfitnesspalDate = "\(year!)-\(month!)-\(day!)"
            }

        }
        
        // Use the date format provided by the backend script to get todaysCaloriesConsumed from the myfitnesspal API.
        print("DOING IT")
        print(completeDate)
        setTodaysCaloriesConsumed(date: myfitnesspalDate!, logDate: completeDate!)
        
        let logDateObjectList = getLogDateObjectList()
        
        print(logDateObjectList)
        // It takes 0.4 seconds to get the myfitnesspal data from Firebase, so we have to delay the segue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if logDateObjectList.count != 0 {
                for num in 0...logDateObjectList.count - 1 {
                    // If today is already stored as a LogDate object in CoreData, then update
                    // the values associated with each category with the values associated
                    // with the LogDate Object.
                    print(self.completeDate)
                    print(logDateObjectList[num])
                    if logDateObjectList[num].dateOfLog! == self.completeDate! {
                        self.water = String(Int(logDateObjectList[num].water ?? "Water not logged") ?? 0)
                        self.hoursFasted = String(Int(logDateObjectList[num].fast ?? "Fasting not logged") ?? 0)
                        self.minutesMeditated = String(Int(logDateObjectList[num].meditation ?? "Meditation not logged") ?? 0)
                        
                        if logDateObjectList[num].weight == 0.0 {
                            self.weight = "You need to log your weight!"
                        } else {
                            self.weight = String(Int(logDateObjectList[num].weight))
                        }
                        
                        // ERROR: It will show that the day isnt over yet if they try to log days before they downloaded the app.
                        if logDateObjectList[num].activeCals == 0.0 {
                            self.todaysCaloriesBurned = "The day isn't over yet!"
                        } else {
                            self.todaysCaloriesBurned = String(Int(PersonInfo.calculateBMR()) + Int(logDateObjectList[num].activeCals))
                        }
                        
                        if logDateObjectList[num].calsIntake == 0 {
                            self.todaysCaloriesConsumed = "Need to log"
                        } else {
                            print("YOYOYOYO")
                            print(logDateObjectList[num])
                            self.todaysCaloriesConsumed = String(logDateObjectList[num].calsIntake)
                        }

                        if self.todaysCaloriesConsumed == "Need to log" || self.todaysCaloriesConsumed == "" {
                            self.caloricSurplus = "Log calories"
                        } else {
                            if self.todaysCaloriesBurned == "The day isn't over yet!" {
                                self.caloricSurplus = "Check back tomorrow"
                            } else {
                                self.caloricSurplus = String(Int(Double(self.todaysCaloriesBurned!)! - Double(self.todaysCaloriesConsumed!)!))
                            }
                        }
                        break
                    }
                    // If we have iterated through the entire logDate ObjectList and have not found an object of this particular date, then the user has not logged anything for this date.
                    if num == logDateObjectList.count - 1 {
                        self.water =  "Water not logged"
                        self.todaysCaloriesBurned = "0.0"
                        self.todaysCaloriesConsumed = "Log in MyFitnessPal!"
                        self.hoursFasted = "Fasting not logged"
                        self.minutesMeditated = "Meditation not logged"
                        self.caloricSurplus = "Log MyFitnessPal!"
                        self.weight = "You need to log your weight!"
                    }
                }
            }
            self.performSegue(withIdentifier: "daySegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sets up unique InfoViewController after collectionViewCell is tapped.
        if segue.identifier == "daySegue" {
            let detailVC = segue.destination as! InfoViewController
            detailVC.dayMonthYear = completeDate
            detailVC.water = water
            detailVC.calsBurned = String(todaysCaloriesBurned!)
            detailVC.calsConsumed = todaysCaloriesConsumed
            detailVC.hoursFasted = hoursFasted
            detailVC.minutesMeditated = minutesMeditated
            detailVC.caloricSurplus = caloricSurplus
            detailVC.weight = weight
        }
    }
}

