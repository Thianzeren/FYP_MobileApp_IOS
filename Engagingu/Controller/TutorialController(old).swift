//
//  TutorialController.swift
//  Engagingu
//
//  Created by Raylene on 22/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit

class TutorialController: UIViewController {

  
    @IBOutlet weak var introduction: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeMessage.font = optimisedfindAdaptiveFontWithName(fontName: "Roboto Condensed", message: welcomeMessage, minSize: 10, maxSize: 30)
        print("\(String(describing: welcomeMessage.font))")
        
        introduction.font = optimisedfindAdaptiveFontWithName(fontName: "Roboto Condensed", message: introduction, minSize: 10, maxSize: 30)
        print("\(String(describing: introduction.font))")
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
        
        return UIFont(name: fontName, size: tempMin - 1)
    }


}
