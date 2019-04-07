//  ResultScreenViewController.swift
//  Engagingu
import UIKit
//ResultScreenController display the mission (drag&drop & quiz) questions, the userAnswer, the correctAns
//and their score
class ResultScreenController: UIViewController {
    @IBOutlet weak var hotspotTextField: UITextField!
    @IBOutlet weak var missionTextField: UITextField!
    @IBOutlet weak var scoreLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var home: UIButton!
    
    var hotspot = ""
    var mission = ""
    var score = ""
    var outcomeArr: [Outcome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home.float()
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
    //back to maps
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toTabBarSegue", sender: nil)
    }
    
}

extension ResultScreenController: UITableViewDataSource, UITableViewDelegate{
    //this method returns the number of rows the tableview should have
    //the number of rows == number of elements outcomeArr
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outcomeArr.count
    }
    //this method display the questions, userAns and correctAns
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outcome = outcomeArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultScreenTableViewCell") as! ResultScreenTableViewCell
        cell.setOutcome(question: outcome.question, userAnswer: outcome.userAnswer, expectedAnswer: outcome.expectedAnswer)
        return cell
    }
}
