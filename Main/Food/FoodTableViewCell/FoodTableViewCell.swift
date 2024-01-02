//
//  MealTableViewCell.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 30.11.2023.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class FoodTableViewCell: UITableViewCell{
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var nutritionFactsLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var foodImageView: UIImageView!
    var imgUrl: String = ""
    var foodCount: Int = 0
    var viewModel: FoodVM!
    var indexPath: Int?
    static let identifier = "FoodTableViewCell"
    static let nibName = "FoodTableViewCell"
    var delegate: FoodTableViewCellDelegate!
    let imageCache = AutoPurgingImageCache()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestures()
    }
    
    func setUpCell(){
        guard let indexPath = indexPath else { return }
        foodNameLabel.text = viewModel.foodModelArray?[indexPath].name
        
        let calories = viewModel.foodModelArray?[indexPath].calories
        let carbs = viewModel.foodModelArray?[indexPath].carbohydrate
        let protein = viewModel.foodModelArray?[indexPath].protein
        let fat = viewModel.foodModelArray?[indexPath].fat
        nutritionFactsLabel.text = "\(calories ?? 0) Kcal\nProtein:\(protein ?? 0) gr Carbs:\(carbs ?? 0) gr Fat:\(fat ?? 0) gr"
        
        guard let foodImageUrl = viewModel.foodModelArray?[indexPath].photo else {return}
        imgUrl = foodImageUrl
        self.setFoodImage(imageURL: imgUrl)
    }
    
    func tapGestures(){
//        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementFunc))
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToDeterminePage))
        plusImageView.addGestureRecognizer(plusTapGesture)
        plusImageView.isUserInteractionEnabled = true
    }
    
    @objc func goToDeterminePage(){
        delegate.didTapButtonInCell()
        plusImageView.image = UIImage(named: "check")
        
        
    }
    
    func setFoodImage(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        foodImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"), completion: { response in
                    switch response.result {
                    case .success(let image):
                        self.imageCache.add(image, withIdentifier: imageURL)
                    case .failure(let error):
                        print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                    }
                })
            }
    
    @objc func incrementFunc(){
        foodCount += 1
        viewModel.foodCount = foodCount
        guard let indexPath = indexPath, let selectedModel = viewModel.foodModelArray?[indexPath] else { return }
        addSelectedFood(selectedModel)
        plusImageView.image = UIImage(named: "check")
    }

    func addSelectedFood(_ foodModel: FoodModelProtocol) {
        if let existingIndex = viewModel.tempSelectedFoods.firstIndex(where: { $0.name == foodModel.name })
        {
            viewModel.tempSelectedFoods[existingIndex].count += 1
        }
        else {
            let selectedFood = SelectedFoodModel(name: foodModel.name, calories: foodModel.calories, carbohydrate: foodModel.carbohydrate, protein: foodModel.protein, fat: foodModel.fat, photo: foodModel.photo, count: 1, measureUnit: MeasureUnits(measureId: MeasureId.gram, value: 100))
            viewModel.tempSelectedFoods.append(selectedFood)
        }
    }
}

