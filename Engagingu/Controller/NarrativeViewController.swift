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
        
        header.text! = headerText
        narrative.text! = narrativeText
        
        topNavBar.title = "EngagingU"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button Tapped")
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
