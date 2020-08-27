//
//  MetricsTableViewController.swift
//  OneHealth
//
//  Created by Hunter Kemeny on 8/27/20.
//

import UIKit
import Charts
import CoreData

class MetricsTableViewController: UITableViewController {

    @IBOutlet weak var activeCalsView: LineChartView!
    @IBOutlet weak var dateSlider: UISegmentedControl!
    
    @IBAction func dateSliderTapped(_ sender: Any) {
        viewDidLoad()
    }
    
    
    let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dateSlider.selectedSegmentIndex == 0 {
            activeCalsWeek()
            
        } else if dateSlider.selectedSegmentIndex == 1 {
            activeCalsMonth()
            
        } else if dateSlider.selectedSegmentIndex == 2 {
            activeCalsYear()
            
        }
        
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
               print(results)
           } catch {
               fatalError("Failure to fetch: \(error)")
           }
               
           if dateSlider.selectedSegmentIndex == 1 {
               for i in 0...30 {
                   
                   let value = ChartDataEntry(x: abs(Double(i)), y: 100.0 + Double(i))
                   lineChartEntry.append(value)
                   /*
                   // get last week of data in order
                   if i == -30 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 1, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -29 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 2, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -28 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 3, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -27 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 4, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -26 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 5, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -25 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 6, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -24 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 7, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -23 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 8, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -22 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 9, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -21 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 10, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -20 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 11, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -19 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 12, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -18 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 13, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -17 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 14, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -16 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 15, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -15 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 16, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -14 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 17, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -13 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 18, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -12 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 19, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -11 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 20, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -10 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 21, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -9 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 22, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -8 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 23, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -7 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 24, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -6 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 25, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -5 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 26, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -4 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 27, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -3 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 28, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -2 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 29, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == -1 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 30, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   } else if i == 0 {
                       for num in 0...results.count - 1 {
                           if dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: i, to: noon)!) == results[num].dateOfLog {
                               let value = ChartDataEntry(x: 31, y: results[num].activeCals)
                               lineChartEntry.append(value)
                           }
                       }
                   }
    
    */
                       
               }
           }
               
           let line1 = LineChartDataSet(entries: lineChartEntry, label: "Active Calories Burned")
           line1.colors = [NSUIColor.blue]
           let data = LineChartData()
           data.addDataSet(line1)
           activeCalsView.data = data
           activeCalsView.chartDescription?.text = "Active Calories v. Time"
               
       }
           
               
       func activeCalsYear() {
           if dateSlider.selectedSegmentIndex == 2 {
               
           }
       }
         

    
}
