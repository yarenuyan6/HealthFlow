//
//  LoadingOverlay.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 17.12.2023.
//

import Foundation
import UIKit

class LoadingOverlay {
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    class var shared: LoadingOverlay { // Nesne bir defa oluşturuldu, ana instance yalnızca bir örnek oluşturdu ve bu örneğe genel bir eişim sağlandı.
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    func showOverlay(view: UIView) {
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)

        activityIndicator.startAnimating()
    }

    func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
