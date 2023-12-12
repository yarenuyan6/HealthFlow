//
//  CustomButton.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 18.11.2023.
//

import Foundation
import UIKit

enum ButtonTypes:Int {
    case whiteButton //0
    case blueButton //1
}

class CustomButton: UIButton {
    var buttonTypes: ButtonTypes!
    
    @IBInspectable var buttonTypesRawValue: Int {
        get {
            return buttonTypes.rawValue
        }
        set {
            if let buttonType = ButtonTypes(rawValue: newValue) {
                buttonTypes = buttonType
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setUpButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isEnabled = false
    }
    
    private func setUpButton(){
        switch buttonTypes {
        case .whiteButton:
            if isEnabled {
                self.alpha = 1
            }
        
        case .blueButton:
            if isEnabled {
                self.backgroundColor = UIColor.celticBlue
                self.tintColor = UIColor.whiteOwn
            }
    
            else{
                self.backgroundColor = UIColor.americanSilver
                self.tintColor = UIColor.blackOwn
            }
        case .none:
            break
        }
    }
}
