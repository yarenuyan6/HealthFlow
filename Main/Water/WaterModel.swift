//
//  WaterModel.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.12.2023.
//

import Foundation
import Firebase

struct WaterModel: Codable{
    var millilitre: Int
    var date: Date?
    var totalMl: Int?
    var idealWater: Double?
    init(data: [String : Any] ) {
        let timestamp = data["date"] as? Timestamp
        date = timestamp?.toDate()
        totalMl = data["totalMl"] as? Int
        millilitre = data["millilitre"] as? Int ?? 0 
        idealWater = data["idealWater"] as? Double ?? 0
    }
    
    init(){
        millilitre = 0
    }
}


