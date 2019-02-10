//
//  TeamAllocationController.swift
//  Engagingu
//
//  Created by Nicholas on 8/11/18.
//  Copyright © 2018 Raylene. All rights reserved.
//

import UIKit

class TeamAllocationController: UIViewController {
    
    @IBOutlet weak var groupInstructions: UILabel!
    @IBOutlet weak var userStatus: UITextField!
    @IBOutlet weak var groupNumber: UITextView!
    @IBOutlet weak var startBtn: UIButton!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.isHidden = true
        
        groupNumber.text = "TEAM " + InstanceDAO.team_id
        
        // Get socket and add handler
        let socket = SocketHandler.getSocket()
        socket.on("startTrail"){ data, ack in

            print("Start Trail Socket Activated")
            self.indicator.stopAnimating()
            self.startBtn.isHidden = false;

        }

        groupInstructions.font = optimisedfindAdaptiveFontWithName(fontName: "Roboto Condensed", message: groupInstructions, minSize: 10, maxSize: 32)
        print("\(String(describing: groupInstructions.font))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Check if user is leader or member
        let user: User = InstanceDAO.userDict[InstanceDAO.username]!
        if user.isLeader == 1{
            InstanceDAO.isLeader = true
        }else {
            InstanceDAO.isLeader = false
        }

        if InstanceDAO.isLeader {

            userStatus.text = "LEADER"
            groupInstructions.text = "Look for your team members while waiting for the trail to start"

        }else {

            userStatus.text = "MEMBER"
            groupInstructions.text = "Look for your team leader and get to know your teammates while waiting for the trail to start"
        }
//
//        loadWaitScreen()
        
        self.startBtn.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func okayBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        
    }
    
    func loadWaitScreen() {

        indicator.frame = CGRect(x: 0, y: -10, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        indicator.startAnimating()
        
    }
    

    //fit to height of label
    func optimisedfindAdaptiveFontWithName(fontName:String, message:UILabel!, minSize:CGFloat,maxSize:CGFloat) -> UIFont!
    {
        
        var tempFont:UIFont
        //var tempHeight:CGFloat
        var tempMax:CGFloat = maxSize
        var tempMin:CGFloat = minSize
        
        while (ceil(tempMin) != ceil(tempMax)){
            let testedSize = (tempMax + tempMin) / 2
            
            
            tempFont = UIFont(name:fontName, size:testedSize)!
            let attributedString = NSAttributedString(string: message.text!, attributes: [NSAttributedString.Key.font : tempFont])
            
            let textFrame = attributedString.boundingRect(with: CGSize(width: message.bounds.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin , context: nil)
            
            let difference = message.frame.height - textFrame.height
            print("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")
            if(difference > 0){
                tempMin = testedSize
            }else{
                tempMax = testedSize
            }
        }
        
        
        //returning the size -1 (to have enought space right and left)
        return UIFont(name: fontName, size: tempMin - 1)
    }
}
