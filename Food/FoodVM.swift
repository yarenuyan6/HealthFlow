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
    var foodCount: Int { get set}
    var carbsProgress: Double { get set }
    var proteinProgress:  Double { get set }
    var fatProgress: Double {get set}
    var foodModelArray: [FoodModel]? { get set }
    var selectedFoods: [SelectedFoodModel] { get set }
    var tempSelectedFoods: [SelectedFoodModel] { get set }
    func getFoodModelArray()
    func addSelectedFood()
    func calculateProgress()
}

class FoodVM: FoodInterface{
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    var foodCount: Int = 0

    var selectedFoodModelArray: [SelectedFoodModel] = []
    
    var selectedFoods: [SelectedFoodModel] = [] {
        didSet{
            calculateProgress()
        }
    }
    var foodModelArray: [FoodModel]?
    var viewInterface: FoodVCInterface?
    
    func addSelectedFood(){
        for tempFood in tempSelectedFoods {
            let existingFoodIndex = selectedFoods.firstIndex { $0.name == tempFood.name }

            if let index = existingFoodIndex {
                selectedFoods[index].count += tempFood.count
            } else {
                selectedFoods.append(tempFood)
            }
        }
        viewInterface?.updateSelectedFoodModelArray(self.selectedFoods)
        tempSelectedFoods.removeAll()
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

    func calculateProgress(){
//        let carbonHydrate = self.selectedFoods.map({ $0.carbohydrate }).reduce(0.0, +)
//        carbsProggress = (carbonHydrate) / 100
//        
//        let protein = self.selectedFoods.map({ $0.protein }).reduce(0.0, +)
//        proteinProgress = (protein) / 100
//        
//        let fat = self.selectedFoods.map({ $0.fat }).reduce(0.0, +)
//        fatProgress = (fat) / 100
        
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
