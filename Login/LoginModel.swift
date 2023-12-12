//
//  LoginModel.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 27.11.2023.
//

import Foundation

class LoginModel{
    var email: String!
    var password: String!
    
    init(email: String, password:String){
        self.email = email
        self.password = password
    }
}
