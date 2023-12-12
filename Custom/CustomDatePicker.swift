//
//  CustomDatePicker.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 15.11.2023.
//

import Foundation
import UIKit

class CustomDatePicker: UIDatePicker{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Observer'ı ekleyin
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextColor), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc private func updateTextColor() {
        if let textField = findTextField() {
            textField.textColor = UIColor.red
        }
    }
    
    private func findTextField() -> UITextField? {
        var textField: UITextField?
        
        for subview in self.subviews {
            if let subview = subview as? UITextField {
                textField = subview
                break
            }
        }
        
        return textField
    }
}
