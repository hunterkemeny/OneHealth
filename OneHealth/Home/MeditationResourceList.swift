//
//  MeditationResourceList.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class MeditationResourceList {
    
    // MARK: - Properties
    
    
    // Declare list for all businesses.

    static var videoList = [Resource]()
    static var podcastList = [Resource]()
    static var articleList = [Resource]()
    static var appList = [Resource]()
    static var websiteList = [Resource]()
    
    static var list = [videoList, podcastList, articleList, appList, websiteList]
    
    // MARK: - Methods
    
    // TODO: either loadinformation should be an init, or this class should be static
    
    static func loadInformation() {
        /* Create Business object for each business. Create deals, promotions, and rewards for each business. Add each business to the list of the category
           it corresponds to, as well as the list of all businesses.
        */
        
        
                // Videos
                let nutritionVideo1 = Resource(title: "Why Did Peter Discontinue the Ketogenic Diet?", date: "01/18/2020", author: "PeterAttiaMD", icon: UIImage(named: "nutritionVideo1")!)
                let nutritionVideo2 = Resource(title: "An Advantaged Metabolic State: Human Performance, Resilience, & Health", date: "06/10/2013", author: "TheIHMC", icon: UIImage(named: "nutritionVideo2")!)
                let nutritionVideo3 = Resource(title: "Stop Treating Diet As Religion", date: "11/27/2019", author: "ZDoggMD", icon: UIImage(named: "nutritionVideo3")!)
                videoList.append(nutritionVideo1)
                videoList.append(nutritionVideo2)
                videoList.append(nutritionVideo3)
                // Podcasts
                let nutritionPodcast1 = Resource(title: "The Drive", date: "", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionPodcast1")!)
                let nutritionPodcast2 = Resource(title: "The ZDoggMD Show", date: "", author: "Dr. Zubin Damania", icon: UIImage(named: "nutritionPodcast2")!)
                let nutritionPodcast3 = Resource(title: "Found My Fitness", date: "", author: "Dr. Rhonda Patrick", icon: UIImage(named: "nutritionPodcast3")!)
                podcastList.append(nutritionPodcast1)
                podcastList.append(nutritionPodcast2)
                podcastList.append(nutritionPodcast3)
                // Articles -- implement see more after three pop up (model each widget after youtube app picture, title, date, author etc.)
                let nutritionArticle1 = Resource(title: "The red meat and plant-based recommendation wars", date: "03/01/2020", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle1")!)
                let nutritionArticle2 = Resource(title: "Is a low fat diet best for weight loss?", date: "12/18/2012", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle2")!)
                let nutritionArticle3 = Resource(title: "How to make a fat cell less not thin: the lessons of fat flux", date: "08/18/2013", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle3")!)
                articleList.append(nutritionArticle1)
                articleList.append(nutritionArticle2)
                articleList.append(nutritionArticle3)
                // Apps
                let nutritionApp1 = Resource(title: "MyFitnessPal", date: "", author: "Under Armour", icon: UIImage(named: "nutritionApp1")!)
                let nutritionApp2 = Resource(title: "EatThisMuch", date: "", author: "", icon: UIImage(named: "nutritionApp2")!)
                let nutritionApp3 = Resource(title: "Zero", date: "", author: "", icon: UIImage(named: "nutritionApp3")!)
                // my fitness pal
                // eatthismuch
                appList.append(nutritionApp1)
                appList.append(nutritionApp2)
                appList.append(nutritionApp3)
                // Websites
                let nutritionWebsite1 = Resource(title: "https://peterattiamd.com/topics/", date: "", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionWebsite1")!)
                let nutritionWebsite2 = Resource(title: "https://www.foundmyfitness.com/", date: "", author: "Dr. Rhonda Patrick", icon: UIImage(named: "nutritionWebsite2")!)
                let nutritionWebsite3 = Resource(title: "https://www.dietdoctor.com/", date: "", author: "", icon: UIImage(named: "nutritionWebsite3")!)
                
                websiteList.append(nutritionWebsite1)
                websiteList.append(nutritionWebsite2)
                websiteList.append(nutritionWebsite3)
        
        
    }
    
    static func getList() -> Array<Array<Resource>> {
        return self.list
    }
    
    
    static func listCount() -> Int {
        return list.count
    }
    

    
}


