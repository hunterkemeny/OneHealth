//
//  AppDelegate.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    let healthKitStore = HKHealthStore()
    private let notificationPublisher = NotificationPublisher()
    var calsBurned: Int!
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // Setup PersonInfo object whenever app is opened.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let firstRequest: NSFetchRequest<User> = User.fetchRequest()
        firstRequest.returnsObjectsAsFaults = false
        // Fetch the "User" object.
        var results: [User]
        do {
            try results = context.fetch(firstRequest)
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
        year = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        
        if month! < 10 {
            if day! < 10 {
                myfitnesspalDate = "\(year!)-0\(month!)-0\(day!)"
                logDateDate = "0\(month)/0\(day)/\(year)"
            } else {
                myfitnesspalDate = "\(year!)-0\(month!)-\(day!)"
            }
        } else {
            if day! < 10 {
                myfitnesspalDate = "\(year!)-\(month!)-0\(day!)"
                logDateDate = "\(month)/0\(day)/\(year)"
            } else {
                myfitnesspalDate = "\(year!)-\(month!)-\(day!)"
                logDateDate = "\(month)/\(day)/\(year)"
            }
            
        }
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Check if todaysCaloriesConsumed have been logged using LogViewController. If it has not, then check Firebase to see if they have logged using myfitnesspal.
        var todaysCaloriesConsumed = ""
        for i in 0...logDateObjectList.count - 1{
            if logDateObjectList[i].dateOfLog == logDateDate {
                if logDateObjectList[i].calsIntake != 0.0 {
                    todaysCaloriesConsumed = String(logDateObjectList[i].calsIntake)
                }
            }
            if i == logDateObjectList.count - 1 {
                let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
                let newDate = NSManagedObject(entity: entity!, insertInto: context)
                newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
            }
        }
        if todaysCaloriesConsumed == "" {
            docRef = Firestore.firestore().document("myfitnesspal/\(results[0].email! ?? "")")
            docRef.getDocument { (docSnapshot, error) in
                guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
                let myData = docSnapshot.data()
                todaysCaloriesConsumed = myData?[self.myfitnesspalDate!] as? String ?? ""
            }
        }
        
        var sex = 1
        
        if results[0].sex == "Male" {
            var sex = 1
        } else {
            var sex = 0
        }
        
        // It takes 0.4 seconds to get the myfitnesspal data from Firebase, so we have to delay the makePerson.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            todaysCaloriesConsumed = "2100"
            PersonInfo.makePerson(weight: Double(results[0].weight!)!, height: results[0].height!, sex: sex, age: results[0].age!, gainLoseMaintain: results[0].goalType!, weightChangeGoal: results[0].weightGoal!, weeksToComplete: Int(results[0].weeksToComplete!)!, daysToComplete: Int(results[0].weeksToComplete!)!*7, todaysCaloriesConsumed: Double(todaysCaloriesConsumed)!)
        }
        
        
        // Setup notifications.
        
        requestNotificationPermission(application: application)
        
        notificationPublisher.sendNotification(identifier: "Exercise", title: "Time to exercise!", subtitle: "", body: "Tap to see your routine for today.", badge: 1, delayInterval: 24, hour: 19)
        
        notificationPublisher.sendNotification(identifier: "Diet", title: "Daily Diet Digest", subtitle: "", body: "Tap to see your diet for today.", badge: 1, delayInterval: 24, hour: 8)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish First Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 10)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish Second Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 14)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish Third Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 20)
        
        notificationPublisher.sendNotification(identifier: "Weight", title: "Check Your Weight!", subtitle: "", body: "Tap to log your weight.", badge: 1, delayInterval: 168, hour: 9)
        
        authorizeHealthKitApp()
        return true
    }
    
    // MARK: - Helper Functions
    
    func authorizeHealthKitApp() {
        let HKRead: Set<HKObjectType> = [HKObjectType.activitySummaryType(),]
        
        let HKWrite: Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable() {
            print("Error occured!")
            return
        }
                
        healthKitStore.requestAuthorization(toShare: HKWrite, read: HKRead) { (sucess, error) in
            print("Read/write authorization successful")
            print("Attempting query...")
            self.performQuery()
        }
    }
    

    func performQuery() {
        // Get the last 7 days of active calories burned data from the Apple Watch by querying the HealthKit Activity API.
        
        // Create the date components for the predicate in order to query from HKActivity.
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) else {
            fatalError("*** This should never fail. ***")
        }
        let endDate = NSDate()
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate as Date, options: []) else {
            fatalError("*** unable to calculate the start date ***")
        }
        let units: NSCalendar.Unit = [.day, .month, .year, .era]
        var startDateComponents = calendar.components(units, from: startDate)
        startDateComponents.calendar = calendar as Calendar
        var endDateComponents = calendar.components(units, from: endDate as Date)
        endDateComponents.calendar = calendar as Calendar
        
        // Create the predicate for the HKQuery.
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents, end: endDateComponents)
         
        // Build the HKActivity summary query.
        let query1 = HKActivitySummaryQuery(predicate: summariesWithinRange) { (query, summaries, error) -> Void in
            guard let activitySummaries = summaries else {
                guard let queryError = error else {
                    fatalError("*** Did not return a valid error object. ***")
                }
                // Handle the error here...
                return
            }
            
            // Fetch the list of "LogDate" objects.
            let context = AppDelegate().persistentContainer.viewContext
            let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
            let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
            request.returnsObjectsAsFaults = false
            var logDateObjectList: [LogDate]
            do {
                try logDateObjectList = context.fetch(request)
            } catch {
                fatalError("Failure to fetch: \(error)")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            // If the user is opening the app for the first time, create a LogDate object and store today's date as dateOfLog attribute in the LogDate object for today in Core Data.
            if logDateObjectList.count == 0 {
                let newDate = NSManagedObject(entity: entity!, insertInto: context)
                newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
                // Store the activity summary for today in the newly created LogDate object associated with today.
                newDate.setValue(activitySummaries[6].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
            }
            // Save the newly created LogDate object to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            if logDateObjectList.count != 0 {
                // For each item in the activity summary...
                for i in 0...6 {
                    for num in 0...logDateObjectList.count - 1 {
                        if activitySummaries[i].dateComponents(for: calendar as Calendar).month! < 10 { // Have to perform this check based on the format of the date, where 0s are placed before single digit months.
                            
                            // If the day associated with a particular LogDate object in Core Data has the same date as one of the days queried from HKActivitySummary, then update the activeCals associated with this specific LogDate object based on activitySummary from HKActivitySummary.
                            if logDateObjectList[num].dateOfLog! == "\(0)\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)" {
                                
                                logDateObjectList[num].activeCals = activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                                break
                            }
                        } else {
                            if logDateObjectList[num].dateOfLog! == "\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)" {

                                logDateObjectList[num].activeCals = activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                                break
                            }
                        }
                        
                        if num == logDateObjectList.count - 1 {
                            // When we reach the last object in logDateObjectList, this means that the date chosen is not a valid option in logDateObjectList. Therefore, store today's date as a new LogDate object in Core Data.
                            
                            let newDate = NSManagedObject(entity: entity!, insertInto: context)
                            
                            if activitySummaries[i].dateComponents(for: calendar as Calendar).month! < 10 { // Have to perform this check based on the format of the date, where 0s are placed before single digit months.
                                
                                newDate.setValue("\(0)\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)", forKey: "dateOfLog")
                            } else {
                                newDate.setValue("\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)", forKey: "dateOfLog")
                            }
                            // Store the value associated with this particular days activeCals in the new LogDate object created for today's date.
                            newDate.setValue(activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
                        }
                    }
                }
            }
            
            // Save to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        
        // Run the query.
        healthKitStore.execute(query1)
    }
    
    
    // MARK: - Notification Stack
    
    func requestNotificationPermission(application: UIApplication) {
        // Request permission to send local notifications.
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        // Ask the user for permission to send notifications.
        center.requestAuthorization(options: options) { (granted, err) in
            if granted {
                print("You can change notification settings in the settings page")
            } else {
                print("We recommend that you have notifications on. If you would like to change your notification settings, you can do so from the settings page.")
            }
        }
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OneHealth")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

