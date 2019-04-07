//  DrawingController.swift
//  Engagingu
import UIKit
//DrawingController allows for user to select different colours of pencil and draw

extension UIButton {
    //design of the pencil button
    func addShadow (color : UIColor){
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.8
        layer.shadowColor = color.cgColor
    }
}

class DrawingController: UIViewController {

    @IBOutlet weak var drawing: UIImageView!
    @IBOutlet weak var questionTextView: UITextView!
    //initialise the pencil properties
    var lastPoint = CGPoint.zero
    var color = UIColor.black
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var question: String = ""
    var hotspot: String = ""
    
    var lastTouch = CGPoint.zero
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var black: UIButton!
    @IBOutlet weak var grey: UIButton!
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var darkBlue: UIButton!
    @IBOutlet weak var lightBlue: UIButton!
    @IBOutlet weak var darkGreen: UIButton!
    @IBOutlet weak var lightGreen: UIButton!
    @IBOutlet weak var brown: UIButton!
    @IBOutlet weak var eraser: UIButton!
    @IBOutlet weak var orange: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var bin: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    //if the role is member, pencil buttons will be hidden
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.float()

        questionTextView.text = question
        drawing.backgroundColor = UIColor.white
        drawing.layer.borderColor = UIColor.black.cgColor
        drawing.layer.borderWidth = 2
        
        if(!InstanceDAO.isLeader){
            color = UIColor.white
            black.isHidden = true
            grey.isHidden = true
            red.isHidden = true
            darkBlue.isHidden = true
            lightBlue.isHidden = true
            darkGreen.isHidden = true
            lightGreen.isHidden = true
            brown.isHidden = true
            eraser.isHidden = true
            orange.isHidden = true
            yellow.isHidden = true
            bin.isHidden = true
            drawing.layer.borderColor = UIColor.white.cgColor
            homeButton.setTitle("Home", for: .normal)
            
        }
    }
    
    //track the first point of drawing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: drawing)
    }
    //Track the last point and current point and connect it
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
    
    //remove all drawings
    @IBAction func clearDrawing(_ sender: Any) {
        clearAllShadows()
        drawing.image = nil
    }
    
    //determine the color of the pencil chosen
    //Sets the colour of the pencil chosen and add shadows to the selected pencil
    @IBAction func pencilPressed(_ sender: UIButton) {
        guard let pencil = Pencil(tag: sender.tag) else {
            return
        }
        color = pencil.color
        if pencil == .eraser {
            opacity = 1.0
        }
        
        //to add shadows to the pencil that was pressed
        if pencil == .black {
            clearAllShadows()
            black.addShadow(color: color)
        }
        
        if pencil == .red {
            clearAllShadows()
            red.addShadow(color: color)
        }
     
        if pencil == .grey {
            clearAllShadows()
            grey.addShadow(color: color)
        }
        if pencil == .darkblue {
            clearAllShadows()
            darkBlue.addShadow(color: color)
        }
        if pencil == .lightBlue {
            clearAllShadows()
            lightBlue.addShadow(color: color)
        }
        if pencil == .darkGreen {
            clearAllShadows()
            darkGreen.addShadow(color: color)
        }
        if pencil == .lightGreen {
            clearAllShadows()
            lightGreen.addShadow(color: color)
        }
        if pencil == .brown {
            clearAllShadows()
            brown.addShadow(color: color)
        }
        if pencil == .orange {
            clearAllShadows()
            orange.addShadow(color: color)
        }
        
        if pencil == .yellow {
            clearAllShadows()
            yellow.addShadow(color: color)
        }
        if pencil == .eraser {
            clearAllShadows()
            //eraser nv use addShadow method as the background will be white when pass in the parameter
            //hence this method below will meke it default black
            eraser.layer.shadowRadius = 5
            eraser.layer.shadowOpacity = 0.8
        }
    }
    
    
    //clear all shadows
    func clearAllShadows (){
        red.layer.shadowRadius = 0
        red.layer.shadowOpacity = 0
        
        black.layer.shadowRadius = 0
        black.layer.shadowOpacity = 0
        
        grey.layer.shadowRadius = 0
        grey.layer.shadowOpacity = 0
        
        darkBlue.layer.shadowRadius = 0
        darkBlue.layer.shadowOpacity = 0
        
        lightBlue.layer.shadowRadius = 0
        lightBlue.layer.shadowOpacity = 0
        
        lightGreen.layer.shadowRadius = 0
        lightGreen.layer.shadowOpacity = 0
        
        darkGreen.layer.shadowRadius = 0
        darkGreen.layer.shadowOpacity = 0
        
        brown.layer.shadowRadius = 0
        brown.layer.shadowOpacity = 0
        
        eraser.layer.shadowRadius = 0
        eraser.layer.shadowOpacity = 0
        
        orange.layer.shadowRadius = 0
        orange.layer.shadowOpacity = 0
        
        yellow.layer.shadowRadius = 0
        yellow.layer.shadowOpacity = 0
        
        bin.layer.shadowRadius = 0
        bin.layer.shadowOpacity = 0
        
    }
    
    // Submits drawing done to backend endpoint
    @IBAction func submitDrawing(_ sender: Any) {
        if (InstanceDAO.isLeader) {
            var uploadStatus = false
            var image = drawing.image
            
            if image != nil{
                image = fixOrientation(img: image!)
                
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
                
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 5
                config.timeoutIntervalForResource = 5
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request) { (data, response, error) in
                    
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
            }else {
                // create the alert
                let alert = UIAlertController(title: "Drawing is blank", message: "Please draw something before submitting", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
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
                let alert = UIAlertController(title: "Failed to upload drawing to server", message: "Please ensure you have good internet connection and try again", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            //member
            InstanceDAO.isFirstTime = false
            performSegue(withIdentifier: "toTabBarSegue", sender: nil)
        }
    } //button method
    
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
