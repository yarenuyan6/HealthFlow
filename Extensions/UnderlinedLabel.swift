//
//  UILabel.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 14.11.2023.
//

import Foundation
import UIKit

class UnderlinedLabel : UILabel{
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            self.attributedText = attributedText
        }
    }
}
