//
//  NarrativeViewController.swift
//  Engagingu
//
//  Created by Nicholas on 13/12/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class NarrativeViewController: UIViewController {

   
    @IBOutlet weak var header: UITextView!
    @IBOutlet weak var narrative: UITextView!
//    @IBOutlet weak var topNavBar: UINavigationItem!
    
    var headerText = "Header"
    var narrativeText = "Narrative"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ensure view starts from first line for user to read
        narrative.isScrollEnabled = false
        header.text! = headerText
        narrative.text! = narrativeText
        
        //topNavBar.title = "EngagingU"
        // Do any additional setup after loading the view.
        
        
        
    }
    
    @IBAction func startMission(_ sender: Any) {
        print("HEADER TEXT")
        print(headerText)
        
        if(InstanceDAO.quizDict[headerText] != nil){
            performSegue(withIdentifier: "toQuizSegue", sender: nil)
        }else if(InstanceDAO.selfieDict[headerText] != nil){
            performSegue(withIdentifier: "toCameraSegue", sender: nil)
        }else if(InstanceDAO.anagramDict[headerText] != nil){
            performSegue(withIdentifier: "toAnagramSegue", sender: nil)
        }
    }
    //Allow scrolliing after first line shown
    override func viewDidAppear(_ animated: Bool) {
        narrative.isScrollEnabled = true
    }
    
    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "toQuizSegue"){
            
            let destVC = segue.destination as! QuizViewController
            destVC.hotspot = headerText
            
        }else if(segue.identifier == "toCameraSegue"){
            
            let destVC = segue.destination as! CameraViewController
            destVC.hotspot = headerText
            
        }else if(segue.identifier == "toAnagramSegue"){
            
            let destVC = segue.destination as! AnagramViewController
            
            destVC.hotspot = headerText
            destVC.hiddenWord = InstanceDAO.anagramDict[headerText] ?? ""
            destVC.clue = ""
            
            
        }
        
    }
    
    
}
