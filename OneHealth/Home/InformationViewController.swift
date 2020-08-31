//
//  InformationViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

//
//  InformationTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/26/20.
//

import UIKit

class InformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var informationTableView: UITableView!
    
    var linksList: Array<Array<Resource>>?
    
/* Reference for adding URLs. probably in resoure table view cell
     
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
     */
    
    
    
    // Determine which lists to declare based on segue
    // don't hard code any parameters in cell.setAttributes, just get from list that is chosen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informationTableView.dataSource = self
        informationTableView.delegate = self
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returns five total section for the Feed.
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // this should be dynamic based on the number of items in, say, articlesList
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Determines which type of cell to instantiate depending on the row in information.
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Cell is "HeaderTableViewCell".
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                // Set the attributes of the cell based on the Personal protocol.
                cell.setAttributes(header: "Videos")
                return cell
            } else if indexPath.row == 1 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[0][0].title ?? "", author: linksList?[0][0].author ?? "", date: linksList?[0][0].date ?? "", image: (linksList?[0][0].icon)!)
                return cell
            } else if indexPath.row == 2 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[0][1].title ?? "", author: linksList?[0][1].author ?? "", date: linksList?[0][1].date ?? "", image: (linksList?[0][1].icon)!)
                return cell
            } else {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[0][2].title ?? "", author: linksList?[0][2].author ?? "", date: linksList?[0][2].date ?? "", image: (linksList?[0][2].icon)!)
                return cell
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Cell is "HeaderTableViewCell".
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                // Set the attributes of the cell based on the Personal protocol.
                cell.setAttributes(header: "Podcasts")
                return cell
            } else if indexPath.row == 1 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[1][0].title ?? "", author: linksList?[1][0].author ?? "", date: linksList?[1][0].date ?? "", image: (linksList?[1][0].icon)!)
                return cell
            } else if indexPath.row == 2 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[1][1].title ?? "", author: linksList?[1][1].author ?? "", date: linksList?[1][1].date ?? "", image: (linksList?[1][1].icon)!)
                return cell
            } else {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[1][2].title ?? "", author: linksList?[1][2].author ?? "", date: linksList?[1][2].date ?? "", image: (linksList?[1][2].icon)!)
                return cell
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                // Cell is "HeaderTableViewCell".
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                // Set the attributes of the cell based on the Personal protocol.
                cell.setAttributes(header: "Articles")
                return cell
            } else if indexPath.row == 1 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[2][0].title ?? "", author: linksList?[2][0].author ?? "", date: linksList?[2][0].date ?? "", image: (linksList?[2][0].icon)!)
                return cell
            } else if indexPath.row == 2 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[2][1].title ?? "", author: linksList?[2][1].author ?? "", date: linksList?[2][1].date ?? "", image: (linksList?[2][1].icon)!)
                return cell
            } else {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[2][2].title ?? "", author: linksList?[2][2].author ?? "", date: linksList?[2][2].date ?? "", image: (linksList?[2][2].icon)!)
                return cell
            }
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                // Cell is "HeaderTableViewCell".
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                // Set the attributes of the cell based on the Personal protocol.
                cell.setAttributes(header: "Apps")
                return cell
            } else if indexPath.row == 1 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[3][0].title ?? "", author: linksList?[3][0].author ?? "", date: linksList?[3][0].date ?? "", image: (linksList?[3][0].icon)!)
                return cell
            } else if indexPath.row == 2 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[3][1].title ?? "", author: linksList?[3][1].author ?? "", date: linksList?[3][1].date ?? "", image: (linksList?[3][1].icon)!)
                return cell
            } else {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[3][2].title ?? "", author: linksList?[3][2].author ?? "", date: linksList?[3][2].date ?? "", image: (linksList?[3][2].icon)!)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                // Cell is "HeaderTableViewCell".
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
                // Set the attributes of the cell based on the Personal protocol.
                cell.setAttributes(header: "Websites")
                return cell
            } else if indexPath.row == 1 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[4][0].title ?? "", author: linksList?[4][0].author ?? "", date: linksList?[4][0].date ?? "", image: (linksList?[4][0].icon)!)
                return cell
            } else if indexPath.row == 2 {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[4][1].title ?? "", author: linksList?[4][1].author ?? "", date: linksList?[4][1].date ?? "", image: (linksList?[4][1].icon)!)
                return cell
            } else {
                let cell = informationTableView.dequeueReusableCell(withIdentifier: "ResourceTableViewCell", for: indexPath) as! ResourceTableViewCell
                // Set the attributes of the cell based on the Resource protocol.
                cell.setAttributes(title: linksList?[4][2].title ?? "", author: linksList?[4][2].author ?? "", date: linksList?[4][2].date ?? "", image: (linksList?[4][2].icon)!)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row so that it does not stay highlighted after segue.
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

