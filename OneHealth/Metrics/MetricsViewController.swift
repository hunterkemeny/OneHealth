//
//  MetricsViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 1/22/20.
//

import UIKit
import Charts
import CoreData

class MetricsViewController: UIViewController {

    
    @IBOutlet weak var activeCalsView: LineChartView!
    @IBOutlet weak var dateSlider: UISegmentedControl!
    
    
    let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeCalsWeek()
        }
        
        func activeCalsWeek() {
            var lineChartEntry = [ChartDataEntry]()
            
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
            } catch {
                fatalError("Failure to fetch: \(error)")
            }
            
            if dateSlider.selectedSegmentIndex == 0 {
                for i in -6...0 {
                    
                    // get last week of data in order
                    if i == -6 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 1, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == -5 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 2, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == -4 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 3, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == -3 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 4, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == -2 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 5, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == -1 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 6, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    } else if i == 0 {
                        for num in 0...results.count - 1 {
                            if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                                let value = ChartDataEntry(x: 7, y: results[num].activeCals)
                                lineChartEntry.append(value)
                            }
                        }
                    }
                    
                }
            }
            
            let line1 = LineChartDataSet(entries: lineChartEntry, label: "Active Calories Burned")
            line1.colors = [NSUIColor.blue]
            let data = LineChartData()
            data.addDataSet(line1)
            activeCalsView.data = data
            activeCalsView.chartDescription?.text = "Active Calories v. Time"
            
            
            
        }
        
    func activeCalsMonth() {
        if dateSlider.selectedSegmentIndex == 1 {
            
        }
    }
        
            
    func activeCalsYear() {
        if dateSlider.selectedSegmentIndex == 2 {
            
        }
    }
        
}
