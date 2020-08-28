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

    // TODO: Line up days with weeks
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    var docRef: DocumentReference!
    
    var months = ["January 2019", "February 2019", "March 2019", "April 2019", "May 2019", "June 2019", "July 2019", "August 2019", "September 2019", "October 2019", "November 2019", "December 2019"]
    var monthsSinceJan2020 = 8 // implement calculation for this
    var reverseMonths = [String]()
    var check = 0
    let date = Date()
    let calendar = Calendar.current
    var day = ""
    var month = ""
    var year = ""
    var completeDate = ""
    var water = ""
    var activeCalsBurned = ""
    var calsConsumed = ""
    var hoursFasted = ""
    var minutesMeditated = ""
    var caloricSurplus = ""
    var weight = ""
    var chosenDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        
        if day == 1 && check == 0 {
            monthsSinceJan2020 += 1
            check += 1
        }
        
        if day != 1 && check != 0 {
            check = 0
        }
        
        for i in 1...monthsSinceJan2020 {
            if i % 12 == 1 {
                months.append("January \(year)")
            } else if i % 12 == 2 {
                months.append("February \(year)")
            } else if i % 12 == 3 {
                months.append("March \(year)")
            } else if i % 12 == 4 {
                months.append("April \(year)")
            } else if i % 12 == 5 {
                months.append("May \(year)")
            } else if i % 12 == 6 {
                months.append("June \(year)")
            } else if i % 12 == 7 {
                months.append("July \(year)")
            } else if i % 12 == 8 {
                months.append("August \(year)")
            } else if i % 12 == 9 {
                months.append("September \(year)")
            } else if i % 12 == 10 {
                months.append("October \(year)")
            } else if i % 12 == 11 {
                months.append("November \(year)")
            } else if i % 12 == 0 {
                months.append("December \(year)")
            }
        }
        
        var monthCount = months.count
        for i in 0...months.count {
            reverseMonths.append(months[monthCount - 1])
            if monthCount == 1 {
                break
            } else {
                monthCount -= 1
            }
        }
    }

}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns one total section for the Calender.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of months since january 2019
        return 12 + monthsSinceJan2020
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set attribute for each row label to be the month of the year
        let cell = calendarTableView.dequeueReusableCell(withIdentifier: "MonthTableViewCell", for: indexPath) as! MonthTableViewCell
        cell.setAttributes(month: reverseMonths[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Assigns dataSourceDelegate for each collection view depending on the cell it is instantiated in.
        
        if let cell = cell as? MonthTableViewCell {
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        }
    }
    
    
}



extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of days in the corresponding  month of the year
        
        let year = calendar.component(.year, from: date)
        
        // make day assignment dependent on the number of months in months array
        if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 1 {
            if year % 4 == 0 {
                return 30
            } else {
                return 29
            }
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 2 {
            return 32
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 3 {
            return 31
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 4 {
            return 32
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 5 {
            return 31
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 6 {
            return 32
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 7 {
            return 32
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 8 {
            return 31
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 9 {
            return 32
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 10 {
            return 31
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 11 {
            return 32
        } else {
            return 32
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // set attribute for the day of the month
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as! DayCollectionViewCell
        cell.setAttributes(day: indexPath.row)
        return cell
    }
    
    // create segue for each day of the each month
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
         Associates corresponding business image attributes with every collectionViewCell based on the tableView row where it resides.
         If tapped, each cell will utilize the showBusiness segue to instantiate a unique BusinessTableViewController.
        */
        
        // make day assignment dependent on the number of months in months array
        if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 1 {
            month = "02"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 2 {
            month = "03"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 3 {
            month = "04"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 4 {
            month = "05"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 5 {
            month = "06"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 6 {
            month = "07"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 7 {
            month = "08"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 8 {
            month = "09"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 9 {
            month = "10"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 10 {
            month = "11"
        } else if ((reverseMonths.count - 1) - collectionView.tag) % 12 == 11 {
            month = "12"
        } else {
            month = "01"
        }
        
        day = String(indexPath.row)
        
        if 12 - collectionView.tag >= 12 {
            year = "2020"
        } else {
            year = "2019"
        }
        
        completeDate = "\(month)/\(day)/\(year)"
        
        chosenDate = "\(year)-\(month)-\(day)"
        getActiveCals(date: chosenDate)
        print("Hello")
        print(getActiveCals(date: chosenDate))
        print("HI")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Check todays logs
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
            request.returnsObjectsAsFaults = false
            
            // Fetch the "LogDate" object.
            var results: [LogDate]
            do {
                try results = context.fetch(request)
            } catch {
                fatalError("Failure to fetch: \(error)")
            }
            
            if results.count != 0 {
                for num in 0...results.count - 1 {
                    print(results[num].dateOfLog!)
                    
                    
                    if results[num].dateOfLog! == self.completeDate {
                        // today is stored in core data
                        // If they open up the logviewcontroller for the first time, then they log something, when they press back
                        // viewcontroller needs to update to show that they logged something
                        self.water = results[num].water ?? "water not logged"
                        print(results[num])
                        if results[num].activeCals == 0.0 {
                            self.activeCalsBurned = "The day isn't over yet!"
                        } else {
                            self.activeCalsBurned = String(results[num].activeCals)
                        }
                        
                        if PersonInfo.getYesterdaysCalories() == "" {
                            self.calsConsumed = "MyFitnessPal not logged"
                        } else {
                            self.calsConsumed = PersonInfo.getYesterdaysCalories()
                        }
                        print("sheit")
                        print(self.calsConsumed)
                        print("boi")
                        self.hoursFasted = results[num].fast ?? "Fasting not logged"
                        self.minutesMeditated = results[num].meditation ?? "Meditation not logged"
                        if results[num].weight == 0.0 {
                            self.weight = "You need to log your weight!"
                        } else {
                            self.weight = String(results[num].weight)
                        }
                        
                        
                        if self.calsConsumed == "MyFitnessPal not logged" || self.calsConsumed == "0.0" || self.calsConsumed == ""{
                            self.caloricSurplus = "Need MyFitnessPal data to calculate caloric surplus"
                        } else {
                            if self.activeCalsBurned == "The day isn't over yet!" {
                                self.caloricSurplus = "Check back tomorrow when to see the today's surplus value."
                            } else {
                                self.caloricSurplus = String(Double(self.activeCalsBurned)! - Double(self.calsConsumed)!)//switch this to total cals burned
                            }
                            
                        }
                        
                        
                        
                        break
                    }
                    if num == results.count - 1 {
                        self.water =  "Water not logged"
                        self.activeCalsBurned = "0.0"
                        self.calsConsumed = "MyFitnessPal not logged"
                        self.hoursFasted = "Fasting not logged"
                        self.minutesMeditated = "Meditation not logged"
                        self.caloricSurplus = "Need MyFitnessPal data to calculate caloric surplus"
                        self.weight = "You need to log your weight!"
                    }
                }
            }
            
            self.performSegue(withIdentifier: "DaySegue", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Sets up unique BusinessTableViewController after collectionViewCell is tapped.
        
        if segue.identifier == "DaySegue" {
            let detailVC = segue.destination as! InfoViewController
            detailVC.dayMonthYear = completeDate
            detailVC.water = water
            detailVC.calsBurned = String(activeCalsBurned)
            detailVC.calsConsumed = calsConsumed
            detailVC.hoursFasted = hoursFasted
            detailVC.minutesMeditated = minutesMeditated
            detailVC.caloricSurplus = caloricSurplus
            detailVC.weight = weight
        }
    }
    
    func getActiveCals(date: String) -> String { // Need to make get selected cals, not get todays cals
        var email: String?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var yesterdaysCalories: String? = ""
        var desiredDate = ""
        
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = formatter.string(from: Date())
        print(todaysDate)
 */
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                email = data.value(forKey: "email") as! String
          }
        } catch {
            print("Failed")
        }
        print("YOYOY")
        docRef = Firestore.firestore().document("myfitnesspal/\(email! ?? "")")
        docRef.getDocument { (docSnapshot, error) in
            print("AYY")
            print(date)
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            let yesterdaysCalories = myData?[date] as? String ?? ""
            print(yesterdaysCalories)
            PersonInfo.setYesterdaysCalories(yc: yesterdaysCalories)
            //self.setLabels()
        }
        return yesterdaysCalories!
    }
}

