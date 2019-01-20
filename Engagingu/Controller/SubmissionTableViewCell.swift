//
//  SubmissionTableViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 9/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class SubmissionTableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    
    @IBOutlet weak var photoImage: UIButton!
    @IBOutlet weak var photoImageLabel: UILabel!
    @IBOutlet weak var photoImageQuestionLabel: UILabel!
    
    func setImage(image: Media){
//        photoImage.setImage(UIImage(data: image.data), for: UIControl.State.normal)
        photoImage.setBackgroundImage(UIImage(data: image.data), for: UIControl.State.normal)
        photoImageLabel.text = image.hotspot
        photoImageQuestionLabel.text = image.question
    }

    @IBAction func showPopUp(_ sender: Any) {
        
        self.delegate?.tableViewCell(self, buttonTapped: photoImage)
    }
    
    
}
