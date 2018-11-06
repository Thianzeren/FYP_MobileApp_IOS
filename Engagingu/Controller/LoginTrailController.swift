//
//  HomeController.swift
//  Engaging U
//
//  Created by Admin on 3/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UITextField{
    func setBottomBorder(){
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}

class LoginTrailController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var trailIDPin: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trailIDPin.delegate = self
        trailIDPin.setBottomBorder()
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func connectBtn(_ sender: Any) {
        
        let trailID = trailIDPin.text!
        
        if(trailID == "1"){
            performSegue(withIdentifier: "toNameSegue", sender: nil)
        }
        
    }
    
    
    //actions after pressing connect btn
    
    //navigation 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
