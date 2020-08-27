//
//  GeneralCollectionViewCell.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/25/20.
//

import UIKit

class GeneralCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var generalImageView: UIImageView!
    //@IBOutlet weak var generalButton: UIButton!
    
    var buttonLink: String?
    
    func setAttributes(info: Information, saveIndex: Int) {
        
        //if saveIndex == 0 {
        
        generalImageView.image = info.icon
        //buttonLink = "https://peterattiamd.com/"
        
        //}
        
    }
    /*
    @IBAction func didTapArticle(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: buttonLink ?? "")!)
    }
 */
    
}
