//
//  IsometricGrid.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


class IsometricGrid: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setAlpha(1)
        context?.setLineWidth(0.1)
        
        let gridSpacingX: CGFloat = 60.0
        let gridSpacingY: CGFloat = 30.0
        let rectWidth   : CGFloat = 60.0
        let rectHeight  : CGFloat = 30.0
        
        for x in stride(from: 0, through: self.frame.width, by: gridSpacingX) {
            for y in stride(from: 0, through: self.frame.height, by: gridSpacingY) {
                
                // RECTANGLES
                context?.stroke(CGRect(x        : x,
                                       y        : y,
                                       width    : rectWidth,
                                       height   : rectHeight))
                
                // DIAGONAL LINES
                context?.move(to: CGPoint(x: x, y: y))
                context?.addLine(to: CGPoint(x: x + rectWidth,
                                             y: y + rectHeight))
                context?.strokePath()
                
                context?.move(to: CGPoint(x: x + rectWidth,
                                          y: y))
                
                context?.addLine(to: CGPoint(x: x,
                                             y: y + rectHeight))
                context?.strokePath()
            }
        }
    }
}
