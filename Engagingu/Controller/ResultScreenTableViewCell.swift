//
//  ResultScreenTableViewCell.swift
//  Engagingu
//
//  Created by Nicholas on 12/3/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class ResultScreenTableViewCell: UITableViewCell {

    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var userAnswer: UILabel!
    
    @IBOutlet weak var expectedAnswer: UILabel!
    func setOutcome(question: String, userAnswer: String, expectedAnswer: String){
        
        self.question.text = "Question: " + question
        self.userAnswer.text = "Your Answer: " + userAnswer
        self.expectedAnswer.text = "Correct Answer: " + expectedAnswer
        if(userAnswer == expectedAnswer){
            self.userAnswer.textColor = UIColor.green
        }else{
            self.userAnswer.textColor = UIColor.red
        }
        self.expectedAnswer.textColor = UIColor.green
        
        
    }

}
