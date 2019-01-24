//
//  AnagramViewController.swift
//  Engagingu
//
//  Created by Nicholas on 23/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class AnagramViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var clueLabel: UITextView!
    
    var score: Int = 1
    var clue: String = ""
    var hotspot: String = ""
    var hiddenWord: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create border for input box
        let myColor = UIColor.black
        wordInput.layer.borderWidth = 1.0
        wordInput.layer.borderColor = myColor.cgColor
        
        wordLabel.text = String(hiddenWord.shuffled())
        clueLabel.text = clue
        
        self.wordInput.delegate = self
        
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        
        // Check if input is same as hidden word
        if(wordInput.text == hiddenWord){
            //Send score to database
            
            //display alert for correct word & perform segue back to tab bar
            
            // create the alert
            let alert = UIAlertController(title: "You Got It!", message: "Click OK to continue", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                
                // Send score to database
                var resultDict: [String: String] = ["team_id": InstanceDAO.team_id]
                resultDict["trail_instance_id"] = InstanceDAO.trail_instance_id
                resultDict["score"] = String(self.score)
                resultDict["hotspot"] = self.hotspot
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: resultDict) else { return
                    print("Error: cannot create jsonData")
                }
                
                let urlStr = "http://54.255.245.23:3000/team/updateScore"
                RestAPIManager.asyncHttpPost(jsonData: jsonData, URLStr: urlStr)
                
                // Update CompletedList & isFirstTime check
                InstanceDAO.completedList.append(self.hotspot)
                InstanceDAO.isFirstTime = false
                
                alert.dismiss(animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "toTabBarSegue", sender: nil)
                
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            // Alert to ask to try again
            // create the alert
            let alert = UIAlertController(title: "Incorrect Word", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        
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
