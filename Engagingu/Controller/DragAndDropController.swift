//
//  DragAndDropController.swift
//  Engagingu
//
//  Created by Nicholas on 24/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit
import MobileCoreServices

class DragAndDropController: UIViewController {

    @IBOutlet weak var questionLabel: UITextField!
    
    @IBOutlet weak var dragTextView1: UITextView!
    @IBOutlet weak var dragTextView2: UITextView!
    @IBOutlet weak var dragTextView3: UITextView!
    @IBOutlet weak var dragTextView4: UITextView!
    
    @IBOutlet weak var dropTextView1: UITextView!
    @IBOutlet weak var dropTextView2: UITextView!
    @IBOutlet weak var dropTextView3: UITextView!
    @IBOutlet weak var dropTextView4: UITextView!
    
    
    @IBOutlet weak var dropLabel1: UILabel!
    @IBOutlet weak var dropLabel2: UILabel!
    @IBOutlet weak var dropLabel3: UILabel!
    @IBOutlet weak var dropLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set up textview borders
        dragTextView1.layer.borderWidth = 1
        dragTextView1.layer.borderColor = UIColor.lightGray.cgColor
        dragTextView2.layer.borderWidth = 1
        dragTextView2.layer.borderColor = UIColor.lightGray.cgColor
        dragTextView3.layer.borderWidth = 1
        dragTextView3.layer.borderColor = UIColor.lightGray.cgColor
        dragTextView4.layer.borderWidth = 1
        dragTextView4.layer.borderColor = UIColor.lightGray.cgColor
        
        // Enable User Interaction
        dragTextView1.isUserInteractionEnabled = true
        dragTextView2.isUserInteractionEnabled = true
        dragTextView3.isUserInteractionEnabled = true
        dragTextView4.isUserInteractionEnabled = true
        
//        // Add Drag Interaction
//        dragTextView1.addInteraction(UIDragInteraction(delegate: self))
//        dragTextView2.addInteraction(UIDragInteraction(delegate: self))
//        dragTextView3.addInteraction(UIDragInteraction(delegate: self))
//        dragTextView4.addInteraction(UIDragInteraction(delegate: self))
//
//        // Add Drop Interaction
//        dropTextView1.addInteraction(UIDropInteraction(delegate: self))
//        dropTextView2.addInteraction(UIDropInteraction(delegate: self))
//        dropTextView3.addInteraction(UIDropInteraction(delegate: self))
//        dropTextView4.addInteraction(UIDropInteraction(delegate: self))
        
        
    }

    
}

//extension DragAndDropController: UIDragInteractionDelegate, UIDropInteractionDelegate{

//    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//
//        let textValue = interaction.view as? UITextView
//        let provider = NSItemProvider(object: textValue!.text! as NSString)
//        let item = UIDragItem(itemProvider: provider)
//        return [item]
//
//    }
    
//    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
//        
//        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeText as String]) && session.items.count == 1
//        
//    }
//    
//    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
//        
//        return UIDropProposal(operation: .move)
//        
//    }
//    
//    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
//            session.loadObjects(ofClass: String.self) { (items) in
//                if let values = items as? [String] {
//                    self.dropTextView.text = values.last
//                }
//        }
//        
//    }
    
//}
