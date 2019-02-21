//
//  SubmissionPopUpController.swift
//  Engagingu
//
//  Created by Nicholas on 16/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit
import Photos

class SubmissionPopUpController: UIViewController {

    @IBOutlet weak var hotspotLabel: UILabel!
    //@IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadBtnLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePopUp()
        
    }
    
    
    @IBAction func downloadImage(_ sender: UIButton) {
        
        let snapshot: UIImage = imageView.image!
        let status = PHPhotoLibrary.authorizationStatus()
        
        print(status)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: snapshot)
            }, completionHandler: { success, error in
                if success {
                    print("saved successfully")
                    self.dismiss(animated: true, completion: nil)
                }else if let error = error {
                    print(error)
                }else {
                    print("Failed with no error")
                }
        })
        
    }
    
    func hidePopUp(){
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPopUp))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func dismissPopUp(){
        dismiss(animated: false, completion: nil)
    }
    
}
