//
//  ResourceList.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class NutritionResourceList {
    
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
        let nutritionVideo1 = Resource(title: "Why Did Peter Discontinue the Ketogenic Diet?", date: "01/18/2020", author: "PeterAttiaMD", icon: UIImage(named: "nutritionPodcast1")!, link: "https://www.youtube.com/watch?v=-GwSfIUvCJ0")
        let nutritionVideo2 = Resource(title: "An Advantaged Metabolic State: Human Performance, Resilience, & Health", date: "06/10/2013", author: "TheIHMC", icon: UIImage(named: "nutritionVideo2")!, link: "https://www.youtube.com/watch?v=NqwvcrA7oe8")
        let nutritionVideo3 = Resource(title: "Stop Treating Diet As Religion", date: "11/27/2019", author: "ZDoggMD", icon: UIImage(named: "nutritionVideo3")!, link: "https://www.youtube.com/watch?v=vqfrSLHUdms")
        videoList.append(nutritionVideo1)
        videoList.append(nutritionVideo2)
        videoList.append(nutritionVideo3)
        // Podcasts
        let nutritionPodcast1 = Resource(title: "The Drive", date: "", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionPodcast1")!, link: "https://podcasts.apple.com/us/podcast/the-peter-attia-drive/id1400828889")
        let nutritionPodcast2 = Resource(title: "The ZDoggMD Show", date: "", author: "Dr. Zubin Damania", icon: UIImage(named: "nutritionPodcast2")!, link: "https://podcasts.apple.com/us/podcast/the-zdoggmd-show/id1218431966")
        let nutritionPodcast3 = Resource(title: "Found My Fitness", date: "", author: "Dr. Rhonda Patrick", icon: UIImage(named: "nutritionPodcast3")!, link: "https://podcasts.apple.com/us/podcast/foundmyfitness/id818198322")
        podcastList.append(nutritionPodcast1)
        podcastList.append(nutritionPodcast2)
        podcastList.append(nutritionPodcast3)
        // Articles -- implement see more after three pop up (model each widget after youtube app picture, title, date, author etc.)
        let nutritionArticle1 = Resource(title: "The red meat and plant-based recommendation wars", date: "03/01/2020", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle1")!, link: "https://peterattiamd.com/the-red-meat-and-plant-based-recommendation-wars/")
        let nutritionArticle2 = Resource(title: "Is a low fat diet best for weight loss?", date: "12/18/2012", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle2")!, link: "https://peterattiamd.com/is-a-low-fat-diet-best-for-weight-loss/")
        let nutritionArticle3 = Resource(title: "How to make a fat cell less not thin: the lessons of fat flux", date: "08/18/2013", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionArticle3")!, link: "https://peterattiamd.com/how-to-make-a-fat-cell-less-not-thin-the-lessons-of-fat-flux/")
        articleList.append(nutritionArticle1)
        articleList.append(nutritionArticle2)
        articleList.append(nutritionArticle3)
        // Apps
        let nutritionApp1 = Resource(title: "MyFitnessPal", date: "", author: "Under Armour", icon: UIImage(named: "nutritionApp1")!, link: "https://apps.apple.com/us/app/myfitnesspal/id341232718")
        let nutritionApp2 = Resource(title: "EatThisMuch App", date: "", author: "", icon: UIImage(named: "nutritionApp2")!, link: "https://apps.apple.com/us/app/eat-this-much-meal-planner/id981637806")
        let nutritionApp3 = Resource(title: "Zero App", date: "", author: "", icon: UIImage(named: "nutritionApp3")!, link: "https://apps.apple.com/us/app/zero-simple-fasting-tracker/id1168348542")
        // my fitness pal
        // eatthismuch
        appList.append(nutritionApp1)
        appList.append(nutritionApp2)
        appList.append(nutritionApp3)
        // Websites
        let nutritionWebsite1 = Resource(title: "https://peterattiamd.com/topics/", date: "", author: "Dr. Peter Attia", icon: UIImage(named: "nutritionWebsite1")!, link: "https://peterattiamd.com/topics/")
        let nutritionWebsite2 = Resource(title: "https://www.foundmyfitness.com/", date: "", author: "Dr. Rhonda Patrick", icon: UIImage(named: "nutritionWebsite2")!, link: "https://www.foundmyfitness.com/")
        let nutritionWebsite3 = Resource(title: "https://www.dietdoctor.com/", date: "", author: "", icon: UIImage(named: "nutritionWebsite3")!, link: "https://www.dietdoctor.com/")
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

