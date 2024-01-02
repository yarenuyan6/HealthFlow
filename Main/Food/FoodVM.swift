//
//  FoodVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 1.12.2023.
//

import Foundation
import Firebase

protocol FoodInterface{
    var viewInterface: FoodVCInterface? { get set }
//    var foodCount: Int { get set}
//    var carbsProgress: Double { get set }
//    var proteinProgress:  Double { get set }
//    var fatProgress: Double {get set}
//    var foodModelArray: [FoodModel]? { get set }
//    var selectedFoods: [SelectedFoodModel] { get set }
//    var tempSelectedFoods: [SelectedFoodModel] { get set }
    func addSelectedFood(_ food: SelectedFoodModel)
    func calculateProgress()
}

class FoodVM:FoodInterface{
    var viewInterface: FoodVCInterface?
    var foodModelArray: [FoodModel]?
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    var foodCount: Int = 0
    
    var selectedFoods: [SelectedFoodModel] = [] {
        didSet{
            calculateProgress()
        }
    }
    
    var carbsProgress: Double = 0{
        didSet{
            viewInterface?.setUpProgressViews()
        }
    }
    
    var proteinProgress: Double = 0{
        didSet{
            viewInterface?.setUpProgressViews()
        }
    }
    
    var fatProgress: Double = 0{
        didSet{
            viewInterface?.setUpProgressViews()
        }
    }


    func getFoodModelArray() {
        self.foodModelArray = OnboardingVC.foodsArray
    }

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

    func calculateProgress(){
        
        var totalCarbs: Double = 0.0
        var totalProtein: Double = 0.0
        var totalFat: Double = 0.0

        for food in self.selectedFoods {
            totalCarbs += food.carbohydrate * Double(food.count)
            totalProtein += food.protein * Double(food.count)
            totalFat += food.fat * Double(food.count)
        }

        carbsProgress = totalCarbs / 100
        proteinProgress = totalProtein / 100
        fatProgress = totalFat / 100
    
    }
}
