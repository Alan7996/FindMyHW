//
//  AlertHelper.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/5/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showAlert(alert: UIAlertView, view: UIView) {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 37, 37)) as UIActivityIndicatorView
        loadingIndicator.center = view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        loadingIndicator.startAnimating()
        
        alert.show()
    }
}