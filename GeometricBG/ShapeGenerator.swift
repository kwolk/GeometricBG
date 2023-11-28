//
//  ShapeGenerator.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation
import UIKit


enum ShapeType {
    case circle
    case hexagon
}



class ShapeGenerator: UIView {
    
    // DEFINE COLOURS && RESPECTIVE PROBABILITIES : THE HIGHER THE NUMBER THE GREATER THE PROBABILITY OF OCCURENCE
    private let colorProbabilities: [(UIColor, Int)] = [
        (UIColor(red: 244/255,  green: 177/255, blue: 21/255,   alpha: CGFloat.random(in: 0.1...0.4)), 3),  // YELLOW
        (UIColor(red: 225/255,  green: 84/255,  blue: 115/255,  alpha: CGFloat.random(in: 0.1...0.7)), 2),  // RUBY
        (UIColor(red: 80/255,   green: 159/255, blue: 177/255,  alpha: CGFloat.random(in: 0.1...0.5)), 1),  // TEAL
        (UIColor(red: 253/255,  green: 138/255, blue: 90/255,   alpha: CGFloat.random(in: 0.1...0.5)), 2),  // ORANGE
        (UIColor(red: 110/255,  green: 72/255,  blue: 131/255,  alpha: CGFloat.random(in: 0.1...0.7)), 1)   // PURPLE
    ]
    
    // RANDOMLY CHOOSE BETWEEN CIRCLES AND HEXAGONS (FAVOURING CIRCLES)
    private let shapeProbabilities: [(ShapeType, Int)] = [(ShapeType.circle, 2), (ShapeType.hexagon, 1)]
    
    
    
    func generateRandomShape(at touchLocation: CGPoint, firstTime: Bool) {
        
        let randomShapeType = getRandomShape()
        
        switch randomShapeType {
        case .circle:
            if let circleView = generateCircle(at: touchLocation, isFirstShape: firstTime) {
                //shapes.append(circleView)
                addSubview(circleView)
            }
        case .hexagon:
//            if let hexagonView = generateHexagon(at: touchLocation, isFirstShape: firstTime) {
//                shapes.append(hexagonView)
//                addSubview(hexagonView)
            let hexagonView = generateHexagon(at: touchLocation, isFirstShape: firstTime)
                //shapes.append(hexagonView)
                addSubview(hexagonView)
//            }
        }
    }
    
    // CIRCLE
    private func generateCircle(at touchLocation: CGPoint, isFirstShape: Bool) -> UIView? {
        
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        
        let radius = CGFloat.random(in: 50...130)
        let randomColour = getRandomColor(withProbabilities: colorProbabilities)
        
        if isFirstShape == true {   // ENSURE USER SATISFACTION WITH ONE SHAPE PLACED WHERE FINGER TAPS
            positionX = touchLocation.x - radius
            positionY = touchLocation.y - radius
        } else {
            positionX = CGFloat.random(in: touchLocation.x - 200...touchLocation.x + 200)
            positionY = CGFloat.random(in: touchLocation.y - 200...touchLocation.y + 200)
        }
        
        let shapeView = UIView(frame: CGRect(x: positionX, y: positionY, width: radius * 2, height: radius * 2))
        shapeView.layer.cornerRadius = radius
        shapeView.backgroundColor = randomColour
        
        // SVG : COLOUR DATA
        let randomColourRGBA = getRGBAComponents(randomColour)
        let randomColourSVG = toSVGString(red   : randomColourRGBA.red,
                                          green : randomColourRGBA.green,
                                          blue  : randomColourRGBA.blue,
                                          alpha : randomColourRGBA.alpha)
        
        // SVG : PATH DATA
        //svgPathStrings.append("<circle cx=\"\(positionX)\" cy=\"\(positionY)\" r=\"\(radius)\" fill=\"\(randomColourSVG)\" />\n")
        svgPathStrings.append("<circle cx=\"\(positionX + radius)\" cy=\"\(positionY + radius)\" r=\"\(radius)\" fill=\"\(randomColourSVG)\" />\n")
        //shapes.append(shapeView)
        
        return shapeView
    }
    
