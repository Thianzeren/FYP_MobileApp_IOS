//
//  QuizViewController.swift
//  Engagingu
//
//  Created by Nicholas on 13/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var topNavBar: UINavigationBar!
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var firstAnswer: UIButton!
    @IBOutlet weak var secondAnswer: UIButton!
    @IBOutlet weak var thirdAnswer: UIButton!
    @IBOutlet weak var fourthAnswer: UIButton!
    @IBOutlet weak var firstAnswerSquare: UIView!
    @IBOutlet weak var secondAnswerSquare: UIView!
    @IBOutlet weak var thirdAnswerSquare: UIView!
    @IBOutlet weak var fourthAnswerSquare: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectFirstAnswer(_ sender: Any) {
    }
    
    @IBAction func selectSecondAnswer(_ sender: Any) {
    }
    
    @IBAction func selectThirdAnswer(_ sender: Any) {
    }
    
    @IBAction func selectFourthAnswer(_ sender: Any) {
    }
    
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button tapped")
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
