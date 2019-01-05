//
//  QuizViewController.swift
//  Engagingu
//
//  Created by Nicholas on 13/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

struct Quiz: Decodable{
    let quiz_question: String
    let quiz_answer: Int
    let quiz_options: [String]
}

class QuizViewController: UIViewController {

    //@IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var question: UITextView!
    
    // Outlet for buttons
    /*
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    */
    
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    
    // Outlet for Squares to change colour
    /*
    @IBOutlet weak var firstAnswerSquare: UIView!
    @IBOutlet weak var secondAnswerSquare: UIView!
    @IBOutlet weak var thirdAnswerSquare: UIView!
    @IBOutlet weak var fourthAnswerSquare: UIView!
    */
    // Outlet for confirm text of right or wrong answer
    @IBOutlet weak var confirmText: UITextView!
    // Outlet for confirm button
    @IBOutlet weak var confirmButton: UIButton!
    // Outlet for Q&A
    @IBOutlet weak var questionLabel: UILabel!
    
    
    var questionBank: [HotspotQuiz.Quiz] = []
    var hotspot: String = ""
    var questionNumber: Int = 0
    var score: Int = 0
    
    // Question's correct answer variables
    var questionAnswer: Int = 0
    
    // Selected answer variables
    var selectedAnswer: Int = 0
    
    // Variable to check if he hasSeenCorrectAnswer
    var hasSeenCorrectAnswer = false
    
    override func viewDidLoad() {

        //topNavBar.topItem!.title = "Engaging U"
        
        firstAnswer.setTitle(nil, for: .normal)
        secondAnswer.setTitle(nil, for: .normal)
        thirdAnswer.setTitle(nil, for: .normal)
        fourthAnswer.setTitle(nil, for: .normal)
        
        // Initialise question bank
        questionBank = InstanceDAO.quizDict[hotspot]!.quiz
        
        // Initialise 1st question
        updateQuiz()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func selectFirstAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 1
        
        // Change colour of highlight text
        //firstAnswer.setTitleColor(UIColor.green, for: .normal)
        firstAnswer.backgroundColor = UIColor.green
        // Change colour of answer square
        //firstAnswerSquare.backgroundColor = UIColor.green
        
        // Change other button text to nil
        /*
        secondAnswer.setTitleColor(nil, for: .normal)
        thirdAnswer.setTitleColor(nil, for: .normal)
        fourthAnswer.setTitleColor(nil, for: .normal)
         */
        //change the other button background to grey
        secondAnswer.backgroundColor = UIColor.lightGray
        thirdAnswer.backgroundColor = UIColor.lightGray
        fourthAnswer.backgroundColor = UIColor.lightGray
        /*
        secondAnswerSquare.backgroundColor = UIColor.black
        thirdAnswerSquare.backgroundColor = UIColor.black
        fourthAnswerSquare.backgroundColor = UIColor.black
        */
    }
    
    @IBAction func selectSecondAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 2
        
        // Change colour of highlight text
        //secondAnswer.setTitleColor(UIColor.green, for: .normal)
        secondAnswer.backgroundColor = UIColor.green
        // Change colour of answer square
        //secondAnswerSquare.backgroundColor = UIColor.green
        
