//
//  DropDownView.swift
//  FormBuilder
//
//  Created by Nathan Glenn on 1/18/18.
//  Copyright © 2018 Nathan Glenn. All rights reserved.
//

import UIKit

class DropDownView: UIView
{
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
        let width = 2/scale
        let offset = width/2
        
        context.setLineWidth(width)
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0.0, y: 0.0))
        context.addLine(to: CGPoint(x: self.frame.width - offset, y: 0.0))
        context.addLine(to: CGPoint(x: self.frame.width - offset, y: self.frame.height - offset))
        context.addLine(to: CGPoint(x: 0.0, y: self.frame.height - offset))
        context.addLine(to: CGPoint(x: 0.0, y: 0.0))
        context.move(to: CGPoint(x: self.frame.width - (offset + self.frame.height + offset), y: 0.0))
        context.addLine(to: CGPoint(x: self.frame.width - (offset + self.frame.height + offset), y: self.frame.height - offset))
        // draw the diamond on the right
        context.move(to: CGPoint(x: (self.frame.width - self.frame.height) + (self.frame.height / 4), y: self.frame.height / 2))
        context.addLine(to: CGPoint(x: (self.frame.width - frame.height) + (self.frame.height / 2), y: self.frame.height / 4))
        context.addLine(to: CGPoint(x: (self.frame.width - frame.height) + ((self.frame.height / 4) * 3), y: self.frame.height / 2))
        context.addLine(to: CGPoint(x: (self.frame.width - frame.height) + (self.frame.height / 2), y: (self.frame.height / 4) * 3))
        context.addLine(to: CGPoint(x: (self.frame.width - frame.height) + (self.frame.height / 4), y: self.frame.height / 2))
        context.strokePath()
    }
}
