//  TutorialViewController.swift
//  Engagingu


import UIKit
//TutorialViewController is for designing the button
class TutorialViewController: UIViewController {

    @IBOutlet weak var letsGoButton: UIButton!
    //Float the button
    override func viewDidLoad() {
        super.viewDidLoad()
        letsGoButton.float()
    }
    

}
