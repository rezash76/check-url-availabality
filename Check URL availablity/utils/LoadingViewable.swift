//
//  LoadingViewable.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/3/23.
//

import UIKit


protocol loadingViewable {
    func startLoading ()
    func stopLoading ()
}
extension loadingViewable where Self: UIViewController {
    func startLoading () {
        let indicator = UIActivityIndicatorView(frame: CGRect (x: 0, y: 0, width: 150, height: 150))
        indicator.style = .large
        view.addSubview(indicator)
        view.bringSubviewToFront(indicator)
        indicator.restorationIdentifier = "loadingView"
        indicator.center = view.center
        indicator.layer.cornerRadius = 15
        indicator.clipsToBounds = true
        indicator.startAnimating()
    }
    
    
    func stopLoading() {
        for item in view.subviews where item.restorationIdentifier == "loadingView" {
            UIView.animate(withDuration: 0.3, animations: {
                item.alpha = 0
            }) { (_) in
                item.removeFromSuperview()
            }
        }
    }
}
