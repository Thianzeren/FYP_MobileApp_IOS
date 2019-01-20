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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

