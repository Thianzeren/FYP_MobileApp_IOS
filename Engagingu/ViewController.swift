import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    //properties
//    @IBOutlet weak var trailID: UITextField!
//    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var trailID: UITextField!
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.trailID.delegate = self
        self.name.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginbutton(_ sender: UIButton) {
        let myTrailID: String
        myTrailID = trailID.text!
        let myName: String
        myName = name.text!
        if(myTrailID == "1" && myName == "Celine"){
            //true
            performSegue(withIdentifier: "homeSegue", sender: nil)
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

