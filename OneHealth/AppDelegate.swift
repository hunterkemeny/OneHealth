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
        
        // Setup notifications.
        
        requestNotificationPermission(application: application)
        
        notificationPublisher.sendNotification(identifier: "Exercise", title: "Time to exercise!", subtitle: "", body: "Tap to see your routine for today.", badge: 1, delayInterval: 24, hour: 19)
        
        notificationPublisher.sendNotification(identifier: "Diet", title: "Daily Diet Digest", subtitle: "", body: "Tap to see your diet for today.", badge: 1, delayInterval: 24, hour: 8)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish First Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 10)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish Second Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 14)
        
        notificationPublisher.sendNotification(identifier: "Water 1", title: "Finish Third Bottle of Water.", subtitle: "Remember to drink at least 3 bottles of water a day!", body: "Tap to log the water you have drank so far.", badge: 1, delayInterval: 24, hour: 20)
        
        notificationPublisher.sendNotification(identifier: "Weight", title: "Check Your Weight!", subtitle: "", body: "Tap to log your weight.", badge: 1, delayInterval: 24, hour: 9)
        
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
        // Get todays active calories burned data from the Apple Watch by querying the HealthKit Activity API.
        
        // Create the date components for the predicate in order to query from HKActivity.
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) else {
            fatalError("*** This should never fail. ***")
        }
        let endDate = NSDate()
        let startDate = NSDate()
        
        let units: NSCalendar.Unit = [.day, .month, .year, .era]
        
        var startDateComponents = calendar.components(units, from: startDate as Date) // Change to just getting todays
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
                newDate.setValue(activitySummaries[0].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
            }
            
            // Save the newly created LogDate object to Core Data.
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // Fetch the new logDateObjectList with the newly created LogDate object.
            do {
                try logDateObjectList = context.fetch(request)
            } catch {
                fatalError("Failure to fetch: \(error)")
            }
            
            // Format activeCalsDate according to the date format of the LogDate objects. activeCalsDate corresponds to the date from the activitySummary, which is today's date.
            var activeCalsDate = ""
            self.month = calendar.component(.month, from: self.date)
            self.year = calendar.component(.year, from: self.date)
            self.day = calendar.component(.day, from: self.date)
            if self.month! < 10 {
                if self.day! < 10 {
                    activeCalsDate = "0\(self.month!)/0\(self.day!)/\(self.year!)"
                } else {
                    activeCalsDate = "0\(self.month!)/\(self.day!)/\(self.year!)"
                }
            } else {
                if self.day! < 10 {
                    activeCalsDate = "\(self.month!)/0\(self.day!)/\(self.year!)"
                } else {
                    
                    activeCalsDate = "\(self.month!)/\(self.day!)/\(self.year!)"
                }
            }
            
            // If there is already a logDateObject for today's date, then when the user opens the app, update the activeCals attribute according to how many calories they have burned so far today.
            for num in 0...logDateObjectList.count - 1 {
                if logDateObjectList[num].dateOfLog! == activeCalsDate {
                    logDateObjectList[num].activeCals = activitySummaries[0].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                    break
                }
                if num == logDateObjectList.count - 1 {
                    // When we reach the last object in logDateObjectList, this means that the date chosen is not a valid option in logDateObjectList. Therefore, store today's date as a new LogDate object in Core Data.
                    let newDate = NSManagedObject(entity: entity!, insertInto: context)
                    newDate.setValue(dateFormatter.string(from: Date()), forKey: "dateOfLog")
                    newDate.setValue(activitySummaries[0].activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie()), forKey: "activeCals")
                }
            }
            
            // Save the newly created/modified LogDate object to Core Data.
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

