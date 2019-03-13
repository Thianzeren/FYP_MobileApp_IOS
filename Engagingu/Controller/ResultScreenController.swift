//
//  ResultScreenViewController.swift
//  Engagingu
//
//  Created by Nicholas on 11/3/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class ResultScreenController: UIViewController {
    

    @IBOutlet weak var hotspotTextField: UITextField!
    @IBOutlet weak var missionTextField: UITextField!
    @IBOutlet weak var scoreLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var hotspot = ""
    var mission = ""
    var score = ""
    var outcomeArr: [Outcome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        hotspotTextField.text = hotspot
        missionTextField.text = mission + " Mission Results"
        
        let outcomeSize = outcomeArr.count
        scoreLabel.text = "You got " + score + "/" + String(outcomeSize) + " correct!"

    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func setVariables (outcomeArr: [Outcome], hotspot: String, mission: String, score: String) {
        
        self.outcomeArr = outcomeArr
        self.hotspot = hotspot
        self.mission = mission
        self.score = score
        
    }
    
    
}

extension ResultScreenController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outcomeArr.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let outcome = outcomeArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultScreenTableViewCell") as! ResultScreenTableViewCell
        
        cell.setOutcome(question: outcome.question, userAnswer: outcome.userAnswer, expectedAnswer: outcome.expectedAnswer)
        
        return cell
        
    }

    
    
}
