//
//  ResourceTableViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class ResourceTableViewCell: UITableViewCell {

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resourceImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resourceButton: UIButton!
    
    // MARK: - Properties
    
    var buttonLink: String?
    
    // MARK: - Method
    
    func setAttributes(title: String, author: String, date: String, image: UIImage, link: String) {
        titleLabel.text = title
        authorLabel.text = author
        dateLabel.text = date
        resourceImageView.image = image
        buttonLink = link
    }
    
    // MARK: - IBAction
    
    @IBAction func didTapResource(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: buttonLink ?? "")!)
    }
}
