//
//  ResultScreenTableViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 12/3/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class ResultScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var userAnswer: UITextView!
    @IBOutlet weak var expectedAnswer: UITextView!
    
    func setOutcome(question: String, userAnswer: String, expectedAnswer: String){
        
        self.question.text = "Q: " + question
        self.userAnswer.text = "A: " + userAnswer
        self.expectedAnswer.text = "A: " + expectedAnswer
        
    }

}
