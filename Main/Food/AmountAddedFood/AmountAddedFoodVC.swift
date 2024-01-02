//
//  AmoutAddedFoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 8.12.2023.
//

import UIKit
import Alamofire
import AlamofireImage

protocol AmountAddedFoodInterface{
    func setUpFoodLabel(foodName:String)
}

class AmountAddedFoodVC: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var grButton: UIButton!
    @IBOutlet weak var cupButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var unitButton: UIButton!
    @IBOutlet weak var grStackView: UIStackView!
    @IBOutlet weak var cupStackView: UIStackView!
    @IBOutlet weak var unitStackView: UIStackView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    let imageCache = AutoPurgingImageCache()
    var viewModel: AmountAddedFoodVM!
    //    {
    //        didSet{
    //viewModel.amountInterface = self
    //        }
    //    }
    var buttonId: Int? = 1
    var indexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        tapGestures()
    }
    
    private func setUpUI(){
        grButton.layer.borderColor = UIColor.americanSilver.cgColor
        grButton.layer.borderWidth = 1
        
        cupButton.layer.borderColor = UIColor.americanSilver.cgColor
        cupButton.layer.borderWidth = 1
        
        unitButton.layer.borderColor = UIColor.americanSilver.cgColor
        unitButton.layer.borderWidth = 1
        
        guard let indexPath = self.indexPath else{return}
        self.foodNameLabel.text = viewModel.foodArray?[indexPath].name
        
        guard let foodImageUrl = viewModel.foodArray?[indexPath].photo else {return}
        setFoodImage(imageURL: foodImageUrl)
        
        switch buttonId{
            case 1:
                caloriesLabel.text = "Calories: \(viewModel.foodArray?[indexPath].calories ?? 0)"
                carbsLabel.text = "Carbohydrate: \(viewModel.foodArray?[indexPath].carbohydrate ?? 0)"
                proteinLabel.text = "Protein: \(viewModel.foodArray?[indexPath].protein ?? 0)"
                fatLabel.text = "Fat: \(viewModel.foodArray?[indexPath].fat ?? 0)"
            
            default:
                caloriesLabel.text = "Calories: \(viewModel.foodArray?[indexPath].calories ?? 0)"
                carbsLabel.text = "Carbohydrate: \(viewModel.foodArray?[indexPath].carbohydrate ?? 0)"
                proteinLabel.text = "Protein: \(viewModel.foodArray?[indexPath].protein ?? 0)"
                fatLabel.text = "Fat: \(viewModel.foodArray?[indexPath].fat ?? 0)"
        }
        
    }
    
    func setFoodImage(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        if let cachedImage = imageCache.image(withIdentifier: imageURL) {
            foodImageView.image = cachedImage
        } else {
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let image):
                    self.imageCache.add(image, withIdentifier: imageURL)
                    
                    self.foodImageView.image = image
                    
                case .failure(let error):
                    print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    private func tapGestures(){
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeViewTapped))
        closeImageView.addGestureRecognizer(closeTapGesture)
        closeImageView.isUserInteractionEnabled = true
        
        let grTapGesture = UITapGestureRecognizer(target: self, action: #selector(grButtonTapped))
        grButton.addGestureRecognizer(grTapGesture)
        grButton.isUserInteractionEnabled = true
        
        let cupTapGesture = UITapGestureRecognizer(target: self, action: #selector(cupButtonTapped))
        cupButton.addGestureRecognizer(cupTapGesture)
        cupButton.isUserInteractionEnabled = true
        
        let unitTapGesture = UITapGestureRecognizer(target: self, action: #selector(unitButtonTapped))
        unitButton.addGestureRecognizer(unitTapGesture)
        unitButton.isUserInteractionEnabled = true
    }
    
    @objc private func closeViewTapped(){
        self.dismiss(animated: true)
    }
    
    @objc private func grButtonTapped(){
        buttonId = 1
        grStackView.isHidden = false
        cupStackView.isHidden = true
        unitStackView.isHidden = true
    }
    
    @objc private func cupButtonTapped(){
        buttonId = 2
        grStackView.isHidden = true
        cupStackView.isHidden = false
        unitStackView.isHidden = true
    }
    
    @objc private func unitButtonTapped(){
        buttonId = 3
        grStackView.isHidden = true
        cupStackView.isHidden = true
        unitStackView.isHidden = false
    }
}

