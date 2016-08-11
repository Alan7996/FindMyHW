//
//  SearchCoursesTableViewCell.swift
//  FindMyHW
//
//  Created by 수현 on 8/2/16.
//  Copyright © 2016 SooHyun Lee. All rights reserved.
//

import UIKit

class SearchCoursesTableViewCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTeacherLabel: UILabel!
    
    var course: Course! {
        didSet {
            courseNameLabel.text = course.name
            
            let courseTeacherTitle = course.teacher!["title"] as! String
            let courseTeacherLastName = course.teacher!["lastName"] as! String
            courseTeacherLabel.text = courseTeacherTitle + courseTeacherLastName
        }
    }
}