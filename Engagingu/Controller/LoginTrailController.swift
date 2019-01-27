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
        
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        
    }
    
    //navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //    }
    
    @IBAction func connectBtn(_ sender: Any) {
        
        let trailID = trailIDPin.text!
        
        // Get trail instance id from DB and store in DAO
        guard let getInstanceIdURL = InstanceDAO.serverEndpoints["getInstanceId"] else{
            print("Unable to get server endpoint for getInstanceId")
            return
        }
        
        let responseDict = RestAPIManager.syncHttpGet(URLStr: getInstanceIdURL)
        
        //Process response
        let trail_instance_id = responseDict["trail_instance_id"] as? String
        if let id = trail_instance_id {
            print(id)
            InstanceDAO.trail_instance_id = id
        }
        
        // Shortcut to camera for testing
        if(trailID == "camera"){
            performSegue(withIdentifier: "toCameraSegue", sender: nil)
        }
        if(trailID == "dragdrop"){
            performSegue(withIdentifier: "toDragAndDropSegue", sender: nil)
        }
        // Remember to remove "fypadmin" checl
        if(trailID == InstanceDAO.trail_instance_id || trailID == "fypadmin"){
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
    
    @objc func keyboardWillChange(notification: Notification){
//        print("Keyboard will show: \(notification.name.rawValue)")
        
        // Get keyboard height
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            // Check if notification is related to show/change frame
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
                
                // Shift frame upwards by rect height
                view.frame.origin.y = -1 * keyboardHeight
            }else{
                view.frame.origin.y = 0
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
