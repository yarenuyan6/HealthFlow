//
//  AmountFoodVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 8.12.2023.
//

import UIKit

class AmountAddedFoodVM: FoodInterface{
    func addSelectedFood(_ food: SelectedFoodModel) {
        
    }
    
    var foodName: String?
    var foodImageUrl: String?
    var amountInterface: AmountAddedFoodInterface?
    
    var selectedFoods: [SelectedFoodModel] = []
    
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    var viewInterface: FoodVCInterface?
    
    var foodCount: Int = 0
    
    var carbsProgress: Double = 0.0
    
    var proteinProgress: Double = 0.0
    
    var fatProgress: Double = 0.0
    
    var foodModelArray: [FoodModel]?
    
    func getFoodModelArray() {
        
    }
    
    func addSelectedFood() {
        
    }
    
    func calculateProgress() {
        
    }
    
//    var amountViewInterface: AmountAddedFoodInterface?
//    
//    func setUpFoodNameLabel(foodName:String){
//        amountViewInterface?.setUpFoodLabel(foodName: foodName)
//    }

}
