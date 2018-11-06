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
        // Get trail instance id from DB and store in DAO
        let jsonUrlString = "http://54.255.245.23:3000/getInstance"
        guard let url = URL(string: jsonUrlString) else {return}
        print(url);

        URLSession.shared.dataTask(with: url){ (data, response, err) in

            guard let data = data else {return}

            let jsonStr = String(data:data, encoding: .utf8)
            print(jsonStr)

            do{
                guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}

                let trail_instance_id = jsonObj["trail_instance_id"] as? String
                InstanceDAO.trail_instance_id = trail_instance_id!
                print(jsonObj)

            }catch let jsonErr {
                print ("Error serializing json:" + jsonErr.localizedDescription)
            }

            }.resume()
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
