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
    @IBOutlet weak var groupNumber: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNumber.text = "TEAM " + InstanceDAO.team_id
        
        groupInstructions.font = optimisedfindAdaptiveFontWithName(fontName: "Roboto Condensed", message: groupInstructions, minSize: 10, maxSize: 32)
        print("\(String(describing: groupInstructions.font))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func okayBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
        
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
