//
//  RequiredView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/27/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class RequiredView: UIView
{

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        let scale = UIScreen.main.scale
        let width = 4/scale
        //let offset = width/2
        
        context.setLineWidth(width)
        context.setStrokeColor(UIColor.red.cgColor)
        context.setFillColor(UIColor.red.cgColor)
        context.beginPath()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2.0,
                                                         y: self.frame.height / 2.0),
                                      radius: CGFloat(self.frame.height / 2.0),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.red.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.5
        
        self.layer.addSublayer(shapeLayer)

    }
    

}
