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
        
        // Load Waiting Screen while retrieving Trail Instance ID from server
        loadWaitScreen()
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            // Get trail instance id from server and store in DAO
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
            
            group.leave()
        }
        
        group.notify(queue: .main){
            
            self.dismiss(animated: true, completion: {
                
                // Shortcut to camera for testing
                if(trailID == "camera"){
                    self.performSegue(withIdentifier: "toCameraSegue", sender: nil)
                }
                if(trailID == "dragdrop"){
                    self.performSegue(withIdentifier: "toDragAndDropSegue", sender: nil)
                }
                if(trailID == "drawing"){
                    self.performSegue(withIdentifier: "toDrawingSegue", sender: nil)
                }
                
                // Remember to remove "fypadmin" check
                if(trailID == InstanceDAO.trail_instance_id || trailID == "fypadmin"){
                    self.performSegue(withIdentifier: "toNameSegue", sender: nil)
                }else{
                    self.createAlert(title: "Incorrect or Missing Pin Please Try Again", message: "")
                }
                
            })
            
        }
        
        
    }

    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    func loadWaitScreen() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
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
