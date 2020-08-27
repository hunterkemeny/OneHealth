//
//  ResourceTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var resourceImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setAttributes(title: String, author: String, date: String, image: UIImage) {
        
        titleLabel.text = title
        authorLabel.text = author
        dateLabel.text = date
        resourceImageView.image = image
    }
    
}
