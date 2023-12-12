//
//  GradientView.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 14.11.2023.
//

import Foundation
import UIKit

class GradientView: UIView{
    override class var layerClass: AnyClass {
         return CAGradientLayer.self
     }

     override func layoutSubviews() {
         super.layoutSubviews()
         if let layer = layer as? CAGradientLayer {
             // Gradient renklerini ve özelliklerini burada ayarlayabilirsiniz
             layer.colors = [UIColor.blueberry.cgColor, UIColor.white.cgColor]
             layer.startPoint = CGPoint(x: 1.0, y: 0.5)
             layer.endPoint = CGPoint(x: 1.0, y: 1.0)
         }
     }
}
