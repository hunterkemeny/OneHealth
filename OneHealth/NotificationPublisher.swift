//
//  NotificationPublisher.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/26/20.
//

import UIKit
import UserNotifications

class NotificationPublisher: NSObject {
    
    func sendNotfication(title: String, subtitle: String, body: String, badge: Int?, delayInterval: Int?) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var delayTimeTrigger: UNCalendarNotificationTrigger?
        

        
        if delayInterval != nil {
            delayTimeTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.init(hour: 9), repeats: true)
        }
        
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: "Exercise Daily", content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
}

extension NotificationPublisher: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        completionHandler([.badge, .sound, .alert])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("The notification was dismissed.")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification.")
            completionHandler()
        default:
            print("The default case was called")
            completionHandler()
        }
    }
}
