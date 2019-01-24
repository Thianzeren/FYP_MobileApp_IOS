import SocketIO
import UIKit

class LoginNameController: UIViewController, UITextFieldDelegate {
    //properties
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameField.delegate = self
        usernameField.setBottomBorder()
        
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startButton(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty else {
            print("String is nil or empty")
            createAlert(title: "Please enter a username", message: "")
            return
        }
        
        //Store username in instanceDAO
        InstanceDAO.username = username
        
        //Send username to db via POST JSON
        print(username)
        let userDict: [String: String] = ["username": username]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: userDict) else { return
            print("Error: cannot create jsonData")
        }
        
        //Debug Print
        let jsonDataStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print(jsonDataStr)
        
        //Using httpPost method from APIManager
        let responseDict = RestAPIManager.syncHttpPost(jsonData: jsonData, URLStr: "http://54.255.245.23:3000/user/register")

        let team_id = responseDict["team_id"] as? Int
//        print(team_id)
        
        if let id = team_id {
            InstanceDAO.team_id = String(id)
        }
        
        // Get starting hotspots
        let startHotspotURL = "http://54.255.245.23:3000/team/startingHotspot?trail_instance_id=" + InstanceDAO.trail_instance_id
        RestAPIManager.httpGetStartingHotspots(URLStr: startHotspotURL)
        
        // Get Anagram Questions
        let anagramURL = "http://54.255.245.23:3000/anagram/getAnagrams?trail_instance_id=" + InstanceDAO.trail_instance_id
        RestAPIManager.httpGetAnagram(URLStr: anagramURL)
        
        // Save to UserDefaults for session
        // saveCredentialsToSession()
        
        // Connect Socket to Server
        SocketHandler.addHandlers()
        SocketHandler.connectSocket()
        
        performSegue(withIdentifier: "toTutorialSegue", sender: nil)
        
    }
    
    func saveCredentialsToSession(){
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.team_id, forKey: "team_id")
        def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
        def.set(InstanceDAO.username, forKey: "username")
        def.synchronize()
    
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

