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
        
        //Send username to db via POST JSON
        let json: [String: String] = ["username": username]
        print(username)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else { return
            print("Error: cannot create jsonData")
        }
        let string1 = String(data: jsonData, encoding: String.Encoding.utf8) ?? "Data could not be printed"
        print(string1)
        
//        //Using httpPost method from APIManager
//        let responseDict = APIManager().httpPost(jsonData: jsonData, URLStr: "http://54.255.245.23:3000/user/register")
//
//        let team_id = responseDict["team_id"] as? Int
//        print(team_id)
//        InstanceDAO.team_id = String(team_id!)
//        print(InstanceDAO.team_id)
        
        //With local post method
        httpPost(jsonData: jsonData)
        
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        
    }
    
    func httpPost(jsonData: Data){
        if !jsonData.isEmpty {

            guard let url = URL(string: "http://54.255.245.23:3000/user/register") else {

                print("Error: cannot create URL")
                return
            }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else{
                    print(error?.localizedDescription ?? "No data")
                    return
                }

                do{
                    guard let responseJSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        print("Error: no json response received")
                        return
                    }

                    print(responseJSON)

                    let team_id = responseJSON["team_id"] as? Int
                    print(team_id)
                    InstanceDAO.team_id = String(team_id!)
                    let def = UserDefaults.standard
                    def.set(InstanceDAO.team_id, forKey: "team_id")
                    def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
                    def.synchronize()
                    print(InstanceDAO.team_id)

                }catch let jsonErr{
                    print ("Error serializing json:" + jsonErr.localizedDescription)
                }



            }
            task.resume();
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

