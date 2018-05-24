//
//  OptionView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/25/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class OptionView: UIView
{
    var button:UITapGestureRecognizer?
    var labelButton:UITapGestureRecognizer?
    var selectedImage:UIImage?
    var normalImage:UIImage?
    var disabledImage:UIImage?
    var state:FBCheckState = FBCheckState.Unchecked
    var option:FBOption?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        let scale = UIScreen.main.scale
        let width = 4/scale
        //let offset = width/2
        
        context.setLineWidth(width)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setFillColor(UIColor.red.cgColor)
        context.beginPath()
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.height / 2,
                                                         y: self.frame.height / 2),
                                      radius: CGFloat(self.frame.height / 2),
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.white.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 2.5
        self.layer.addSublayer(shapeLayer)
                
        if (self.state == FBCheckState.Checked)
        {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.height / 2,
                                                             y: self.frame.height / 2),
                                          radius: CGFloat(self.frame.height / 2),
                                          startAngle: CGFloat(0),
                                          endAngle:CGFloat(Double.pi * 2),
                                          clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            
            //change the fill color
            shapeLayer.fillColor = UIColor.darkGray.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.darkGray.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 2.5
            self.layer.addSublayer(shapeLayer)
        }
    }
}
