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
        
        // Make button disappear first
        startBtn.isHidden = true
        startBtn.float()
        // Get socket and add handler
        let socket = SocketHandler.getSocket()
        socket.on("startTrail"){ data, ack in

            print("Start Trail Socket Activated")
            self.indicator.stopAnimating()
            self.startBtn.isHidden = false;

        }

        groupInstructions.font = optimisedfindAdaptiveFontWithName(fontName: "Roboto Condensed", message: groupInstructions, minSize: 10, maxSize: 28)
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
            
            groupNumber.text = "TEAM " + InstanceDAO.team_id
            userStatus.text = "LEADER"
            groupInstructions.text = "Look for your team members while waiting for the trail to start"

        }else {
            
            groupNumber.text = "TEAM " + InstanceDAO.team_id
            userStatus.text = "MEMBER"
            groupInstructions.text = "Look for your team leader and get to know your teammates while waiting for the trail to start"
        }
        
        // Loading screen
        loadWaitScreen()
        
        // Save to session
        saveCredentialsToSession()
        
//        self.startBtn.isHidden = false
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
    
    func saveCredentialsToSession(){
        
        let def = UserDefaults.standard
        def.set(InstanceDAO.team_id, forKey: "team_id")
        def.set(InstanceDAO.trail_instance_id, forKey: "trail_instance_id")
        def.set(InstanceDAO.username, forKey: "username")
        def.set(InstanceDAO.isLeader, forKey: "isLeader")
        def.set(InstanceDAO.completedList, forKey: "completedList")
        def.set(InstanceDAO.startHotspots, forKey: "startHotspots")
        def.synchronize()
        
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
