//  SubmissionTableViewCell.swift
//  Engagingu
import UIKit
//SUbmissionTableViewCell initialise the rows
class SubmissionTableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    @IBOutlet weak var photoImage: UIButton!
    @IBOutlet weak var photoImageLabel: UILabel!
    @IBOutlet weak var photoImageQuestionLabel: UILabel!
    //initialise the image,hotspot name and mission questions
    func setImage(image: Media){
        photoImage.setBackgroundImage(UIImage(data: image.data), for: UIControl.State.normal)
        photoImageLabel.text = image.hotspot
        photoImageQuestionLabel.text = image.question
    }
    
    @IBAction func showPopUp(_ sender: Any) {
        print("Image Button is clicked")
        self.delegate?.tableViewCell(self, buttonTapped: photoImage)
        
    }
    
    
}
