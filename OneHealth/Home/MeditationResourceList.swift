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
        let attiaNutritionInterview0 = Resource(title: "Copy title here", date: "10/02/2000", author: "JRE", icon: UIImage(named: "peter")!)
        let otherNutritionInterview0 = Resource(title: "There will be a title", date: "10/20/1010", author: "unkown", icon: UIImage(named: "peter")!)
        videoList.append(attiaNutritionInterview0)
        videoList.append(otherNutritionInterview0)
        videoList.append(otherNutritionInterview0)
        // Podcasts
        let attiaPodcast0 = Resource(title: "first attia podcast", date: "10/02/2020", author: "RP", icon: UIImage(named: "peter")!)
        podcastList.append(attiaPodcast0)
        podcastList.append(attiaPodcast0)
        podcastList.append(attiaPodcast0)
        // Articles -- implement see more after three pop up (model each widget after youtube app picture, title, date, author etc.)
        
        articleList.append(attiaPodcast0)
        articleList.append(attiaPodcast0)
        articleList.append(attiaPodcast0)
        // Apps
        appList.append(attiaPodcast0)
        appList.append(attiaPodcast0)
        appList.append(attiaPodcast0)
        // Websites
        websiteList.append(attiaPodcast0)
        websiteList.append(attiaPodcast0)
        websiteList.append(attiaPodcast0)
        
        
    }
    
    static func getList() -> Array<Array<Resource>> {
        return self.list
    }
    
    
    static func listCount() -> Int {
        return list.count
    }
    

    
}


