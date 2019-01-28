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
    var lastPoint = CGPoint.zero
    //set to white to initialise color + prevent drawing if the pencil option is not pressed
    var color = UIColor.white
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var lastTouch = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide the image so that drawing is disabled until pencil is pressed
        drawing.isHidden = true
    }
    //track the first point of drawing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        swiped = false
        lastPoint = touch.location(in: view)
    }
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        drawing.image?.draw(in: view.bounds)
        
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
        let currentPoint = touch.location(in: view)
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
        drawing.isHidden = false
        guard let pencil = Pencil(tag: sender.tag) else {
            return
        }
        color = pencil.color
        if pencil == .eraser {
            opacity = 1.0
        }
    }
    
    
}

