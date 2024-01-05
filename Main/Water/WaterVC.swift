//
//  WaterVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.12.2023.
//

import UIKit
import Charts
import DGCharts
import Firebase

protocol WaterDelegate{
    func updateUI()
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
    @IBOutlet weak var weeklyWaterIntakeLabel: UILabel!
    
    var viewModel: WaterVM! {
        didSet{
            viewModel.waterDelegate = self
        }
    }
    var addedWaterArray = [WaterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestures()
        viewModel.calculateIdealIntake()
        viewModel.waterModel.idealWater = viewModel.idealWaterIntake
        viewModel.getWaterInfo()
        viewModel.getTotalMlFromFirebase { totalMl in
            self.viewModel.totalMl = totalMl
            self.setUpUI()
            self.setUpTableView()
        }
    }
    
        private func setUpTableView(){
            waterTableView.delegate = self
            waterTableView.dataSource = self
            waterTableView.register(UINib(nibName: WaterTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: WaterTableViewCell.identifier)
        }
    
    private func tapGestures(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackImageViewTapped))
        goBackImageView.addGestureRecognizer(goBackTapGesture)
        goBackImageView.isUserInteractionEnabled = true
        
        let plusImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(plusImageViewTapped))
        plusImageView.addGestureRecognizer(plusImageViewTapGesture)
        plusImageView.isUserInteractionEnabled = true
        
        let weeklyWaterTaoGesture = UITapGestureRecognizer(target: self, action: #selector(weeklyWaterLabelTapped))
        weeklyWaterIntakeLabel.addGestureRecognizer(weeklyWaterTaoGesture)
        weeklyWaterIntakeLabel.isUserInteractionEnabled = true
        
        
    }
    
    @objc func goBackImageViewTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func plusImageViewTapped(){
        guard let waterMl = Int(waterTextField.text ?? "") else {return}
        viewModel.setWaterModelForAdd(ml: waterMl)
        viewModel.addWaterToFirebase(waterMod: viewModel.waterModel)
        self.updateUI()
    }
    
    @objc func weeklyWaterLabelTapped(){
        let weeklyWaterVC = UIStoryboard (name: "WeeklyWaterIntake", bundle: nil).instantiateViewController(withIdentifier: "WeeklyWaterIntakeVC") as! WeeklyWaterIntakeVC
        weeklyWaterVC.modalPresentationStyle = .overCurrentContext
        weeklyWaterVC.viewModel = viewModel
        self.present(weeklyWaterVC, animated: true, completion: nil)
    }
    
    func setUpUI(){
        guard let intakeWater = self.viewModel.totalMl else {return}
        waterIntakeLabel.text = "Intake of Water: \(intakeWater) ml"
        
        guard let idealWaterIntake = self.viewModel.idealWaterIntake else {return}
        idealWaterIntakeLabel.text = "Ideal Water Intake: \(Int(idealWaterIntake)) ml"
    }
    
}

extension WaterVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.addedWaterArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WaterTableViewCell.identifier) as! WaterTableViewCell

        
        cell.indexPath = indexPath.section
        cell.viewModel = viewModel
        cell.documentIdArray = viewModel.documentIdArray
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension WaterVC: WaterDelegate{
    func updateUI(){
        setUpUI()
        self.waterTableView.reloadData()
    }
    
    func setUpProgressView(){
        waterProgressView.progress = Float(viewModel.calculateProgress())
    }
}
