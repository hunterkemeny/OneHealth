//
//  Resource.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class Resource {
    
    // MARK: - Properties
    
    var icon: UIImage?
    var button: UIButton?
    var title: String?
    var date: String?
    var author: String?
    var link: String?
    
    
    // MARK: - INIT
    init (title: String, date: String, author: String, icon: UIImage, link: String) {
        self.icon = icon
        self.title = title
        self.date = date
        self.author = author
        self.link = link
    }
}
