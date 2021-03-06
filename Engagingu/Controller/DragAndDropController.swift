//
//  DragAndDropController.swift
//  Engagingu
import UIKit
import MobileCoreServices
// DragAndDropController creates the drag and drop mission with 4 choices to match 4 labels
class DragAndDropController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var optionLabel1: UILabel!
    @IBOutlet weak var optionLabel2: UILabel!
    @IBOutlet weak var optionLabel3: UILabel!
    @IBOutlet weak var optionLabel4: UILabel!
    
    @IBOutlet weak var dragTextView1: UITextView!
    @IBOutlet weak var dragTextView2: UITextView!
    @IBOutlet weak var dragTextView3: UITextView!
    @IBOutlet weak var dragTextView4: UITextView!
    
    @IBOutlet weak var dropTextView1: UITextView!
    @IBOutlet weak var dropTextView2: UITextView!
    @IBOutlet weak var dropTextView3: UITextView!
    @IBOutlet weak var dropTextView4: UITextView!
    
    // Stores the current view being dragged
    var viewBeingDragged: UITextView?
    
    var hotspot: String = ""
    var score = 0
    var qnaArr: [QnA] = []
    var dragTextViewArr: [UITextView] = []
    var dropTextViewArr: [UITextView] = []
    var optionLabelArr: [UILabel] = []
    var outcomeArr: [Outcome] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.float()
        // Populate Views
        initiateViews()
        
        // Get Drag And Drop question and answers
        let dragAndDrop = InstanceDAO.dragAndDropDict[hotspot]!
        questionLabel.text = dragAndDrop.question + "\n(Long press to drag)"
        qnaArr = dragAndDrop.drag_and_drop

        // Populate option labels & answer boxes
        for i in 0 ..< qnaArr.count{

            let qna = qnaArr[i]

            let dragTextView = dragTextViewArr[i]
            dragTextView.text = qna.drag_and_drop_answer

            let optionLabel = optionLabelArr[i]
            optionLabel.text = qna.drag_and_drop_question

        }
        
        if(!InstanceDAO.isLeader){
            submitBtn.setTitle("Home", for: .normal)
        }
        
    }
    
    @IBAction func submitAnswer(_ sender: Any) {
        
        // if is leader: carries on with other checks, else: redirect to home
        // if empty: shows alert that it not options are filled up
        // else: calculate score and send score to backend
        
        if(InstanceDAO.isLeader){

            var hasEmptyDrops = false
            
            // Check if any of the drop views are empty
            for dropTextView in dropTextViewArr {
                
                if dropTextView.text == "" {
                    hasEmptyDrops = true
                }
                
            }
            
            if (hasEmptyDrops) { // If it is empty, show alert to inform user
                
                // Alert to ask to try again
                // create the alert
                let alert = UIAlertController(title: "You have not filled up all boxes", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    
                    alert.dismiss(animated: true, completion: nil)
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }else { // Calculate score and redirect to result page
                
                if score == 0 {
                    // Iterate through each dropTextView
                    for i in 0 ..< dropTextViewArr.count{
                        
                        let optionText = optionLabelArr[i].text
                        var correctAnswer = ""
                        
                        // Obtain correct answer for corresponding label
                        innerLoop: for qnaPair in qnaArr {
                            
                            let label = qnaPair.drag_and_drop_question
                            let answer = qnaPair.drag_and_drop_answer
                            
                            if optionText == label {
                                correctAnswer = answer
                                break innerLoop
                            }
                            
                        }
                        
                        // Check if answer is correct
                        let dropTextView = dropTextViewArr[i]
                        if dropTextView.text == correctAnswer {
                            score += 1
                            print("score: ", score)
                        }
                        
                        outcomeArr.append(Outcome(question: optionText!, userAnswer: dropTextView.text, expectedAnswer: correctAnswer))
                    }
                }
                
                // Post Results to server
                var resultDict: [String: String] = ["team_id": InstanceDAO.team_id]
                resultDict["trail_instance_id"] = InstanceDAO.trail_instance_id
                resultDict["score"] = String(score)
                resultDict["hotspot"] = hotspot
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: resultDict) else { return
                    print("Error: cannot create jsonData")
                }
                
                guard let updateScoreURL = InstanceDAO.serverEndpoints["updateScore"] else {
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
                    InstanceDAO.completedList.append(hotspot)
                    InstanceDAO.isFirstTime = false
                    
                    // Perform Segue to result screen
                    performSegue(withIdentifier: "toResultScreenSegue", sender: nil)
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
                
            }
        }else { // If Member
            // Update CompletedList & isFirstTime check
//            InstanceDAO.completedList.append(hotspot)
            InstanceDAO.isFirstTime = false
            
            performSegue(withIdentifier: "toTabBarSegue", sender: nil)
        }
        
    }
    
    func initiateViews(){
        
        dragTextViewArr.append(dragTextView1)
        dragTextViewArr.append(dragTextView2)
        dragTextViewArr.append(dragTextView3)
        dragTextViewArr.append(dragTextView4)
        
        dropTextViewArr.append(dropTextView1)
        dropTextViewArr.append(dropTextView2)
        dropTextViewArr.append(dropTextView3)
        dropTextViewArr.append(dropTextView4)
        
        optionLabelArr.append(optionLabel1)
        optionLabelArr.append(optionLabel2)
        optionLabelArr.append(optionLabel3)
        optionLabelArr.append(optionLabel4)
        
        for i in 0 ..< dragTextViewArr.count {
            
            let dragTextView = dragTextViewArr[i]
            
            let dragInteraction1 = UIDragInteraction(delegate: self)
            dragInteraction1.isEnabled = true
            
            dragTextView.isUserInteractionEnabled = true
            dragTextView.layer.borderWidth = 1
            dragTextView.layer.borderColor = UIColor.lightGray.cgColor
            dragTextView.addInteraction(dragInteraction1)
            dragTextView.addInteraction(UIDropInteraction(delegate: self))
            
            let dropTextView = dropTextViewArr[i]
            
            let dragInteraction2 = UIDragInteraction(delegate: self)
            dragInteraction2.isEnabled = true
            
            dropTextView.isUserInteractionEnabled = true
            dropTextView.layer.borderWidth = 1
            dropTextView.layer.borderColor = UIColor.black.cgColor
            dropTextView.addInteraction(dragInteraction2)
            dropTextView.addInteraction(UIDropInteraction(delegate: self))
            dropTextView.text = ""
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toResultScreenSegue"){
            
            let destVC = segue.destination as! ResultScreenController
            destVC.setVariables(outcomeArr: outcomeArr, hotspot: hotspot, mission: "DragAndDrop", score: String(score))
            
        }
        
    }
    // Methods for UIDropInteractionDelegate
    
    // Define what data type can be dropped
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String])
    }
    
    // Check what operation to perform when something is dragged on to the view
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        var dropOperation: UIDropOperation?
        
        if session.canLoadObjects(ofClass: String.self) {
            if let textView = interaction.view as? UITextView{
                
                if interaction.view != viewBeingDragged && textView.text == "" {
                    dropOperation = .copy
                }else{
                    dropOperation = .cancel
                }
                
            } else {
                dropOperation = .cancel
            }
            
        } else {
            dropOperation = .cancel
        }
        
        return UIDropProposal(operation: dropOperation!)
    }
    
    // Performs drop action
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        //        let location = session.location(in: self.view)
        
        if session.canLoadObjects(ofClass: String.self) {
            
            _ = session.loadObjects(ofClass: String.self) { (items) in
                let values = items as [String]
                
                if let dropView = interaction.view as? UITextView{
                    dropView.text = values.last
                    self.viewBeingDragged!.text = ""
                }
                
            }
        }
    }
    
    // Methods for UIDragInteractionDelegate
    
    // Decides what item is used when it is dragged
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        if let textView = interaction.view as? UITextView {
            
            if textView.text == "" {
                return []
            }
            
            let textToDrag = textView.text
            viewBeingDragged = textView
            let provider = NSItemProvider(object: textToDrag! as NSString)
            let item = UIDragItem(itemProvider: provider)
            
            return [item]
        }
        
        return []
    }

}
