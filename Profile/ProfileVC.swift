//
//  ProfileVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 16.12.2023.
//

import UIKit

class ProfileVC: UIViewController {

   
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var goBackImageView: UIImageView!
    
    var viewModel: ProfileVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        tapGestures()
    }
    
    private func setUpUI(){
        guard let birthDate = viewModel.userModel.birthDate else {return}
        let age = viewModel.calculateAge(from: birthDate)
        nameSurnameLabel.text = "\(viewModel.userModel.name) \( viewModel.userModel.lastName)"
        ageLabel.text = "Age: \(age ?? 0)"
        genderLabel.text = "Gender: \( viewModel.userModel.gender ?? "")"
    }

    private func tapGestures(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackImageViewTapped))
        goBackImageView.addGestureRecognizer(goBackTapGesture)
        goBackImageView.isUserInteractionEnabled = true
    }
    
    @objc func goBackImageViewTapped(){
        self.navigationController?.popViewController(animated: true)
    }
}
