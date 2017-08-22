//
//  UIViewController.swift
//  GoogleMapWeatherApp
//
//  Created by ashika kalmady on 18/08/17.
//  Copyright © 2017 ashika kalmady. All rights reserved.
//

import UIKit
import QuartzCore

extension UIViewController {

    //shows , remove activity indicator
    
    func loadingIndicator(_ show: Bool) {
        
        let tag = 123
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.color = UIColor.gray
        if show {
            self.view.isUserInteractionEnabled = false
            //increase size of activity indicator
            indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            indicator.center = self.view.center
            indicator.tag = tag
            self.view.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.view.isUserInteractionEnabled = true
           
            if let indicator = self.view.viewWithTag(123) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
            
        }
    }

    
}
