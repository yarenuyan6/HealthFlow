//
//  UserModel.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 18.11.2023.
//

import Foundation

struct UserModel: Codable {
    var name: String
    var lastName: String
    var gender: String?
    var height: Int?
    var weight: Int?
    var birthDate: String?
    var uid: String?
    
//    init(name:String, lastName: String){
//        self.name = name
//        self.lastName = lastName
//    }
}
