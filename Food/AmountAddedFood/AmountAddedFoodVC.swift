//
//  AmoutAddedFoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 8.12.2023.
//

import UIKit
//import DropDown

class AmountAddedFoodVC: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountTypeTextField: UITextField!
    var rightImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setUpTextField(){
        let imageView = UIImageView(image: UIImage(named: "downArrow"))
        imageView.contentMode = .scaleAspectFit
//        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: frame.height)
        rightImageView = imageView
        rightImageView?.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped))
//        rightImageView?.addGestureRecognizer(tapGesture)
        
        
        amountTextField.bringSubviewToFront(rightImageView ?? UIImageView())
        amountTextField.insertSubview(rightImageView ?? UIImageView(), at: 1)
    }

}
