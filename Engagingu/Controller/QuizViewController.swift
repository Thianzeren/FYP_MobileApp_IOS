//
//  QuizViewController.swift
//  Engagingu
//
//  Created by Nicholas on 13/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    //@IBOutlet weak var topNavBar: UINavigationBar!
    //@IBOutlet weak var question: UITextView!
    
    @IBOutlet weak var question: UILabel!
   // @IBOutlet weak var questionViewHC : NSLayoutConstraint!
    
    // Outlet for buttons
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    
    // Outlet for confirm text of right or wrong answer
    @IBOutlet weak var confirmText: UITextView!
    // Outlet for confirm button
    @IBOutlet weak var confirmButton: UIButton!
    
    //back button for member
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // UIColor
    var greenColor: UIColor = UIColor(red: 146/255, green: 208/255, blue: 80/255, alpha: 0.7)
    var redColor: UIColor = UIColor(red: 232/255, green: 88/255, blue: 88/255, alpha: 0.7)
    var silver: UIColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
    
    var questionBank: [Quiz] = []
    var hotspot: String = ""
    var questionNumber: Int = 0
    var score: Int = 0
    // var numOfCorrect: Int = 0
    
    // Store question and answers of user
    var outcomeArr: [Outcome] = []
    
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
        firstAnswer.backgroundColor = silver
        secondAnswer.backgroundColor = silver
        thirdAnswer.backgroundColor = silver
        fourthAnswer.backgroundColor = silver
        confirmButton.float()
        
        if (!InstanceDAO.isLeader){
            //member
            firstAnswer.isUserInteractionEnabled = false
            secondAnswer.isUserInteractionEnabled = false
            thirdAnswer.isUserInteractionEnabled = false
            fourthAnswer.isUserInteractionEnabled = false
            confirmButton.setTitle("Next Question", for: .normal)
            
        }else{
            //leader cant see back button
            backButton.isEnabled = false
            backButton.tintColor = UIColor.clear

        }
        
        // Initialise question bank
        questionBank = InstanceDAO.quizDict[hotspot]!.quiz
        
        // Initialise 1st question
        updateQuiz()
        
        if(questionNumber == questionBank.count - 1){
            confirmButton.setTitle("Home", for: .normal)
        }
        super.viewDidLoad()
        
        //Self adjust the height of the question
        //questionViewHC.constant = self.question.contentSize.height
        
       
    }
    
   
    @IBAction func selectFirstAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 1
        
        // Change colour of highlight text
        firstAnswer.backgroundColor = greenColor
        
        //change the other button background to grey
        secondAnswer.backgroundColor = silver
        thirdAnswer.backgroundColor = silver
        fourthAnswer.backgroundColor = silver

    }
    
    @IBAction func selectSecondAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 2
        
        // Change colour of highlight text
        secondAnswer.backgroundColor = greenColor
        
        // Change other button text colours to default
        firstAnswer.backgroundColor = silver
        thirdAnswer.backgroundColor = silver
        fourthAnswer.backgroundColor = silver
    }
    
    @IBAction func selectThirdAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 3
        
        // Change colour of highlight text
        thirdAnswer.backgroundColor = greenColor

        // Change other button colours to nil
        secondAnswer.backgroundColor = silver
        firstAnswer.backgroundColor = silver
        fourthAnswer.backgroundColor = silver

    }
    
    @IBAction func selectFourthAnswer(_ sender: Any) {
        // Change selected Answer
        selectedAnswer = 4
        
        // Change colour of highlight text
        fourthAnswer.backgroundColor = greenColor

        // Change other button colours to nil

        secondAnswer.backgroundColor = silver
        thirdAnswer.backgroundColor = silver
        firstAnswer.backgroundColor = silver

    }
    
    func updateQuiz(){
        let quiz = questionBank[questionNumber]
        let quiz_question: String = quiz.quiz_question
        let quiz_options: [String] = quiz.quiz_options
        let quiz_answer: Int = quiz.quiz_answer
        
//        print(quiz)
//        print(quiz_question)
//        print(quiz_options)
//        print(quiz_answer)
        
        self.question.text = quiz_question

        var count: Int = 0
        for option in quiz_options{
            
            if(count==0){
                firstAnswer.setTitle(option, for: .normal)
            }else if(count==1){
                secondAnswer.setTitle(option, for: .normal)
            }else if(count==2){
                thirdAnswer.setTitle(option, for: .normal)
                //Hide fourth answer if theres only 3
                fourthAnswer.isHidden = true
            }else{
                //Unhide fourth answer if more than 3
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
        // 0) check if isLeader
        // 1) if he/she has seen the result page, button redirects to map
        // 2) if it is the last question, and correct answer already shown, show final result page
        // 3) if he/she has seen the correct answer, reset colors and update score, question and options
        // 4) if he/she hasn't submitted answer, show correct answer
        if (InstanceDAO.isLeader){
            
//            if (confirmButton.title(for: .normal) == "Complete Quiz"){
//
//                //Perform segue
//                performSegue(withIdentifier: "toTabBarSegue", sender: nil)
//
//            }else
            
            if(questionNumber == questionBank.count - 1 && hasSeenCorrectAnswer){ //If answered last question
                //Post results to server
                
                var resultDict: [String: String] = ["team_id": InstanceDAO.team_id]
                resultDict["trail_instance_id"] = InstanceDAO.trail_instance_id
                resultDict["score"] = String(score)
                resultDict["hotspot"] = hotspot
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: resultDict) else { return
                    print("Error: cannot create jsonData")
                }
                
                guard let updateScoreURL = InstanceDAO.serverEndpoints["updateScore"] else {
                    print("Unable to get server endpoint for updateScoreURL")
                    return
                }
                
                // RestAPIManager.asyncHttpPost(jsonData: jsonData, URLStr: updateScoreURL)
                let responseDict = RestAPIManager.syncHttpPost(jsonData: jsonData, URLStr: updateScoreURL)
                
                var responseCode = 0
                
                if !responseDict.isEmpty {
                    responseCode = responseDict["response"] as! Int
                }
                
                if responseCode == 200 {
                    // Update CompletedList & isFirstTime check
                    InstanceDAO.completedList.append(hotspot)
                    InstanceDAO.isFirstTime = false
                    
                    // Perform Segue to result screen
                    performSegue(withIdentifier: "toResultScreenSegue", sender: nil)
                } else {
                    
                    // Alert to ask to try again
                    // create the alert
                    let alert = UIAlertController(title: "Failed to submit score to server", message: "Please ensure you have good internet connection and try again", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
//                // Send to result screen && Perform Segue
//                performSegue(withIdentifier: "toResultScreenSegue", sender: nil)
                
            }else if(hasSeenCorrectAnswer){
                
                questionNumber += 1
                
                //Reset choice colors

                firstAnswer.backgroundColor = silver
                secondAnswer.backgroundColor = silver
                thirdAnswer.backgroundColor = silver
                fourthAnswer.backgroundColor = silver
                
                updateQuiz()
                
                hasSeenCorrectAnswer = false
                selectedAnswer = 0
                
                confirmText.text = nil
                confirmButton.setTitle("Confirm Answer", for: .normal)
                
            }else if (selectedAnswer == 0){
                
                // create the alert
                let alert = UIAlertController(title: "Please Select an option", message: "No options were selected", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }else{
                
                if(selectedAnswer == questionAnswer){
                    
                    score += 1
                    
                    confirmText.text = "Correct"
                    confirmText.textColor = greenColor
                    
                }else{
                    
                    if(selectedAnswer == 1){
                        firstAnswer.backgroundColor = redColor
                        
                    }else if(selectedAnswer == 2){
                        secondAnswer.backgroundColor = redColor
                        
                    }else if(selectedAnswer == 3){
                        thirdAnswer.backgroundColor = redColor
                        
                    }else{
                        fourthAnswer.backgroundColor = redColor
                    }
                    
                    //show the correct ans in green
                    if(questionAnswer == 1){
                        firstAnswer.backgroundColor = greenColor
                    }else if(questionAnswer == 2){
                        secondAnswer.backgroundColor = greenColor
                    }else if(questionAnswer == 3){
                        thirdAnswer.backgroundColor = greenColor
                    }else{
                        fourthAnswer.backgroundColor = greenColor
                    }
                    
                    confirmText.text = "Incorrect"
                    confirmText.textColor = redColor
                    
                }
                
                confirmButton.setTitle("Next Question", for: .normal)
                hasSeenCorrectAnswer = true
                
                // Update to outcome array
                var selectedAnswerStr = ""
                var questionAnswerStr = ""
                
                if(selectedAnswer == 1){
                    selectedAnswerStr = firstAnswer.currentTitle!
                    
                }else if(selectedAnswer == 2){
                    selectedAnswerStr = secondAnswer.currentTitle!
                    
                }else if(selectedAnswer == 3){
                    selectedAnswerStr = thirdAnswer.currentTitle!
                    
                }else{
                    selectedAnswerStr = fourthAnswer.currentTitle!
                    
                }
                
                if(questionAnswer == 1){
                    questionAnswerStr = firstAnswer.currentTitle!
                    
                }else if(questionAnswer == 2){
                    questionAnswerStr = secondAnswer.currentTitle!
                    
                }else if(questionAnswer == 3){
                    questionAnswerStr = thirdAnswer.currentTitle!
                    
                }else{
                    questionAnswerStr = fourthAnswer.currentTitle!
                    
                }
                
                
                outcomeArr.append(Outcome(question: question.text!, userAnswer: selectedAnswerStr, expectedAnswer: questionAnswerStr))
            }
            
        }else { // For Member
            
            if(confirmButton.title(for: .normal) == "Home"){
                
                // Update CompletedList & isFirstTime check
//                InstanceDAO.completedList.append(hotspot)
                InstanceDAO.isFirstTime = false
                
                performSegue(withIdentifier: "toTabBarSegue", sender: nil)
                
            }else {
            
                questionNumber += 1
                print(questionNumber)
                
                //Reset choice colors
                firstAnswer.isUserInteractionEnabled = false
                secondAnswer.isUserInteractionEnabled = false
                thirdAnswer.isUserInteractionEnabled = false
                fourthAnswer.isUserInteractionEnabled = false
                
                updateQuiz()
                
                if(questionNumber == questionBank.count - 1){
                    confirmButton.setTitle("Home", for: .normal)
                }else {
                    confirmButton.setTitle("Next Question", for: .normal)
                }
            }
            
        }
        
        
    }
    
    //     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "toResultScreenSegue"){
            
            let destVC = segue.destination as! ResultScreenController
            destVC.setVariables(outcomeArr: outcomeArr, hotspot: hotspot, mission: "Quiz", score: String(score))
            
        }
        
    }
    
    func loadWaitScreen() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button tapped")
        
        if questionNumber == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            questionNumber -= 1
            print(questionNumber)
            
            //Reset choice colors
            firstAnswer.isUserInteractionEnabled = false
            secondAnswer.isUserInteractionEnabled = false
            thirdAnswer.isUserInteractionEnabled = false
            fourthAnswer.isUserInteractionEnabled = false
            
            updateQuiz()
            
            if(questionNumber == questionBank.count - 1){
                confirmButton.setTitle("Home", for: .normal)
            }else {
                confirmButton.setTitle("Next Question", for: .normal)
            }
        }
        
    }
 

}
