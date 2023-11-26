//
//  ExportToSVG.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation
import UIKit


// FIXME: AS viewBoxWidth IS THE SAME AS viewWidth THEN IS CAN BE OMITTED AND ANY minX/Y VALUES DO NOT APPLY. BUT THE EXPORTED SVG DOES NOT MIMIC THAT ON SCREEN ?!
func exportToSVG(withWidth viewWidth: CGFloat, withHeight viewHeight: CGFloat) {
    
    var svgData = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"
    
    svgData += "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n"
    svgData += "<svg width=\"\(viewWidth)\" height=\"\(viewHeight)\" xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\">\n"
    
    for svgPathString in svgPathStrings { svgData += "\(svgPathString)" }
    
    svgData += "</svg>"
    
    if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsDirectory.appendingPathComponent("geometricShapesSVG.svg")
        do {
            try svgData.write(to: fileURL, atomically: true, encoding: .utf8)
            print("SVG file saved to: \(fileURL)")
        } catch {
            print("Error saving SVG file: \(error)")
        }
    }
}
