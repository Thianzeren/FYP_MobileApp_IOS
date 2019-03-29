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
   // @IBOutlet weak var clueLabel: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var score: Int = 1
    //var clue: String = ""
    var hotspot: String = ""
    var hiddenWord: String = ""
    var wordInputwithoutspace = ""
    var listOfEnteredCharacters: [String] = []
    var oldWord = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.float()
        // Create border for input box
        let myColor = UIColor.black
        wordInput.layer.borderWidth = 1.0
        wordInput.layer.borderColor = myColor.cgColor
        
        wordLabel.text = String(hiddenWord.shuffled())
        //clueLabel.text = clue
        
        self.wordInput.delegate = self
        
        if(!InstanceDAO.isLeader){
            wordInput.isHidden = true
            submitBtn.setTitle("Home", for: .normal)
            
        }
        
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
        
        wordInput.addTarget(self, action: #selector(AnagramViewController.textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
        
    }

    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        //change the user input to lowercaps so that can compare to wordLabel
        let userInput = sender.text!.lowercased()
        
        //when user add letter
        if (userInput.count > oldWord.count) {
                let lastletter = userInput.last!
                //if new character is in the wordlabel
                //1. append the character to list
                //2. remove it from the wordlabel
                //update the oldword to userinput --> purpose is to compare the strings when letter is deleted
                if ((wordLabel.text?.contains(lastletter))!) {
                    listOfEnteredCharacters.append(String(lastletter))
                    print(listOfEnteredCharacters)
                    let position = wordLabel.text?.firstIndex(of: lastletter)
                    wordLabel.text?.remove(at: position!)
                    oldWord = userInput
                }
        }
        //when user delete a letter
        else if (userInput.count < oldWord.count){
            let letterRemoved = oldWord.last
        
            //the letter deleted is from the wordLabel
            if listOfEnteredCharacters.contains(String(letterRemoved!)){
                wordLabel.text?.append(letterRemoved!)
                let index = listOfEnteredCharacters.firstIndex(of: String(letterRemoved!))
                listOfEnteredCharacters.remove(at: index!)
            }
            //this update of oldWord is not place in the if block above
            //because it needs to account when there is deletion of spacing
            oldWord = userInput
        }
     
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        //in case user enter wrong word, clear wordinputwithoutspace
        wordInputwithoutspace = ""
        if(InstanceDAO.isLeader){
            // Check if input is same as hidden word
            //but first remove all the empty spaces
            for letter in (wordInput.text!){
                if letter != " " {
                    wordInputwithoutspace.append(letter)
                }
            }
            
            if(wordInputwithoutspace.lowercased() == hiddenWord){
                //Send score to database
                
                // Send score to database
                var resultDict: [String: String] = ["team_id": InstanceDAO.team_id]
                resultDict["trail_instance_id"] = InstanceDAO.trail_instance_id
                resultDict["score"] = String(self.score)
                resultDict["hotspot"] = self.hotspot
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: resultDict) else { return
                    print("Error: cannot create jsonData")
                }
                
                guard let updateScoreURL = InstanceDAO.serverEndpoints["updateScore"]else {
                    print("Unable to get server endpoint for updateScoreURL")
                    return
                }
                
                let responseDict = RestAPIManager.syncHttpPost(jsonData: jsonData, URLStr: updateScoreURL)
                
                var responseCode = 0
                
                if !responseDict.isEmpty {
                    responseCode = responseDict["response"] as! Int
                }
                
                if responseCode == 200 {
                    // Update CompletedList & isFirstTime check
                    InstanceDAO.completedList.append(self.hotspot)
                    InstanceDAO.isFirstTime = false
                    
                    // Display alert for correct word & perform segue back to tab bar
                    // create the alert
                    let alert = UIAlertController(title: "You Got It!", message: "Click OK to continue", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        
                        
                        
                        //                    // Update CompletedList & isFirstTime check
                        //                    InstanceDAO.completedList.append(self.hotspot)
                        //                    InstanceDAO.isFirstTime = false
                        //
                        //                    alert.dismiss(animated: true, completion: nil)
                        //
                                            self.performSegue(withIdentifier: "toTabBarSegue", sender: nil)
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    
                    // Alert to ask to try again
                    // create the alert
                    let alert = UIAlertController(title: "Failed to submit score to server", message: "Please ensure you have good internet connection and try again", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
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
        }else { //If Member
            
            // Update CompletedList & isFirstTime check
//            InstanceDAO.completedList.append(hotspot)
            InstanceDAO.isFirstTime = false
            
            performSegue(withIdentifier: "toTabBarSegue", sender: nil)
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
