//
//  AddFoodVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 4.12.2023.
//

import Foundation
protocol AddFoodVMInterface{
    var foodModelArray: [FoodModel]? { get set }
    var selectedFoodModelArray: [FoodModel] { get set }
    var selectedFoods: [SelectedFoodModel] { get set }
    func getFoodModelArray()
    func addSelectedFood()
    func addFood(_ food: FoodModel)
}

class AddFoodVM: FoodInterface{
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
    
    func setUpFoodNameLabel(foodName: String) {
        
    }
    
    var amountInterface: AmountAddedFoodInterface?
    
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    func calculateProgress() {
        
    }
    
    // Düşün! Oku! 777
    //[[FoodModel]] -> bu şekilde öğünleri tutabilirsin bunun count'u 4 olur.
    
    
    var viewInterface: FoodVCInterface?
    
    var foodCount: Int = 0
    
    var carbsProgress: Double = 0.0
    
    var proteinProgress: Double = 0.0
    
    var fatProgress: Double = 0.0
    
    var foodModelArray: [FoodModel]?
    
    var selectedFoodModelArray: [SelectedFoodModel] = []
    
    var selectedFoods: [SelectedFoodModel] = []
    
    func getFoodModelArray() {
        self.foodModelArray = OnboardingVC.foodsArray
    }
    
    func addFood(_ food: SelectedFoodModel){
        selectedFoodModelArray.append(food)
        self.viewInterface?.updateSelectedFoodModelArray(selectedFoodModelArray)
    }
}
/*


 */
