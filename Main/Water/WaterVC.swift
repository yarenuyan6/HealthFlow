//
//  WaterVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.12.2023.
//

import UIKit
import Charts
import DGCharts

protocol WaterDelegate{
    func updateWaterModelArray()
    func setUpProgressView()
}

class WaterVC: UIViewController {
    
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var waterTableView: UITableView!
    @IBOutlet weak var waterProgressView: UIProgressView!
    @IBOutlet weak var waterIntakeLabel: UILabel!
    @IBOutlet weak var idealWaterIntakeLabel: UILabel!
    @IBOutlet weak var goBackImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var chartView: UIView!
    
    
    var viewModel: WaterVM! {
        didSet{
            viewModel.waterDelegate = self
        }
    }
    var addedWaterArray = [WaterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestures()
                setUpTableView()
        viewModel.calculateIdealIntake()
        viewModel.waterModel.idealWater = viewModel.idealWaterIntake
        viewModel.getWaterInfo()
        viewModel.getTotalMlFromFirebase { totalMl in
            self.viewModel.totalMl = totalMl
            self.setUpUI()
            self.setUpBarChart()
        }
    }
    
        private func setUpTableView(){
            waterTableView.delegate = self
            waterTableView.dataSource = self
            waterTableView.register(UINib(nibName: WaterTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: WaterTableViewCell.identifier)
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
                let dailyTotalMl = sortedResults[dayIndex] // Tersine çevirmeyin
                let entry = BarChartDataEntry(x: Double(dayIndex), y: dailyTotalMl)
                barChartDataEntries.append(entry)
            }
            
            let dataSet = BarChartDataSet(entries: barChartDataEntries, label: "Daily Total Ml for Week")
            let data = BarChartData(dataSet: dataSet)
            barChartView.data = data
        }
    }
    
    private func tapGestures(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackImageViewTapped))
        goBackImageView.addGestureRecognizer(goBackTapGesture)
        goBackImageView.isUserInteractionEnabled = true
        
        let plusImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(plusImageViewTapped))
        plusImageView.addGestureRecognizer(plusImageViewTapGesture)
        plusImageView.isUserInteractionEnabled = true
    }
    
    @objc func goBackImageViewTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func plusImageViewTapped(){
        guard let waterMl = Int(waterTextField.text ?? "") else {return}
        viewModel.setWaterModel(ml: waterMl)
        viewModel.addWaterToFirebase(waterMod: viewModel.waterModel)
        self.updateWaterModelArray()
    }
    
    func setUpUI(){
        guard let intakeWater = self.viewModel.totalMl else {return}
        waterIntakeLabel.text = "Intake of Water: \(intakeWater) ml"
        
        guard let idealWaterIntake = self.viewModel.idealWaterIntake else {return}
        idealWaterIntakeLabel.text = "Ideal Water Intake: \(Int(idealWaterIntake)) ml"
        
        //        viewModel.mainDelegate?.updateWaterIntakeLabel(intakeWater: String(intakeWater), idealIntakeWater: String(idealWaterIntake))
    }
    
}

extension WaterVC: UITableViewDataSource, UITableViewDelegate{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//        
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addedWaterArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       let cell = tableView.dequeueReusableCell(withIdentifier: WaterTableViewCell.identifier, for: indexPath) as! WaterTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: WaterTableViewCell.identifier) as! WaterTableViewCell
        cell.indexPath = indexPath.row
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
}

extension WaterVC: WaterDelegate{
    func updateWaterModelArray(){
        setUpUI()
        self.waterTableView.reloadData()
    }
    
    func setUpProgressView(){
        waterProgressView.progress = Float(viewModel.calculateProgress())
    }
}
