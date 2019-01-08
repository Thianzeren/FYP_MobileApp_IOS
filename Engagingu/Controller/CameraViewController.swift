//
//  CameraViewController.swift
//  Engaging U
//
//  Created by Admin on 3/11/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selfieQuestion: UITextView!
    var question: String = ""
    var hotspot: String = ""
    var image: UIImage?
    
    override func viewDidLoad() {
        question = InstanceDAO.selfieDict[hotspot] ?? ""
        selfieQuestion.text = question
        
        super.viewDidLoad()
         // Do any additional setup after loading the view.
       
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        
        var uploadStatus = false
        
        if image != nil{
            
            let urlString = "http://54.255.245.23:3000/upload/uploadSubmission"
            
            guard let url = URL(string: urlString) else {
                print("URL cannot be generated from URLStr")
                return
            }
            
            var request = URLRequest(url: url)//Send your URL here
            print(request)
            
            var jsonDict: [String: String] = ["team_id": InstanceDAO.team_id]
            jsonDict["trail_instance_id"] = InstanceDAO.trail_instance_id
            jsonDict["question"] = question
            jsonDict["hotspot"] = hotspot
            
            let parameters = jsonDict
            print(parameters)
            
            guard let photo = Media(withImage: image!, forKey: "image") else {
                return
            }
            
            let boundary = generateBoundary()
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict) else { return
                print("Error: cannot create jsonData")
            }
            
            let dataBody = createDataBody(withParameters: parameters, media: photo, boundary: boundary, jsonData: jsonData)
            print(dataBody)
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = dataBody
            
            // Send post request
            let semaphore = DispatchSemaphore(value: 0)
            var result: [String:Any] = [:]
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil else{
                    print(error?.localizedDescription ?? "No data")
                    semaphore.signal()
                    return
                }
                
                do{
                    guard let responseDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                        print("Error: no json response received")
                        semaphore.signal()
                        return
                    }
                    
                    print(responseDict)
                    print(result)
                    result = responseDict
                    semaphore.signal()
                    
                }catch let jsonErr{
                    print ("Error serializing json:" + jsonErr.localizedDescription)
                    semaphore.signal()
                }
                
            }
            task.resume();
            semaphore.wait();
            
            if(result["success"] as? String == "true") {
                uploadStatus = true
            }
        }
        
        if(uploadStatus){
            // create the alert
            let alert = UIAlertController(title: "Upload Successful", message: "Image has been uploaded successfully", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                self.performSegue(withIdentifier: "toMapSegue", sender: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }else{
            // create the alert
            let alert = UIAlertController(title: "Upload Unsuccessful", message: "Please reupload your image", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }

        
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String:String]?, media: Media?, boundary: String, jsonData: Data?) -> Data{
        
        let lineBreak = "\r\n"
        let jsonContentType = "application/json"
        var body = Data()
        
        if let parameters = params{
            for (key, value)in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data: name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
                
            }
        }
        
        if let media = media {
            
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data: name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type:: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
            
        }
        
        if let jsonData = jsonData {
            
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data: name=jsonString\"\(lineBreak)")
            body.append("Content-Type:: \(jsonContentType + lineBreak + lineBreak)")
            body.append(jsonData)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var imageBeforeFix = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = fixOrientation(img: imageBeforeFix!)
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Data {
    mutating func append(_ string: String){
        
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
