//  NarrativeViewController.swift
//  Engagingu

import UIKit
//NarrativeViewController display the narrative of the selected hotspot
class NarrativeViewController: UIViewController {

    @IBOutlet weak var header: UITextView!
    @IBOutlet weak var narrative: UITextView!
    @IBOutlet weak var startMissionButton: UIButton!
    
    var headerText = "Header"
    var narrativeText = "Narrative"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ensure view starts from first line for user to read
        narrative.isScrollEnabled = false
        header.text! = headerText
        narrative.text! = narrativeText
        startMissionButton.float()
        //topNavBar.title = "EngagingU"
        // Do any additional setup after loading the view.
        
    }
    //startMission set the segue to the respective missions view
    @IBAction func startMission(_ sender: Any) {
        
        print("HEADER TEXT")
        print(headerText)
        
        if(InstanceDAO.quizDict[headerText] != nil){
            performSegue(withIdentifier: "toQuizSegue", sender: nil)
        }
        else if(InstanceDAO.selfieDict[headerText] != nil){
            performSegue(withIdentifier: "toCameraSegue", sender: nil)
        }
        else if(InstanceDAO.anagramDict[headerText] != nil){
            performSegue(withIdentifier: "toAnagramSegue", sender: nil)
        }else if(InstanceDAO.dragAndDropDict[headerText] != nil){
            print("To Drag and drop")
            performSegue(withIdentifier: "toDragAndDropSegue", sender: nil)
        }else if(InstanceDAO.drawingDict[headerText] != nil){
            performSegue(withIdentifier: "toDrawingSegue", sender: nil)
        }else if (InstanceDAO.wordSearchDict[headerText] != nil){
            performSegue(withIdentifier: "toWordSearchSegue", sender: nil)
        }
    }
    //Allow scrolliing after first line shown
    override func viewDidAppear(_ animated: Bool) {
        narrative.isScrollEnabled = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "toQuizSegue"){
            
            let destVC = segue.destination as! QuizViewController
            destVC.hotspot = headerText
            
        }else if(segue.identifier == "toCameraSegue"){
            
            let destVC = segue.destination as! CameraViewController
            destVC.hotspot = headerText
            
        }else if(segue.identifier == "toAnagramSegue"){
            
            let destVC = segue.destination as! AnagramViewController
            
            destVC.hotspot = headerText
            destVC.hiddenWord = InstanceDAO.anagramDict[headerText] ?? ""
            //destVC.clue = ""
            
        }else if(segue.identifier == "toDragAndDropSegue"){
            
            let destVC = segue.destination as! DragAndDropController
            destVC.hotspot = headerText
            
        }else if(segue.identifier == "toDrawingSegue"){
            
            let destVC = segue.destination as! DrawingController
            destVC.hotspot = headerText
            destVC.question = InstanceDAO.drawingDict[headerText] ?? ""
            
        }else if(segue.identifier == "toWordSearchSegue"){
            
            let destVC = segue.destination as! WordSearchViewController
            destVC.hotspot = headerText
            
        }
        
    }
    //go back to mapView
    @IBAction func backToPreviousView(_ sender: Any) {
        print("Back button tapped")
        dismiss(animated: true, completion: nil)
    }
    
    
}
