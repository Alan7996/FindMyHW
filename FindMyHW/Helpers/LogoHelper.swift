//
//  LogoHelper.swift
//  FindMyHW
//
//  Created by 수현 on 8/5/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import Foundation
import UIKit

class LogoHelper {
    static func createLogo (text: String, label: UILabel) {
        label.text = text
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "DimitriSwank", size: 40)
        label.shadowColor = UIColor.lightGrayColor()
        label.shadowOffset = CGSizeMake(2, 2)
    }
}