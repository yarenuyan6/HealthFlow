//
//  ViewController.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 12.11.2023.
//

import UIKit

class MainVC: UIViewController {
    
    var viewModel: MainVM!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var greetingsImageView: UIImageView!
    @IBOutlet weak var waterStackView: UIStackView!
    @IBOutlet weak var foodStackView: UIStackView!
    
    
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
        viewModel.getUserInfo{ user, error in
            DispatchQueue.main.async {
                        if let user = user {
                            self.nameLabel.text = user.name
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(foodStackViewTapped))
        foodStackView.addGestureRecognizer(tapGesture)
        foodStackView.isUserInteractionEnabled = true
    }
    
    @objc func foodStackViewTapped(){
        let foodVC = UIStoryboard (name: "Food", bundle: nil).instantiateViewController(withIdentifier: "FoodVC") as! FoodVC
        let foodVM = FoodVM()
        foodVC.viewModel = foodVM
        self.navigationController?.pushViewController(foodVC, animated: true)
    }
}

