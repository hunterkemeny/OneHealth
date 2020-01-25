//
//  InsertInfoViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/25/20.
//

import UIKit

class InsertInfoViewController: UIViewController {

    @IBOutlet weak var categoryExecuted: UILabel!
    @IBOutlet weak var dayMonthYear: UILabel!
    
    var category: String!
    var logDate: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryExecuted.text = category
        dayMonthYear.text = logDate
    }
}
