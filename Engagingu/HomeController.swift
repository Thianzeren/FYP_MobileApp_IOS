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
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}

class HomeController: UIViewController {
    
    @IBOutlet weak var trailIDInput: UITextField!
    @IBOutlet var engaginguLogo: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailIDInput.delegate = self as? UITextFieldDelegate
        
        trailIDInput.setBottomBorder()
    
        // Do any additional setup after loading the view.
    }
    
    //actions after pressing connect btn
    @IBAction func connectTrailBtn(_ sender: Any) {
    }
   
    //navigation 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

}
