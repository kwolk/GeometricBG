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
    
    
    // ENTRYPOINT TO CROSSROADS FOR SHAPE CREATION (RANDOM CHOICE BASED ON PROBABILITIES)
    func generateRandomShape(at touchLocation: CGPoint, firstTime: Bool) {
        
        let randomShapeType = getRandomShape()
        
        switch randomShapeType {
        case .circle    : generateCircle(at: touchLocation, isFirstShape: firstTime)
        case .hexagon   : generateHexagon(at: touchLocation, isFirstShape: firstTime)
        }
    }
    
    // CIRCLE
    private func generateCircle(at touchLocation: CGPoint, isFirstShape: Bool) {
        
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
        
        let shape = UIView(frame: CGRect(x: positionX, y: positionY, width: radius * 2, height: radius * 2))
        shape.layer.cornerRadius = radius
        shape.backgroundColor = randomColour
        
        // SVG : COLOUR DATA
        let randomColourRGBA = getRGBAComponents(randomColour)
        let randomColourSVG = toSVGString(red   : randomColourRGBA.red,
                                          green : randomColourRGBA.green,
                                          blue  : randomColourRGBA.blue,
                                          alpha : randomColourRGBA.alpha)
        
        // SVG : PATH DATA
        svgPathStrings.append("<circle cx=\"\(positionX + radius)\" cy=\"\(positionY + radius)\" r=\"\(radius)\" fill=\"\(randomColourSVG)\" />\n")
        addSubview(shape)
    }
    
    
    
    // HEXAGON (ORIGINAL CODE : HEXAGONS NOT ROUNDED)
//    private func generateHexagon(at touchLocation: CGPoint, isFirstShape: Bool) -> UIView? {
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
//        shapeLayer.cornerRadius = 10.0  // FIXME : CANNOT ROUND CORNERS (MUST APPY MASK)
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
    
    
    // HEXAGON
    // h/t: Hitexa Kakadiya : https://stackoverflow.com/questions/72367918/create-hexagon-design-using-uibezierpath-in-swift-ios
    // FIXME: SVG : HEXAGON CONRNERS NOT ROUNDED && NOT PLACING CORRECTLY IN SVG DATA (EXPORT)
    private func generateHexagon(at touchLocation: CGPoint, isFirstShape: Bool) {
        
        var positionX: CGFloat = 0
        var positionY: CGFloat = 0
        
        if isFirstShape == true {   // ENSURE USER SATISFACTION WITH ONE SHAPE PLACED WHERE FINGER TAPS
            positionX = touchLocation.x
            positionY = touchLocation.y
        } else {
            positionX = CGFloat.random(in: touchLocation.x - 200...touchLocation.x + 200)
            positionY = CGFloat.random(in: touchLocation.y - 200...touchLocation.y + 200)
        }
        
        let randomLength: CGFloat   = CGFloat.random(in: 100...150)
        let randomColour: UIColor   = getRandomColor(withProbabilities: colorProbabilities)
        let rectangle   : CGRect    = CGRect(x: positionX, y: positionY, width: randomLength, height: randomLength)
        let cornerRadius: CGFloat   = 10.0          // ROUNDING CORNER VALUE
        var angle       : CGFloat   = CGFloat(0.5)  // ROTATE HEXAGON 90º
        let sides       : Int       = 6

        let path = UIBezierPath()
        
        var svgPathData = "M" // SVG : PATH DATA (START)
        
        let theta   : CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides)
        let radius  : CGFloat = (rectangle.width + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        let center  : CGPoint = CGPoint(x: rectangle.origin.x + rectangle.width / 2.0,
                                        y: rectangle.origin.y + rectangle.width / 2.0)
        
        // DETERMINE STARTING POINT FOR DRAWING ROUNDED CORNERS
        let corner  : CGPoint = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),
                                        y: center.y + (radius - cornerRadius) * sin(angle))
        
        // MOVE PATH TO NEW POSITION ACCOUNTING FOR THE ROUNDED CORNER ANGLE
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta),
                              y: corner.y + cornerRadius * sin(angle + theta)))
        
        // SVG : POSITIONING DATA
        svgPathData += " \(corner.x) \(corner.y)"

        
        for _ in 0..<sides {
            
            angle += theta
            
            // POINT ON THE CIRCUMFERENCE OF THE CIRCLE : DETERMINED BY THE ANGLE
            let corner  = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),
                                  y: center.y + (radius - cornerRadius) * sin(angle))

            // ONE OF SIX POINTS : DETERMINED BY RADIUS AND ANGLE
            let tip     = CGPoint(x: center.x + radius * cos(angle),
                                  y: center.y + radius * sin(angle))
            
            let start   = CGPoint(x: corner.x + cornerRadius * cos(angle - theta),
                                  y: corner.y + cornerRadius * sin(angle - theta))
            
            let end     = CGPoint(x: corner.x + cornerRadius * cos(angle + theta),
                                  y: corner.y + cornerRadius * sin(angle + theta))

            path.addLine(to: start)
            
            // CONTROL POINT : INFLUENCEA THE SHAPE / DIRECTION OF CURVE
            path.addQuadCurve(to: end, controlPoint: tip)
            
            svgPathData += " \(corner.x) \(corner.y)"   // SVG : POSITIONING DATA
        }
        
        path.close()

        let bounds = path.bounds
        
        // MOVE POINTS IN RELATION TO ORIGINAL RECTANGLE DATA
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rectangle.origin.x / 2.0,
                                          y: -bounds.origin.y + rectangle.origin.y / 2.0)
        path.apply(transform)

        // CREATE UIView WITH CAShapeLayer
        let hexagon      = UIView(frame: rectangle)
        let shapeLayer       = CAShapeLayer()
        shapeLayer.path      = path.cgPath
        shapeLayer.fillColor = randomColour.cgColor
        
        hexagon.layer.addSublayer(shapeLayer)
        
        
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
        addSubview(hexagon)
    }

    
    // HELPER : USE PROBABILITY TO RANDOMLY SELECT SHAPE (CIRCLE || HEXAGON)
    private func getRandomShape() -> ShapeType {
        
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
    
    // HELPER : RANDOMLY CHOOSE COLOUR (BASED ON PROBABILITIES)
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
    
    // HELPER : RGB DATA DEMISTIFYER
    private func getRGBAComponents(_ colour: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        var red     : CGFloat = 0
        var green   : CGFloat = 0
        var blue    : CGFloat = 0
        var alpha   : CGFloat = 0
        
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }

}