        // Change other button text colours to default
        /*
        firstAnswer.setTitleColor(nil, for: .normal)
        thirdAnswer.setTitleColor(nil, for: .normal)
        fourthAnswer.setTitleColor(nil, for: .normal)
         */
        firstAnswer.backgroundColor = UIColor.lightGray
        thirdAnswer.backgroundColor = UIColor.lightGray
        fourthAnswer.backgroundColor = UIColor.lightGray
        /*
        firstAnswerSquare.backgroundColor = UIColor.black
        thirdAnswerSquare.backgroundColor = UIColor.black
        fourthAnswerSquare.backgroundColor = UIColor.black
         */
    }
    
    @IBAction func selectThirdAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 3
        
        // Change colour of highlight text
        //thirdAnswer.setTitleColor(UIColor.green, for: .normal)
        thirdAnswer.backgroundColor = UIColor.green
        // Change colour of answer square
        //thirdAnswerSquare.backgroundColor = UIColor.green
        
        // Change other button colours to nil
        /*
        firstAnswer.setTitleColor(nil, for: .normal)
        secondAnswer.setTitleColor(nil, for: .normal)
        fourthAnswer.setTitleColor(nil, for: .normal)
         */
        secondAnswer.backgroundColor = UIColor.lightGray
        firstAnswer.backgroundColor = UIColor.lightGray
        fourthAnswer.backgroundColor = UIColor.lightGray
        /*
        firstAnswerSquare.backgroundColor = UIColor.black
        secondAnswerSquare.backgroundColor = UIColor.black
        fourthAnswerSquare.backgroundColor = UIColor.black
        */
    }
    
    @IBAction func selectFourthAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 4
        
        // Change colour of highlight text
        //fourthAnswer.setTitleColor(UIColor.green, for: .normal)
        fourthAnswer.backgroundColor = UIColor.green
        // Change colour of answer square
        //fourthAnswerSquare.backgroundColor = UIColor.green
        
        // Change other button colours to nil
        /*
        firstAnswer.setTitleColor(nil, for: .normal)
        secondAnswer.setTitleColor(nil, for: .normal)
        thirdAnswer.setTitleColor(nil, for: .normal)
        */
        secondAnswer.backgroundColor = UIColor.lightGray
        thirdAnswer.backgroundColor = UIColor.lightGray
        firstAnswer.backgroundColor = UIColor.lightGray
        /*
        firstAnswerSquare.backgroundColor = UIColor.black
        secondAnswerSquare.backgroundColor = UIColor.black
        thirdAnswerSquare.backgroundColor = UIColor.black
        */
    }
    
    func updateQuiz(){
        let quiz: HotspotQuiz.Quiz = questionBank[questionNumber]
        let quiz_question: String = quiz.quiz_question
        let quiz_options: [String] = quiz.quiz_options
        let quiz_answer: Int = quiz.quiz_answer
        
        print(quiz)
        print(quiz_question)
        print(quiz_options)
        print(quiz_answer)
        
        question.text = quiz_question

        var count: Int = 0
        for option in quiz_options{
            
            if(count==0){
                firstAnswer.setTitle(option, for: .normal)
            }else if(count==1){
                secondAnswer.setTitle(option, for: .normal)
            }else if(count==2){
                thirdAnswer.setTitle(option, for: .normal)
                //celine added this one line below
                fourthAnswer.isHidden = true
            }else{
                //celine added this one line below
                fourthAnswer.isHidden = false
                fourthAnswer.setTitle(option, for: .normal)
            }
            
            count += 1
            
        }
        
        //set question correct answer variables
        questionAnswer = quiz_answer
        
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        
        // Submit button has 4 situations:
        // 1) if he/she has seen the result page, button redirects to map
        // 2) if it is the last question, and correct answer already shown, show final result page
        // 3) if he/she has seen the correct answer, reset colors and update score, question and options
        // 4) if he/she hasn't submitted answer, show correct answer
        
        if (confirmButton.title(for: .normal) == "Complete Quiz"){
            //Post results to server
            
            var resultDict: [String: String] = ["team_id": InstanceDAO.team_id]
            resultDict["trail_instance_id"] = InstanceDAO.trail_instance_id
            resultDict["score"] = String(score)
            resultDict["hotspot"] = hotspot
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: resultDict) else { return
                print("Error: cannot create jsonData")
            }
            
            let urlStr = "http://54.255.245.23:3000/team/updateScore"
            RestAPIManager.asyncHttpPost(jsonData: jsonData, URLStr: urlStr)
            
            InstanceDAO.completedList.append(hotspot)
            
            //Perform segue
            performSegue(withIdentifier: "toTabBarSegue", sender: nil)
            
        }else if(questionNumber == questionBank.count - 1 && hasSeenCorrectAnswer){
            // Hide answer buttons and squares
            firstAnswer.isHidden = true
            secondAnswer.isHidden = true
            thirdAnswer.isHidden = true
            fourthAnswer.isHidden = true
            /*
            firstAnswerSquare.isHidden = true
            secondAnswerSquare.isHidden = true
            thirdAnswerSquare.isHidden = true
            fourthAnswerSquare.isHidden = true
            */
            // Change button text to "Complete Quiz"
            confirmButton.setTitle("Complete Quiz", for: .normal)
            confirmText.text = nil
            
            // Display final score
            let numOfQuestions = questionBank.count
            let congratsText = "Congratulations, you got " + String(score) + "/" + String(numOfQuestions) + " Correct!"
            question.text = congratsText
            
            //hide Q&A label
            questionLabel.isHidden = true
            
        }else if(hasSeenCorrectAnswer){
            
            questionNumber += 1

            //Reset choice colors
            /*
            firstAnswer.setTitleColor(nil, for: .normal)
            secondAnswer.setTitleColor(nil, for: .normal)
            thirdAnswer.setTitleColor(nil, for: .normal)
            fourthAnswer.setTitleColor(nil, for: .normal)
             */
            firstAnswer.backgroundColor = UIColor.lightGray
            secondAnswer.backgroundColor = UIColor.lightGray
            thirdAnswer.backgroundColor = UIColor.lightGray
            fourthAnswer.backgroundColor = UIColor.lightGray
            /*
            firstAnswerSquare.backgroundColor = UIColor.black
            secondAnswerSquare.backgroundColor = UIColor.black
            thirdAnswerSquare.backgroundColor = UIColor.black
            fourthAnswerSquare.backgroundColor = UIColor.black
            */
            updateQuiz()
            
            hasSeenCorrectAnswer = false
            
            confirmText.text = nil
            confirmButton.setTitle("Confirm Answer", for: .normal)

        }else{
            
            if(selectedAnswer == questionAnswer){
                
                score += 1
                
                confirmText.text = "Correct"
                confirmText.textColor = UIColor.green
            }else{
                
                if(selectedAnswer == 1){
                    //firstAnswer.setTitleColor(UIColor.red, for: .normal)
                    firstAnswer.backgroundColor = UIColor.red
                    //firstAnswerSquare.backgroundColor = UIColor.red
                    
                }else if(selectedAnswer == 2){
                    //secondAnswer.setTitleColor(UIColor.red, for: .normal)
                    secondAnswer.backgroundColor = UIColor.red
                    //secondAnswerSquare.backgroundColor = UIColor.red
                    
                }else if(selectedAnswer == 3){
                    //thirdAnswer.setTitleColor(UIColor.red, for: .normal)
                    thirdAnswer.backgroundColor = UIColor.red
                    //thirdAnswerSquare.backgroundColor = UIColor.red
                    
                }else{
                    //fourthAnswer.setTitleColor(UIColor.red, for: .normal)
                    fourthAnswer.backgroundColor = UIColor.red
                    //fourthAnswerSquare.backgroundColor = UIColor.red
                }
                
                //show the correct ans in green
                if(questionAnswer == 1){
                    //firstAnswer.setTitleColor(UIColor.green, for: .normal)
                    firstAnswer.backgroundColor = UIColor.green
                    //firstAnswerSquare.backgroundColor = UIColor.green
                }else if(questionAnswer == 2){
                    //secondAnswer.setTitleColor(UIColor.green, for: .normal)
                    secondAnswer.backgroundColor = UIColor.green
                    //secondAnswerSquare.backgroundColor = UIColor.green
                }else if(questionAnswer == 3){
                    //thirdAnswer.setTitleColor(UIColor.green, for: .normal)
                    thirdAnswer.backgroundColor = UIColor.green
                    //thirdAnswerSquare.backgroundColor = UIColor.green
                }else{
                    //fourthAnswer.setTitleColor(UIColor.green, for: .normal)
                    fourthAnswer.backgroundColor = UIColor.green
                   // fourthAnswerSquare.backgroundColor = UIColor.green
                }
                
                confirmText.text = "Incorrect"
                confirmText.textColor = UIColor.red
                
            }
            
            confirmButton.setTitle("Next Question", for: .normal)
            hasSeenCorrectAnswer = true

        }
        
    }
    
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button tapped")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
