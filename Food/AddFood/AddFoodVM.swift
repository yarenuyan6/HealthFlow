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
    var tempSelectedFoods: [SelectedFoodModel] = []
    
    func calculateProgress() {
        
    }
    
    
    // Buraya geçici olarak seçilen besinleri tutacak bir array ekle
    // FoodTableViewCell içerisinde direkt olarak FoodVM'deki selected array'i artıran bir fonksiyon var bunu engellemen lazım. Ya cell'i değiştir ya da ekstra bir pametre ekle
    // Düşün! Oku! 777
    //[[FoodModel]] -> bu şekilde öğünleri tutabilirsin bunun count'u 4 olur.
    
    func addSelectedFood() {
        
    }
    
    
    var viewInterface: FoodVCInterface?
    
    var foodCount: Int = 0
    
    var carbsProgress: Double = 0.0
    
    var proteinProgress: Double = 0.0
    
    var fatProgress: Double = 0.0
    
    var foodModelArray: [FoodModel]?
    
    var selectedFoodModelArray: [SelectedFoodModel] = []
    
    var selectedFoods: [SelectedFoodModel] = []
    
    func getFoodModelArray() {
        //Firebase'den çekilecek
        self.foodModelArray = OnboardingVC.foodsArray
    }
    
    func addFood(_ food: FoodModel){
//        selectedFoodModelArray.append(food)
//        self.viewInterface?.updateSelectedFoodModelArray(selectedFoodModelArray)
    }
}
/*


 */
