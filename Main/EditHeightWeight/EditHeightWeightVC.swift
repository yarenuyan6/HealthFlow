//
//  EditHeightWeightVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 15.12.2023.
//

import UIKit

class EditHeightWeightVC: UIViewController {

    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    var viewModel: EditHeightWeightVM!
    @IBOutlet weak var goBackImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGestures()
    }


    private func tapGestures(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackImageViewTapped))
        goBackImageView.addGestureRecognizer(goBackTapGesture)
        goBackImageView.isUserInteractionEnabled = true
    }
    
    @objc func goBackImageViewTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {

        let height = Int(heightTextField.text ?? "")
        let weight = Int(weightTextField.text ?? "")
        
        if height != nil {
            viewModel.updateHeight(height: height ?? 0)
        }
        
        if weight != nil {
            viewModel.updateWeight(weight: weight ?? 0)
        }
        
    }
    
}
