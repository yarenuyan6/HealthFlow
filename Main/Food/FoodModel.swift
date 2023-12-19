//
//  FoodModel.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 1.12.2023.
//

import Foundation

protocol FoodModelProtocol: Codable {
    var name: String { get }
    var calories: Double { get }
    var carbohydrate: Double { get }
    var protein: Double { get }
    var fat: Double { get }
    var photo: String { get }
}

extension FoodModelProtocol {
    var count: Int {
        return 0
    }
}

struct FoodModel: FoodModelProtocol {
    let name: String
    let calories: Double
    let carbohydrate: Double
    let protein: Double
    let fat: Double
    let photo: String
}

struct SelectedFoodModel: FoodModelProtocol {
    let name: String
    let calories: Double
    let carbohydrate: Double
    let protein: Double
    let fat: Double
    let photo: String
    var count: Int
    var measureUnit: MeasureUnits
}
