//
//  FoodTableViewCell.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 29.11.2023.
//

import Foundation
import UIKit

class SelectedFoodTableViewCell: UITableViewCell{
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodCountLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var minusImageView: UIImageView!
    var viewModel: FoodVM!{
        didSet{
            setUpCell()
        }
    }
    var foodCount: Int = 0{
        didSet{
            foodCountLabel.text = String(foodCount)
        }
    }
    var indexPath: Int?
    static let identifier = "SelectedFoodTableViewCell"
    static let nibName = "SelectedFoodTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestures()
    }
    
    func setUpCell(){
        guard let indexPath = indexPath else { return }
        
        if indexPath < viewModel.selectedFoods.count {
            foodNameLabel.text = viewModel.selectedFoods[indexPath].name
            foodCountLabel.text = String(viewModel.selectedFoods[indexPath].count)
           } else {
               
               foodNameLabel.text = ""
               foodCountLabel.text = ""
           }
        
//        foodNameLabel.text = viewModel.selectedFoods[indexPath].name
//        foodCountLabel.text = String(viewModel.selectedFoods[indexPath].count)
    }
    
    func tapGestures(){
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementFunc))
        plusImageView.addGestureRecognizer(plusTapGesture)
        plusImageView.isUserInteractionEnabled = true
        
        let minusTapGesture = UITapGestureRecognizer(target: self, action: #selector(decrementFunc))
        minusImageView.addGestureRecognizer(minusTapGesture)
        minusImageView.isUserInteractionEnabled = true
    }
    
    func addSelectedFood(_ foodModel: FoodModelProtocol) {
        if let existingIndex = viewModel.selectedFoods.firstIndex(where: { $0.name == foodModel.name }) {
            viewModel.selectedFoods[existingIndex].count += 1
            } else {
                let selectedFood = SelectedFoodModel(name: foodModel.name, calories: foodModel.calories, carbohydrate: foodModel.carbohydrate, protein: foodModel.protein, fat: foodModel.fat, photo: foodModel.photo, count: 1, measureUnit: MeasureUnits(measureId: MeasureId.gram, value: 100))
                viewModel.selectedFoods.append(selectedFood)
            }
        viewModel.calculateProgress()
        viewModel.viewInterface?.updateSelectedFoodModelArray(viewModel.selectedFoods)
        viewModel.viewInterface?.setUpProgressViews()
        }
    
    
    func decrementSelectedFood(_ foodModel: FoodModelProtocol) {
        if let existingIndex = viewModel.selectedFoods.firstIndex(where: { $0.name == foodModel.name }) {
            if viewModel.selectedFoods[existingIndex].count > 1 {
                viewModel.selectedFoods[existingIndex].count -= 1
            } else {
                viewModel.selectedFoods.remove(at: existingIndex)
//                viewModel.viewInterface?.deleteTableViewRow(indexPath: existingIndex)
            }
        }
        
        viewModel.calculateProgress()
        viewModel.viewInterface?.updateSelectedFoodModelArray(viewModel.selectedFoods)
        viewModel.viewInterface?.setUpProgressViews()
       
    }
    
    @objc func incrementFunc(){
        guard let indexPath = indexPath else { return }
            viewModel.selectedFoods[indexPath].count += 1
        viewModel.viewInterface?.updateSelectedFoodModelArray(viewModel.selectedFoods)
    }
    
    @objc func decrementFunc(){
        guard let indexPath = indexPath else { return }
        if viewModel.selectedFoods[indexPath].count == 1{
            if let indexToRemove = viewModel.selectedFoods.firstIndex(where: { $0.name == viewModel.selectedFoods[indexPath].name }) {
                viewModel.selectedFoods.remove(at: indexToRemove)
                viewModel.viewInterface?.updateSelectedFoodModelArray(viewModel.selectedFoods)
                
            }
        }else{
            viewModel.selectedFoods[indexPath].count -= 1
        }
        viewModel.viewInterface?.updateSelectedFoodModelArray(viewModel.selectedFoods)
    }
    
}
