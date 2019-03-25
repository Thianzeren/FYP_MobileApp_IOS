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
    
    var greenColor: UIColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
    
    func setOutcome(question: String, userAnswer: String, expectedAnswer: String){
        
        self.question.text = "Question: " + question
        self.userAnswer.text = "Your Answer: " + userAnswer
        self.expectedAnswer.text = "Correct Answer: " + expectedAnswer
        if(userAnswer == expectedAnswer){
            self.userAnswer.textColor = greenColor
        }else{
            self.userAnswer.textColor = UIColor.red
        }
        self.expectedAnswer.textColor = greenColor
        
        
    }

}
