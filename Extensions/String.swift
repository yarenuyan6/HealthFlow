//
//  String.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 13.11.2023.
//

import Foundation

extension String{
    
    func isValidEmail() -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
