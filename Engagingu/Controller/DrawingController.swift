//
//  DrawingController.swift
//  Engagingu
//
//  Created by Raylene on 15/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class DrawingController: UIViewController {

    @IBOutlet weak var drawing: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    var lastPoint = CGPoint.zero
    //set to white to initialise color + prevent drawing if the pencil option is not pressed
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var question: String = ""
    var hotspot: String = ""
    
    var lastTouch = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the image so that drawing is disabled until pencil is pressed
        //drawing.isHidden = true
        print(question)
        print(hotspot)
        questionTextView.text = question
        drawing.backgroundColor = UIColor.white
        drawing.layer.borderColor = UIColor.black.cgColor
        drawing.layer.borderWidth = 2
    }
    
    //track the first point of drawing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: drawing)
    }
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
       // UIGraphicsBeginImageContext(drawing.frame.size)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: drawing.frame.width, height: drawing.frame.height),  false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        drawing.image?.draw(in: drawing.bounds)
        
        //Draw from lastPoint to currentPoint
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        // pencil attributes
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(color.cgColor)
        
        // the path is drawn
        context.strokePath()
        
        drawing.image = UIGraphicsGetImageFromCurrentImageContext()
        drawing.alpha = opacity
        UIGraphicsEndImageContext()
    }
    //to keep track if there is a new swipe
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = true
        let currentPoint = touch.location(in: drawing)
        drawLine(from: lastPoint, to: currentPoint)
        
        // updating the lastpoint
        lastPoint = currentPoint
    }
    
    //check if user lift finger off screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            //if lift off means its just draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
    }
    
    @IBAction func clearDrawing(_ sender: Any) {
        drawing.image = nil
    }
    
    @IBAction func pencilPressed(_ sender: UIButton) {
       // drawing.isHidden = false
        guard let pencil = Pencil(tag: sender.tag) else {
            return
        }
        color = pencil.color
        if pencil == .eraser {
            opacity = 1.0
        }
    }
    
    @IBAction func submitDrawing(_ sender: Any) {
        
        var uploadStatus = false
        var image = drawing.image
        image = fixOrientation(img: image!)
        
        if image != nil{
            
            guard let uploadSubmissionURL = InstanceDAO.serverEndpoints["uploadSubmission"] else {
                print("Unable to get server endpoint for uploadSubmission")
                return
            }
            
            guard let url = URL(string: uploadSubmissionURL) else {
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
            
            guard let photo = Media(withImage: image!, forKey: "image",hotspot: hotspot, question: question) else {
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
                self.performSegue(withIdentifier: "toTabBarSegue", sender: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            // Update completed list & isFirstTime
            InstanceDAO.completedList.append(hotspot)
            InstanceDAO.isFirstTime = false
            
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
    
}

