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
    
    let healthKitStore = HKHealthStore()
    private let notificationPublisher = NotificationPublisher()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        requestNotificationPermission(application: application)
        // TODO: Setup with notification selectors in settings page
        notificationPublisher.sendNotfication(title: "Time to exercise!", subtitle: "", body: "Tap to see your routine for today.", badge: 1, delayInterval: 24)
        FirebaseApp.configure()
        authorizeHealthKitApp()
        return true
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
    
    func authorizeHealthKitApp() {
        let HKRead: Set<HKObjectType> = [
            HKObjectType.activitySummaryType(),
        ]
        
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
    
    var calsBurned: Int!
    var date = Date()
    
    func performQuery() {
        // Create the date components for the predicate
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
        
        // Create the predicate for the query
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents, end: endDateComponents)
         
        // Build the query
        let query1 = HKActivitySummaryQuery(predicate: summariesWithinRange) { (query, summaries, error) -> Void in
            guard let activitySummaries = summaries else {
                guard let queryError = error else {
                    fatalError("*** Did not return a valid error object. ***")
                }
                
                // Handle the error here...
                
                return
            }
            
            print(activitySummaries)
            
            
            let context = AppDelegate().persistentContainer.viewContext
            
            let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
            request.returnsObjectsAsFaults = false
            
            // Fetch the "LogDate" object.
            var results: [LogDate]
            do {
                try results = context.fetch(request)
            } catch {
                fatalError("Failure to fetch: \(error)")
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            let entity = NSEntityDescription.entity(forEntityName: "LogDate", in: context)
            
            // Store today's date as dateOfLog attribute in Core Data.
            if results.count == 0 {
                
                // Store today's date as dateOfLog attribute in Core Data.
                let newDate = NSManagedObject(entity: entity!, insertInto: context)
                newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
                newDate.setValue(activitySummaries[6].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
            }
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            if results.count != 0 {
                for i in 0...6 {
                    for num in 0...results.count - 1 {
                        
                        if activitySummaries[i].dateComponents(for: calendar as Calendar).month! < 10 {
                            if results[num].dateOfLog! == "\(0)\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)" {

                                results[num].activeCals = activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                                break
                            }
                        } else {
                            if results[num].dateOfLog! == "\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)" {

                                results[num].activeCals = activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                                break
                            }
                        }
                        
                        if num == results.count - 1 {
                                
                            // Store today's date as dateOfLog attribute in Core Data.
                            let newDate = NSManagedObject(entity: entity!, insertInto: context)
                            
                            if activitySummaries[i].dateComponents(for: calendar as Calendar).month! < 10 {
                                newDate.setValue("\(0)\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)", forKey: "dateOfLog")
                            } else {
                                newDate.setValue("\(activitySummaries[i].dateComponents(for: calendar as Calendar).month ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).day ?? 0)/\(activitySummaries[i].dateComponents(for: calendar as Calendar).year ?? 0)", forKey: "dateOfLog")
                            }
                            newDate.setValue(activitySummaries[i].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
                        }
                    }
                }
            }
            
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            print(results)
            
            var averageActiveCals = (activitySummaries[6].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[5].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[4].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[3].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[2].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[1].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) + activitySummaries[0].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()))/7
            
            //PersonInfo.setCaloriesBurnedLastWeek(cb: averageActiveCals)
            
            var activeCals = activitySummaries[6].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()) // shows the last week, hard-coded day 7 (today)
            //PersonInfo.setCaloriesBurnedYesterday(yb: activeCals)
            
            var totalCals = Int(activeCals.rounded()) //+ Int(restingCals.rounded()) NEED TO GET BMR
            self.calsBurned = Int(totalCals)
            
        }
        
        // Run the query
        healthKitStore.execute(query1)
    }

}

