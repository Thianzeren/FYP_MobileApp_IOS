//
//  CameraViewController.swift
//  Engaging U
//
//  Created by Admin on 3/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var hotspot: String = ""
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        let question = InstanceDAO.selfieDict[hotspot]
        
        
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        
        pickerController.sourceType = UIImagePickerController.SourceType.camera
        pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate

       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicture(_ sender: Any) {
        present(pickerController, animated: true, completion: nil)
    }
}

extension CameraViewController : UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("The camera is now closed")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true, completion: nil)
        //always error here -- >imageView.image = info[UIImagePickerController.originalImage] as? UIimageView
        //imageView.view = info[UIImagePickerControllerOriginalImage] as? UIImageView
    }
   
}
//extension ViewController: UINavigationControllerDelegate{
//    
//}
