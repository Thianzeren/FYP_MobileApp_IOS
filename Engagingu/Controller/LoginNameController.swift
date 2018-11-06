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
        
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        
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

