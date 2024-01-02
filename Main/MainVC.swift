//
//  ViewController.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 12.11.2023.
//

import UIKit

protocol MainVCDelegate{
    func updateWaterIntakeLabel(intakeWater:Int, idealIntakeWater: Int)
}

class MainVC: UIViewController {
    
    var viewModel: MainVM!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var greetingsImageView: UIImageView!
    @IBOutlet weak var waterStackView: UIStackView!
    @IBOutlet weak var foodStackView: UIStackView!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var editHeightWeightStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var waterIntakeLabel: UILabel!
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeader()
        setUpUI()
        tapGestures()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserDetail()
        
    }
    
    //MARK: Network call
    private func fetchUserDetail(){
        LoadingOverlay.shared.showOverlay(view: self.view)
        
        viewModel.getUserInfo{ user, error in
            DispatchQueue.main.async {
                if let user = user {
                    self.nameLabel.text = user.name
                    guard let height = user.height , let weight = user.weight else {return}
                    self.bmiLabel.text = self.viewModel.calculateBMI(height: height, weight: weight)
                    self.viewModel.waterVM.userModel = self.viewModel.userModel
                    self.viewModel.waterVM.calculateIdealIntake()
                    self.getWaterInfo()
                    LoadingOverlay.shared.hideOverlayView()
                }
                if let error = error {
                    self.nameLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    private func setUpHeader(){
        let calender = Calendar.current
        let hour = calender.component(.hour, from: Date())
        
        switch hour {
        case 4 ..< 12:
            greetingsLabel.text = "Good Morning"
            greetingsImageView.image = UIImage(named: "sunrise")
        case 12 ..< 18:
            greetingsLabel.text = "Good Afternoon"
            greetingsImageView.image = UIImage(named: "sunny")
        default:
            greetingsLabel.text = "Good Evening"
            greetingsImageView.image = UIImage(named: "moonlight")
        }
    }
    
    
    private func setUpUI(){
        waterStackView.layer.borderWidth = 2
        waterStackView.layer.borderColor = UIColor.americanSilver.cgColor
        
        foodStackView.layer.borderWidth = 2
        foodStackView.layer.borderColor = UIColor.americanSilver.cgColor
    }
    
    // MARK: tapGesture functions
    
    private func tapGestures(){
        let foodTapGesture = UITapGestureRecognizer(target: self, action: #selector(foodStackViewTapped))
        foodStackView.addGestureRecognizer(foodTapGesture)
        foodStackView.isUserInteractionEnabled = true
        
        let editHeightWeightTapGesture = UITapGestureRecognizer(target: self, action: #selector(editHeightWeightTapped))
        editHeightWeightStackView.addGestureRecognizer(editHeightWeightTapGesture)
        editHeightWeightStackView.isUserInteractionEnabled = true
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(profileTapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        let waterTapGesture =  UITapGestureRecognizer(target: self, action: #selector(waterStackViewTapped))
        waterStackView.addGestureRecognizer(waterTapGesture)
        waterStackView.isUserInteractionEnabled = true
    }
    
    private func getWaterInfo(){
        viewModel.getWaterInfo { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let (totalMl, idealIntakeWater)):
                DispatchQueue.main.async {
                    self.updateWaterIntakeLabel(intakeWater: totalMl, idealIntakeWater: idealIntakeWater)
                }
                
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func foodStackViewTapped(){
        let foodVC = UIStoryboard (name: "Food", bundle: nil).instantiateViewController(withIdentifier: "FoodVC") as! FoodVC
        let foodVM = FoodVM()
        foodVC.viewModel = foodVM
        self.navigationController?.pushViewController(foodVC, animated: true)
    }
    
    @objc func editHeightWeightTapped(){
        let editHeightWeightVC = UIStoryboard (name: "EditHeightWeight", bundle: nil).instantiateViewController(withIdentifier: "EditHeightWeightVC") as! EditHeightWeightVC
        let editHeightWeightVM = EditHeightWeightVM(userId: viewModel.userId)
        editHeightWeightVC.viewModel = editHeightWeightVM
        self.navigationController?.pushViewController(editHeightWeightVC, animated: true)
    }
    
    @objc func profileImageViewTapped(){
        let profileVC = UIStoryboard (name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let profileVM = ProfileVM()
        profileVC.viewModel = profileVM
        profileVM.userModel = viewModel.userModel
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func waterStackViewTapped(){
        let waterVC = UIStoryboard (name: "Water", bundle: nil).instantiateViewController(withIdentifier: "WaterVC") as! WaterVC
        let waterVM = WaterVM()
        let waterModel = WaterModel()
        waterVC.viewModel = waterVM
        waterVM.waterModel = waterModel
        waterVM.userModel = viewModel.userModel
        waterVM.mainDelegate = self
        self.navigationController?.pushViewController(waterVC, animated: true)
    }
    
    private func showLoadingIndicator() {
        
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
    }
}

extension MainVC: MainVCDelegate{
    func updateWaterIntakeLabel(intakeWater: Int, idealIntakeWater: Int) {
        waterIntakeLabel.text = "\(intakeWater) of \(idealIntakeWater) ml"
    }
    
    
    
}

