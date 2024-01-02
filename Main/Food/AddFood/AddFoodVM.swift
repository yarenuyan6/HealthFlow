//
//  AddFoodVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 4.12.2023.
//

import Foundation
//protocol AddFoodVMInterface{
//    var foodModelArray: [FoodModel]? { get set }
//    var selectedFoodModelArray: [FoodModel] { get set }
//    var selectedFoods: [SelectedFoodModel] { get set }
//    func getFoodModelArray()
//    func addSelectedFood()
//    func addFood(_ food: FoodModel)
//}

class AddFoodVM{
    var viewInterface: FoodVCInterface?
    var selectedFoods: [SelectedFoodModel] = []
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    
    func addSelectedFood(_ food: SelectedFoodModel) {
        let existingFoodIndex = selectedFoods.firstIndex { $0.name == food.name }
        
        if let index = existingFoodIndex {
            selectedFoods[index].count += food.count
        } else {
            selectedFoods.append(food)
        }
        viewInterface?.updateSelectedFoodModelArray(self.selectedFoods)
        tempSelectedFoods.removeAll()
    }
    
    func addSelectedFood() {
        for tempFood in tempSelectedFoods {
            addSelectedFood(tempFood)
        }
    }
//    
//    func setUpFoodNameLabel(foodName: String) {
//        
//    }
//    
//    var amountInterface: AmountAddedFoodInterface?
//    
//    var tempSelectedFoods: [SelectedFoodModel] = []
//    
//    func calculateProgress() {
//        
//    }
    //[[FoodModel]] -> bu şekilde öğünleri tutabilirsin bunun count'u 4 olur.
      
    var foodModelArray: [FoodModel]?

    func getFoodModelArray() {
        self.foodModelArray = OnboardingVC.foodsArray
    }
}

