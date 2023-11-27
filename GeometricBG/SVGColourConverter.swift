//
//  SVGColourConverter.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation
import UIKit

// HELPER : CONVERT RGB COLOURS TO SVG FORMATTING
func toSVGString(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> String {
    
    // Ensure the values are within the valid range (0.0 to 1.0)
    let redValue    = max(0.0, min(1.0, red))
    let greenValue  = max(0.0, min(1.0, green))
    let blueValue   = max(0.0, min(1.0, blue))
    let alphaValue  = max(0.0, min(1.0, alpha))
    
    // Extrapolate SVG string formatting from the component data
    let redInt      = Int(redValue * 255)
    let greenInt    = Int(greenValue * 255)
    let blueInt     = Int(blueValue * 255)
    let alphaFloat  = Float(alphaValue)
    
    let svgColourData = String(format: "rgba(%d, %d, %d, %.2f)", redInt, greenInt, blueInt, alphaFloat)
    
    return svgColourData
}
