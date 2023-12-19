//
//  ProfileVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 16.12.2023.
//

import Foundation

class ProfileVM{
    var userModel: UserModel!
    
    func calculateAge(from dateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let birthDate = dateFormatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: birthDate, to: currentDate)
            
            return components.year ?? 0
        }
        
        return nil
    }
}
