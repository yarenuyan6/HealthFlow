//
//  MeasureUnits.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 19.12.2023.
//

import Foundation
enum MeasureId :String, Codable{
    case gram = "Gram"
    case cup = "Cup"
    case unit = "Unit"
}

class MeasureUnits : Codable{
    var measureId : MeasureId
    var value: Int = 0
    init(measureId: MeasureId, value: Int) {
        self.measureId = measureId
        self.value = value
    }
}
