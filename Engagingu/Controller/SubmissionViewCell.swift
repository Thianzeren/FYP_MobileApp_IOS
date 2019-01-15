//
//  SubmissionViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 9/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class SubmissionViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoImageLabel: UILabel!
    @IBOutlet weak var photoImageQuestionLabel: UILabel!
    
    func setImage(image: Media){
        photoImageView.image = UIImage(data: image.data)
        photoImageLabel.text = image.hotspot
        photoImageQuestionLabel.text = image.question
    }
    
}
