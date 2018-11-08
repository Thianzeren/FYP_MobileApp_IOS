//
//  TeamAllocationController.swift
//  Engagingu
//
//  Created by Nicholas on 8/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class TeamAllocationController: UIViewController {
    
    @IBOutlet weak var groupNumber: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNumber.text = InstanceDAO.team_id
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func okayBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        
    }
}
