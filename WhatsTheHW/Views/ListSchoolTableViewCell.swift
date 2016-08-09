//
//  ListSchoolTableViewCell.swift
//  WhatsTheHW
//
//  Created by 수현 on 8/4/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import Parse

class ListSchoolTableViewCell: UITableViewCell {
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var schoolAddressLabel: UILabel!
    
    var school: School! {
        didSet {
            schoolNameLabel.text = school.schoolName
            
            let schoolAddress = school.cityName! + ", " + school.country!
            
            schoolAddressLabel.text = schoolAddress
        }
    }
}