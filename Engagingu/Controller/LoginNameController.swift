import UIKit

class LoginNameController: UIViewController, UITextFieldDelegate {
    //properties
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startButton(_ sender: Any) {
        let myName = usernameField.text!
        
        if(myName == "Celine"){
            //true
            performSegue(withIdentifier: "toHomeSegue", sender: nil)
        }else{
            let alert = UIAlertController(title: "HELLO THERE", message: "Wrong Game ID/ Choose another name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:nil))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

