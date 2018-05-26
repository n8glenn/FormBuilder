//
//  CheckView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/23/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

public enum FBCheckState:Int
{
    case Disabled = 0
    case Unchecked = 1
    case Checked = 2
}

open class CheckView: UIView
{
    var state:FBCheckState = FBCheckState.Unchecked
    
    override open func draw(_ rect: CGRect)
    {
        // Drawing code
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        let scale = UIScreen.main.scale
        let width = 4/scale
        let offset = width/2
        
        context.setLineWidth(width)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0.0 + offset, y: 0.0 + offset))
        context.addLine(to: CGPoint(x: self.frame.height - offset, y: 0.0 + offset))
        context.addLine(to: CGPoint(x: self.frame.height - offset, y: self.frame.height - offset))
        context.addLine(to: CGPoint(x: 0.0 + offset, y: self.frame.height - offset))
        context.addLine(to: CGPoint(x: 0.0 + offset, y: 0.0 + offset))
        context.strokePath()

        if (self.state == FBCheckState.Checked)
        {
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setFillColor(UIColor.gray.cgColor)
            let rect:CGRect = CGRect(x: (self.frame.height / 6.0) + offset,
                                     y: (self.frame.height / 6.0) + offset,
                                     width: self.frame.height - ((self.frame.height / 6.0) * 2) - (offset * 2),
                                     height: self.frame.height - ((self.frame.height / 6.0) * 2) - (offset * 2))
            context.addRect(rect)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }

}
