//
//  DeviceUtils.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.11.2023.
//

import Foundation

class DeviceUtils {
    static let shared = DeviceUtils()
    let userKey = "user_key"
    private init (){}
    
    func getUser()->UserModel?{
        guard let userData = UserDefaults.standard.data(forKey: userKey) else {return nil}
        let decoder = JSONDecoder()
        guard let decodedUser = try? decoder.decode(UserModel.self, from: userData) else {return nil}
        return decodedUser
    }
    
    func setUser(user:UserModel){
        let encoder = JSONEncoder()
        guard let encodedUser = try? encoder.encode(user) else {return}
        UserDefaults.standard.setValue(encodedUser, forKey: userKey)
    }
}

