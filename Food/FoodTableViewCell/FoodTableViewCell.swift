//
//  MealTableViewCell.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 30.11.2023.
//

import Foundation
import UIKit

class FoodTableViewCell: UITableViewCell{
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var nutritionFactsLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    var foodCount: Int = 0
    var viewModel: FoodInterface!{
        didSet{
            setUpCell()
        }
    }
    var indexPath: Int?
    static let identifier = "FoodTableViewCell"
    static let nibName = "FoodTableViewCell"
    var delegate: FoodTableViewCellDelegate!
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
    }
    
    func tapGestures(){
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToDeterminePage))
        plusImageView.addGestureRecognizer(plusTapGesture)
        plusImageView.isUserInteractionEnabled = true
    }
    
    @objc func goToDeterminePage(){
        delegate.didTapButtonInCell()
        
    }
    
//    @objc func incrementFunc(){
//        foodCount += 1
//        viewModel.foodCount = foodCount
//        guard let indexPath = indexPath, let selectedModel = viewModel.foodModelArray?[indexPath] else { return }
//        addSelectedFood(selectedModel)
//    }
//
//    func addSelectedFood(_ foodModel: FoodModelProtocol) {
//        if let existingIndex = viewModel.tempSelectedFoods.firstIndex(where: { $0.name == foodModel.name })
//        {
//            viewModel.tempSelectedFoods[existingIndex].count += 1
//        }
//        else {
//            let selectedFood = SelectedFoodModel(name: foodModel.name, calories: foodModel.calories, carbohydrate: foodModel.carbohydrate, protein: foodModel.protein, fat: foodModel.fat, photo: foodModel.photo, count: 1)
//            viewModel.tempSelectedFoods.append(selectedFood)
//        }
//    }
}

