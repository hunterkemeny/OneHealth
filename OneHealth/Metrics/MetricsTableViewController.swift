//
//  MetricsTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import UIKit
import CoreData
import Firebase
import CoreData
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import Charts



class MetricsTableViewController: UITableViewController {

    var db: Firestore!
    let userID:String? = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var predictWeightView: LineChartView!
    @IBOutlet weak var activeCalsView: LineChartView!
    @IBOutlet weak var dateSlider: UISegmentedControl!
    @IBOutlet weak var weightSwitch: UISwitch!
    @IBOutlet weak var burnedSwitch: UISwitch!
    @IBOutlet weak var consumedSwitch: UISwitch!
    
    @IBAction func dateSliderTapped(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func weightSwitched(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func burnedSwitch(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func consumedSwitch(_ sender: Any) {
        viewDidLoad()
    }
    
    let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMetrics()
        if dateSlider.selectedSegmentIndex == 0 {
            predictedWeightLossMonth()
        } else if dateSlider.selectedSegmentIndex == 1 {
            predictedWeightLoss3Months()
        }
    }
    
    func predictedWeightLossMonth() {
        var weight = [ChartDataEntry]()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        var results: [User]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        var initialWeight = Double(results[0].weight!)!
        
        let value1 = ChartDataEntry(x:1,  y: initialWeight)
        
        weight.append(value1)
        
        for i in 2...5 {
            initialWeight += PersonInfo.getDailyCalorieDelta()*7 * (1/3500)
            let value = ChartDataEntry(x: Double(i), y: initialWeight)
            weight.append(value)
        }
        let line1 = LineChartDataSet(entries: weight, label: "Weight")
           line1.colors = [NSUIColor.blue]
        
           let data = LineChartData()
           data.addDataSet(line1)
           predictWeightView.data = data
           predictWeightView.chartDescription?.text = "Active Calories v. Time"
        
    }
    
    func predictedWeightLoss3Months() {
        var weight = [ChartDataEntry]()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        var results: [User]
        do {
            try results = context.fetch(request)
        } catch {
            fatalError("Failure to fetch: \(error)")
        }
        
        var initialWeight = Double(results[0].weight!)!
        
        let value1 = ChartDataEntry(x:1,  y: initialWeight)
        
        weight.append(value1)
        
        for i in 2...12 {
            
            initialWeight += PersonInfo.getDailyCalorieDelta()*7 * (1/3500)
            let value = ChartDataEntry(x: Double(i), y: initialWeight)
            weight.append(value)
        }

        
        
        
        let line1 = LineChartDataSet(entries: weight, label: "Weight")
           line1.colors = [NSUIColor.blue]
        
           let data = LineChartData()
           data.addDataSet(line1)
           predictWeightView.data = data
           predictWeightView.chartDescription?.text = "Active Calories v. Time"
    }
    
           
       func selectedMetrics() {
           var weight = [ChartDataEntry]()
            var calsBurned = [ChartDataEntry]()
            var calsConsumed = [ChartDataEntry]()
               
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "MM/dd/yyyy"
               
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
               
           let request: NSFetchRequest<LogDate> = LogDate.fetchRequest()
           request.returnsObjectsAsFaults = false
               
           // Fetch the "LogDate" object.
           var results: [LogDate]
           do {
               try results = context.fetch(request)
               print(results)
           } catch {
               fatalError("Failure to fetch: \(error)")
           }
               
    
        for i in 0...results.count - 1 {
            let weightValue = ChartDataEntry(x: abs(Double(i)), y: results[i].weight)
            let burnedValue = ChartDataEntry(x: abs(Double(i)), y: results[i].activeCals) // change to maintenence plus activecals, or BMR plus active cals
            let consumedValue = ChartDataEntry(x: abs(Double(i)), y: results[i].calsIntake)
            weight.append(weightValue)
            calsBurned.append(burnedValue)
            calsConsumed.append(consumedValue)
                       
           }
               
        let line1 = LineChartDataSet(entries: weight, label: "Active Calories Burned")
        line1.colors = [NSUIColor.blue]
        
        let line2 = LineChartDataSet(entries: calsBurned, label: "Calories Burned")
        line2.colors = [NSUIColor.red]
        let line3 = LineChartDataSet(entries: calsConsumed, label: "Calories Consumed")
        line3.colors = [NSUIColor.green]
        
        let data = LineChartData()
        
        if weightSwitch.isOn == true {
            data.addDataSet(line1)
        }
        if burnedSwitch.isOn == true {
            data.addDataSet(line2)
        }
        if consumedSwitch.isOn == true {
            data.addDataSet(line3)
        }

        activeCalsView.data = data
        activeCalsView.chartDescription?.text = "Active Calories v. Time"
               
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row so that it does not stay highlighted after segue.
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
