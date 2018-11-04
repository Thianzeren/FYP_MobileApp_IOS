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

class HomeController: UIViewController, UITextFieldDelegate {
    
   
    @IBOutlet weak var trailIDInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailIDInput.delegate = self as? UITextFieldDelegate
        
        trailIDInput.setBottomBorder()
    
        // Do any additional setup after loading the view.
    }
//    @IBAction func connectToTrailBtn(_ sender: Any) {
//    }
    
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
