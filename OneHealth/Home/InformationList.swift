//
//  List.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/25/20.
//

import UIKit

// TODO - data from a database if I wanted to continuously update app with new information.
// TODO - Create an information list interface that each type of resource implements, and instead of hard coding
// data, pull data from database 

class InformationList {
    
    // MARK: - Properties
    
    
    // Declare list for all businesses.
    static var list = [Information]()
    
    // MARK: - Methods
    
    static func loadInformation() {
        /* Create Business object for each business. Create deals, promotions, and rewards for each business. Add each business to the list of the category
           it corresponds to, as well as the list of all businesses.
        */
        let diet = Information(icon: UIImage(named: "diet")!)
        let workout = Information(icon: UIImage(named:"workout")!)
        let nutrition = Information(icon: UIImage(named: "nutrition")!) // Add specific links to nutrition
        let dna = Information(icon: UIImage(named: "DNA")!)
        let meditation = Information(icon: UIImage(named: "meditation")!)
        let longevity = Information(icon: UIImage(named: "longevity")!)
        let supplements = Information(icon: UIImage(named: "supplements")!)
        
        list.append(diet)
        list.append(workout)
        list.append(nutrition)
        list.append(longevity)
        list.append(supplements)
        list.append(meditation)
        list.append(dna)
        
        
    
        
    }
    
    static func getList() -> [Information] {
        return self.list
    }
    
    static func listCount() -> Int {
        return list.count
    }
    
}

