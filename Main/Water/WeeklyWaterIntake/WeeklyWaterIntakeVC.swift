//
//  WeeklyWaterIntakeVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 2.01.2024.
//

import UIKit
import Charts
import DGCharts

class WeeklyWaterIntakeVC: UIViewController {
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    
    var viewModel: WaterVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarChart()
        tapGestures()
    }
    
    private func setUpBarChart(){
        
        let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
        let barChartView = BarChartView()

        barChartView.frame = CGRect(x: 0, y: 0, width: self.chartView.frame.size.width, height: self.chartView.frame.size.height)
        barChartView.center = chartView.center
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false

        let xAxis = barChartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfWeek)
        xAxis.labelCount = daysOfWeek.count
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false

        chartView.addSubview(barChartView)


        viewModel.getWeeklyTotalMl { sortedResults in
            var barChartDataEntries: [BarChartDataEntry] = []
            
//            for dayIndex in 0...dailyTotalMlValues.count - 1{
//                let reversedIndex = dailyTotalMlValues.count - dayIndex - 1
//                let dailyTotalMl = dailyTotalMlValues[reversedIndex]
//                let entry = BarChartDataEntry(x: Double(dayIndex), y: dailyTotalMl)
//                barChartDataEntries.append(entry)
//            }

            for dayIndex in 0...sortedResults.count - 1 {
                let dailyTotalMl = sortedResults[dayIndex] 
                let entry = BarChartDataEntry(x: Double(dayIndex), y: dailyTotalMl)
                barChartDataEntries.append(entry)
            }
            
            let dataSet = BarChartDataSet(entries: barChartDataEntries, label: "Daily Total Ml for Week")
            let data = BarChartData(dataSet: dataSet)
            barChartView.data = data
        }
    }
    
    private func tapGestures(){
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeImgViewTapped))
        closeImageView.addGestureRecognizer(closeTapGesture)
        closeImageView.isUserInteractionEnabled = true
    }
    
    @objc func closeImgViewTapped(){
        self.dismiss(animated: true)
    }
}
