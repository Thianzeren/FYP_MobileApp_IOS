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
    
    
    //navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //    }
    
    @IBAction func connectBtn(_ sender: Any) {
        
        let trailID = trailIDPin.text!
        
        if(trailID == InstanceDAO.trail_instance_id){
            performSegue(withIdentifier: "toNameSegue", sender: nil)
        }else{
            createAlert(title: "Incorrect or Missing Pin Please Try Again", message: "")
        }
        
    }

    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
