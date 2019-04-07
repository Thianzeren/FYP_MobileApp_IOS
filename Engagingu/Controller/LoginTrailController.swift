//
//  HomeController.swift
//  Engaging U

import UIKit
// LoginTrailController checks if trailID is same as the trailID generated from webapp
extension UITextField{
    //design of the TrailID textbox
    func setBottomBorder(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}
extension UIButton {
    //design of the submit button
    func float(){
        layer.cornerRadius = frame.height/2
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize (width: 0, height: 10)
        layer.shadowRadius = 5
    }
}


class LoginTrailController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var trailIDPin: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailIDPin.delegate = self
        trailIDPin.setBottomBorder()
        submitButton.float()
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        
    }
    
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
                
                if(trailID == InstanceDAO.trail_instance_id){
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
    //Loading bar while witing for other members to join
    //loading bar disappear when webapp start trail
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
    //dismiss keyboard when user click on return button on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