    // HEXAGON
//    private func generateHexagon2(at touchLocation: CGPoint, isFirstShape: Bool) -> UIView? {
//
//        var positionX: CGFloat = 0
//        var positionY: CGFloat = 0
//
//        if isFirstShape == true {   // ENSURE USER SATISFACTION WITH ONE SHAPE PLACED WHERE FINGER TAPS
//            positionX = touchLocation.x
//            positionY = touchLocation.y
//        } else {
//            positionX = CGFloat.random(in: touchLocation.x - 200...touchLocation.x + 200)
//            positionY = CGFloat.random(in: touchLocation.y - 200...touchLocation.y + 200)
//        }
//
//        let randomLength = CGFloat.random(in: 50...100)
//        let randomColour = getRandomColor(withProbabilities: colorProbabilities)
//
//        let hexagonPath = UIBezierPath()
//        var svgPathData = "M" // SVG : PATH DATA (START)
//
//        let sideLength: CGFloat = randomLength
//        let rotationOffset: CGFloat = CGFloat.pi / 6.0
//
//        for i in 0..<6 {
//            let angle = rotationOffset + CGFloat(i) * (CGFloat.pi / 3.0)
//            let pointX = positionX + sideLength * cos(angle)
//            let pointY = positionY + sideLength * sin(angle)
//
//            if i == 0 {
//                hexagonPath.move(to: CGPoint(x: pointX, y: pointY))
//                svgPathData += " \(pointX) \(pointY)" // SVG : POSITIONING DATA
//            } else {
//                hexagonPath.addLine(to: CGPoint(x: pointX, y: pointY))
//                svgPathData += " \(pointX) \(pointY)" // SVG : POSITIONING DATA
//            }
//        }
//
//        hexagonPath.close()
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = hexagonPath.cgPath
//        shapeLayer.fillColor = randomColour.cgColor
//        shapeLayer.cornerRadius = 10.0  // FIXME: CANNOT ROUND CORNERS (MUST APPY MASK)
//
//        let hexagonView = UIView(frame: hexagonPath.bounds)
//
//        if isFirstShape == true {   // WORKAROUND : ENSURE USER SATISFACTION WITH ONE SHAPE PLACED WHERE FINGER TAPS
//            hexagonView.frame = CGRect(x: (positionX / 6) / 6, y: (positionY / 6) / 6, width: randomLength * 2, height: randomLength * 2)
//        } else {
//            hexagonView.frame = CGRect(x: positionX, y: positionY, width: randomLength * 2, height: randomLength * 2)
//        }
//
//        hexagonView.layer.addSublayer(shapeLayer)
//
//
//        // SVG : COLOUR DATA
//        let randomColourRGBA = getRGBAComponents(randomColour)
//        let randomColourSVG = toSVGString(red   : randomColourRGBA.red,
//                                          green : randomColourRGBA.green,
//                                          blue  : randomColourRGBA.blue,
//                                          alpha : randomColourRGBA.alpha)
//
//        // SVG : PATH DATA (END)
//        svgPathData += " Z"
//        let pathElement = "<path d=\"\(svgPathData)\" fill=\"\(randomColourSVG)\" /> \n"
//
//        svgPathStrings.append(pathElement)
//
//        return hexagonView
//    }
    
    
    
    
    
    //private func generateHexagon(at touchLocation: CGPoint, isFirstShape: Bool) -> UIView? {
    private func generateHexagon(at touchLocation: CGPoint, isFirstShape: Bool) -> UIView {
    //func createHexagonView(rect: CGRect, rotationOffset: CGFloat = 0.0, cornerRadius: CGFloat = 10.0, lineWidth: CGFloat = 2.0, sides: Int = 6) -> UIView {
        
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        
        if isFirstShape == true {   // ENSURE USER SATISFACTION WITH ONE SHAPE PLACED WHERE FINGER TAPS
            positionX = touchLocation.x
            positionY = touchLocation.y
        } else {
            positionX = CGFloat.random(in: touchLocation.x - 200...touchLocation.x + 200)
            positionY = CGFloat.random(in: touchLocation.y - 200...touchLocation.y + 200)
        }
        
        
        let randomLength = CGFloat.random(in: 100...150)
        let randomColour = getRandomColor(withProbabilities: colorProbabilities)
        
        let rect = CGRect(x: positionX, y: positionY, width: randomLength, height: randomLength)
        let cornerRadius: CGFloat = 10.0
        var angle = CGFloat(0.5) // ROTATE 90º
        let sides = 6
                
        let path = UIBezierPath()
        var svgPathData = "M" // SVG : PATH DATA (START)
        
        let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides)
        //let offset: CGFloat = cornerRadius * tan(theta / 2.0)
        //let width = CGFloat(rect.size.width, rect.size.height)
        
        let center = CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y + rect.width / 2.0)
        let radius = (rect.width + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        //svgPathData += " \(center.x) \(center.y)" // SVG : POSITIONING DATA
        svgPathData += " \(corner.x) \(corner.y)" // Use corner coordinates

        
        for _ in 0..<sides {
            angle += theta
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))

            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
            svgPathData += " \(corner.x) \(corner.y)" // Use corner coordinates
        }
        
        path.close()

        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x / 2.0, y: -bounds.origin.y + rect.origin.y / 2.0)
        path.apply(transform)

        // Create a UIView with CAShapeLayer
        let hexagonView = UIView(frame: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = randomColour.cgColor
        
        hexagonView.layer.addSublayer(shapeLayer)
        
        
        // SVG : COLOUR DATA
        let randomColourRGBA = getRGBAComponents(randomColour)
        let randomColourSVG = toSVGString(red   : randomColourRGBA.red,
                                          green : randomColourRGBA.green,
                                          blue  : randomColourRGBA.blue,
                                          alpha : randomColourRGBA.alpha)

        // SVG : PATH DATA (END)
        svgPathData += " Z"
        let pathElement = "<path d=\"\(svgPathData)\" fill=\"\(randomColourSVG)\" /> \n"

        svgPathStrings.append(pathElement)
        //shapes.append(hexagonView)
        
        return hexagonView
    }

    
    
    func getRandomShape() -> ShapeType {
        
        let totalWeight = shapeProbabilities.reduce(0) { $0 + $1.1 }
        let randomValue = Int.random(in: 1...totalWeight)
        var sum = 0
        
        for (shape, weight) in shapeProbabilities {
            sum += weight
            if randomValue <= sum {
                
                return shape
            }
        }
        
        return ShapeType.circle
    }
    
    private func getRandomColor(withProbabilities probabilities: [(UIColor, Int)]) -> UIColor {
        
        let totalWeight = probabilities.reduce(0) { $0 + $1.1 }
        let randomValue = Int.random(in: 1...totalWeight)
        var sum = 0
        
        for (colour, weight) in probabilities {
            sum += weight
            if randomValue <= sum {
                return colour
            }
        }
        
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)   // BLACK
    }
    
    private func getRGBAComponents(_ colour: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        var red     : CGFloat = 0
        var green   : CGFloat = 0
        var blue    : CGFloat = 0
        var alpha   : CGFloat = 0
        
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }

}
