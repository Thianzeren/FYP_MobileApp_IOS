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
    @IBOutlet weak var topNavBar: UINavigationItem!
    
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
    //Allow scrolliing after first line shown
    override func viewDidAppear(_ animated: Bool) {
        narrative.isScrollEnabled = true
    }
    
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button Tapped")
        dismiss(animated: true, completion: nil)
    }
    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destVC = segue.destination as! QuizViewController
        
        destVC.hotspot = headerText
        
    }

}
