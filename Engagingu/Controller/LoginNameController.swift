import SocketIO
import UIKit
//LoginNameController takes in and store the username,
//Get the team number and assign roles (leader/member)
//while loading the other pages such has maps, quiz questions.

class LoginNameController: UIViewController, UITextFieldDelegate {
    //properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usernameField.delegate = self
        usernameField.setBottomBorder()
        submitButton.float()
        
        //Listen for keyboard events, addObserers. Obbservers are removed when > IOS 9
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //When user click on startButton, Check that username is not empty
    //Get team number and role (leader/member)
    //Get the hotspots, locations, missions from webapp
    //If username is not empty, it will proceed to the tutorial screen
    //else prompt user to key in username
    @IBAction func startButton(_ sender: Any) {
        
        // print(usernameField.text!)
        if !(usernameField.text! == "") {
            
            let username = usernameField.text
            //Store username in instanceDAO
            InstanceDAO.username = username!
            
            //Send username to db via POST JSON
            // print(username)
            let userDict: [String: String] = ["username": username!]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: userDict) else { return
                print("Error: cannot create jsonData")
            }
            
            //Debug Print
            let jsonDataStr = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
            print(jsonDataStr)
            
            guard let registerUserURL = InstanceDAO.serverEndpoints["registerUser"] else {
                print("Unable to get server endpoint for registerUser")
                return
            }
            //Using httpPost method from APIManager
            let responseDict = RestAPIManager.syncHttpPost(jsonData: jsonData, URLStr: registerUserURL)

            let team_id = responseDict["team_id"] as? Int
    //        print(team_id)
            
            if let id = team_id {
                InstanceDAO.team_id = String(id)
            }
            
            // Get LeaderMember status
            guard let getLeaderMemberURL = InstanceDAO.serverEndpoints["getAllLeaderMember"] else {
                print("Unable to get server endpoint for getAllLeaderMember")
                return
            }
            RestAPIManager.httpGetLeaderMemberStatus(URLStr: getLeaderMemberURL)
            
            // Get starting hotspots
            guard let startHotspotURL = InstanceDAO.serverEndpoints["getStartingHotspots"] else {
                print("Unable to get server endpoint for getStartingHotspots")
                return
            }
            RestAPIManager.httpGetStartingHotspots(URLStr: startHotspotURL  + InstanceDAO.trail_instance_id)
            
            // Get hotspot location
            guard let allHotspotURL = InstanceDAO.serverEndpoints["getAllHotspots"] else {
                print("Unable to get server endpoint for getAllHotspots")
                return
            }
            RestAPIManager.httpGetHotspots(URLStr: allHotspotURL + InstanceDAO.trail_instance_id)
            
            // Get quiz questions
            guard let quizQuestionsURL = InstanceDAO.serverEndpoints["getAllQuizzes"] else {
                print("Unable to get server endpoint for quizQuestionsURL")
                return
            }
            RestAPIManager.httpGetQuizzes(URLStr: quizQuestionsURL + InstanceDAO.trail_instance_id)
            
            // Get selfie question
            guard let selfieQuestionsURL = InstanceDAO.serverEndpoints["getAllSelfies"] else {
                print("Unable to get server endpoint for selfieQuestionsURL")
                return
            }
            RestAPIManager.httpGetSelfies(URLStr: selfieQuestionsURL  + InstanceDAO.trail_instance_id)
            
            // Get Anagram Questions
            guard let anagramURL = InstanceDAO.serverEndpoints["getAllAnagrams"] else {
                print("Unable to get server endpoint for anagramURL")
                return
            }
            RestAPIManager.httpGetAnagram(URLStr: anagramURL + InstanceDAO.trail_instance_id)
            
            // Get Drag And Drop Questions
            guard let dragAndDropURL = InstanceDAO.serverEndpoints["getAllDragAndDrops"] else {
                print("Unable to get server endpoint for dragAndDropURL")
                return
            }
            RestAPIManager.httpGetDragAndDrop(URLStr: dragAndDropURL + InstanceDAO.trail_instance_id)
            
            // Get Drawing Questions
            guard let drawingURL = InstanceDAO.serverEndpoints["getAllDrawings"] else {
                print("Unable to get server endpoint for drawingURL")
                return
            }
            RestAPIManager.httpGetDrawing(URLStr: drawingURL + InstanceDAO.trail_instance_id)
            
            // Get Word Search words
            guard let wordSearchURL = InstanceDAO.serverEndpoints["getAllWordSearch"] else {
                print("Unable to get server endpoint for wordSearchURL")
                return
            }
            RestAPIManager.httpGetWordSearch(URLStr: wordSearchURL + InstanceDAO.trail_instance_id)
            
            // Save to UserDefaults for session
            saveCredentialsToSession()
            
            // Connect Socket to Server
            SocketHandler.addHandlers()
            SocketHandler.connectSocket()
            
            performSegue(withIdentifier: "toTutorialSegue", sender: nil)
        }else {
            print("String is nil or empty")
            createAlert(title: "Please enter a username", message: "")
        }
        
    }
    
    func saveCredentialsToSession(){
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.team_id, forKey: "team_id")
        def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
        def.set(InstanceDAO.username, forKey: "username")
        def.set(InstanceDAO.isLeader, forKey: "isLeader")
        def.set(InstanceDAO.completedList, forKey: "completedList")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        def.synchronize()
    
    }
    
    func createAlert (title:String, message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion:nil)
    }
    //Shift the screen up when keyboard appears
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

