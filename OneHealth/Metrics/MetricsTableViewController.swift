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
        // if its the first time they open the app, have a label that says "reload app". Also tell them to reload in tutorial.
        
        predictWeightView.chartDescription?.enabled = false
        predictWeightView.pinchZoomEnabled = false
        predictWeightView.legend.enabled = true
        
        predictWeightView.leftAxis.enabled = true
        predictWeightView.leftAxis.spaceTop = 0.4
        predictWeightView.leftAxis.spaceBottom = 0.4
        predictWeightView.rightAxis.enabled = false
        predictWeightView.xAxis.enabled = true
        predictWeightView.xAxis.axisMaximum = 6
        predictWeightView.xAxis.axisMinimum = 0
        
        
        let leftAxis = predictWeightView.leftAxis
        leftAxis.gridLineDashLengths = [5, 5]
    
        
        predictWeightView.xAxis.gridLineDashLengths = [5, 5]
        
        
        predictWeightView.animate(xAxisDuration: 1)
        

        var initialWeight = Double(results[0].weight!)!
        
        let value1 = ChartDataEntry(x: 1,  y: initialWeight)
        
        weight.append(value1)
        
        for i in 2...5 {
            if results[0].goalType == "gain" {
                initialWeight += Double(PersonInfo.calculateCalorieDeltaPerDay()*7) * (1/3500)
            } else {
               initialWeight -= Double(PersonInfo.calculateCalorieDeltaPerDay()*7) * (1/3500)
            }
            let value = ChartDataEntry(x: Double(i), y: Double(Int(initialWeight)))
            weight.append(value)
        }
        var finalWeight = initialWeight
        let line1 = LineChartDataSet(entries: weight, label: "Weight (lbs)")
           line1.colors = [NSUIColor.blue]
        
           let data = LineChartData()
           data.addDataSet(line1)
           predictWeightView.data = data
        
        
        if results[0].goalType == "lose" {
            leftAxis.axisMaximum = Double(results[0].weight!)! + 5
            leftAxis.axisMinimum = finalWeight - 5
        } else {
            leftAxis.axisMinimum = Double(results[0].weight!)! - 5
            leftAxis.axisMaximum = finalWeight + 5
        }
        
        
    
        line1.lineWidth = 1.75
        line1.circleRadius = 5.0
        line1.circleHoleRadius = 2.5
        line1.setColor(.systemBlue)
        line1.setCircleColor(.black)
        line1.highlightColor = .black
        line1.drawValuesEnabled = true
        
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
        
        predictWeightView.chartDescription?.enabled = false
        predictWeightView.pinchZoomEnabled = false
        predictWeightView.legend.enabled = true
        
        predictWeightView.leftAxis.enabled = true
        predictWeightView.leftAxis.spaceTop = 0.4
        predictWeightView.leftAxis.spaceBottom = 0.4
        predictWeightView.rightAxis.enabled = false
        predictWeightView.xAxis.enabled = true
        predictWeightView.xAxis.axisMaximum = 12
        predictWeightView.xAxis.axisMinimum = 1
        
        
        let leftAxis = predictWeightView.leftAxis
        
        leftAxis.gridLineDashLengths = [5, 5]
        
            
        predictWeightView.xAxis.gridLineDashLengths = [5, 5]
            
            
        predictWeightView.animate(xAxisDuration: 1)
        
        
        
        
        var initialWeight = Double(results[0].weight!)!
        
        let value1 = ChartDataEntry(x:1,  y: initialWeight)
        
        weight.append(value1)
        
        for i in 2...12 {
            if results[0].goalType == "gain" {
                initialWeight += Double(PersonInfo.calculateCalorieDeltaPerDay()*7) * (1/3500)
            } else {
               initialWeight -= Double(PersonInfo.calculateCalorieDeltaPerDay()*7) * (1/3500)
            }
            
            let value = ChartDataEntry(x: Double(i), y: initialWeight)
            weight.append(value)
        }

        var finalWeight = initialWeight
        
        let line1 = LineChartDataSet(entries: weight, label: "Weight")
        line1.colors = [NSUIColor.blue]
        
        line1.lineWidth = 1.75
        line1.circleRadius = 5.0
        line1.circleHoleRadius = 2.5
        line1.setColor(.systemBlue)
        line1.setCircleColor(.black)
        line1.highlightColor = .black
        line1.drawValuesEnabled = true
        
        if results[0].goalType == "lose" {
            leftAxis.axisMaximum = Double(results[0].weight!)! + 5
            leftAxis.axisMinimum = finalWeight - 5
        } else {
            leftAxis.axisMinimum = Double(results[0].weight!)! - 5
            leftAxis.axisMaximum = finalWeight + 5
        }
        
        let data = LineChartData()
        data.addDataSet(line1)
        predictWeightView.data = data
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
               
        print(results)
        for i in 0...results.count - 1 {
            let weightValue = ChartDataEntry(x: abs(Double(i)), y: results[i].weight)
            let burnedValue = ChartDataEntry(x: abs(Double(i)), y: results[i].activeCals + PersonInfo.getMaintenence()) // change to maintenence plus activecals, or BMR plus active cals
            let consumedValue = ChartDataEntry(x: abs(Double(i)), y: results[i].calsIntake)
            weight.append(weightValue)
            calsBurned.append(burnedValue)
            calsConsumed.append(consumedValue)
                       
           }
        
        activeCalsView.chartDescription?.enabled = false
        activeCalsView.pinchZoomEnabled = false
        activeCalsView.legend.enabled = true
        
        activeCalsView.leftAxis.enabled = true
        activeCalsView.leftAxis.spaceTop = 0.4
        activeCalsView.leftAxis.spaceBottom = 0.4
        activeCalsView.rightAxis.enabled = true
        activeCalsView.xAxis.enabled = true
        
        
        let leftAxis = activeCalsView.leftAxis
        
        leftAxis.axisMaximum = 4000
        leftAxis.axisMinimum = 0
        
        let rightAxis = activeCalsView.rightAxis
        rightAxis.axisMaximum = 300
        rightAxis.axisMinimum = 0
        
        leftAxis.gridLineDashLengths = [5, 5]
        
            
        activeCalsView.xAxis.gridLineDashLengths = [5, 5]
            
            
        activeCalsView.animate(xAxisDuration: 1)
               
        let line1 = LineChartDataSet(entries: weight, label: "Weight")
        line1.colors = [NSUIColor.blue]
        line1.axisDependency = .right
        line1.lineWidth = 1.75
        line1.circleRadius = 5.0
        line1.circleHoleRadius = 2.5
        line1.setCircleColor(.black)
        line1.highlightColor = .black
        line1.drawValuesEnabled = true
        
        let line2 = LineChartDataSet(entries: calsBurned, label: "Calories Burned")
        line2.colors = [NSUIColor.red]
        line2.axisDependency = .left
        line2.lineWidth = 1.75
        line2.circleRadius = 5.0
        line2.circleHoleRadius = 2.5
        line2.setCircleColor(.black)
        line2.highlightColor = .black
        line2.drawValuesEnabled = false
        
        
        let line3 = LineChartDataSet(entries: calsConsumed, label: "Calories Consumed")
        line3.colors = [NSUIColor.green]
        line3.axisDependency = .left
        line3.lineWidth = 1.75
        line3.circleRadius = 5.0
        line3.circleHoleRadius = 2.5
        line3.setCircleColor(.black)
        line3.highlightColor = .black
        line3.drawValuesEnabled = false
        
        
        
        
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
