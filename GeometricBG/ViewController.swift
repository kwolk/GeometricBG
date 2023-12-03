//
//  ViewController.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import UIKit
import Photos


var svgPathStrings: [String] = []  // SHAPE DATA CONVERTED TO SVG FORMAT
var shapes: [UIView] = []
var currentLoopNum: Int = 0         // KEEPS TRACK OF THE CURRENT RANDOM LOOP NUMBER FOR MASS UNDO OPERATION
let iconLight = UserDefaults.standard.bool(forKey: "IconLight") // WORKAROUND : USE TO MONITOR WHICH ICON IS IN USE AS iOS CANNOT CHECK


class ViewController: UIViewController {

    // SHAKE GESTURE BEST MANAGED FROM VC
    override var canBecomeFirstResponder: Bool { return true }
    
    // HIDE TITLE BAR
    override var prefersStatusBarHidden: Bool { return true }
    
    // ONBOARDING VC BEFORE NORMAL LOADING (AVOID CONFLICT)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()

        alternateAppIconByMode()    // BONUS : CHANGE APP ICON TO MATCH MODE
        
        // ONBOARDING : NEW USERS
        if !defaults.bool(forKey: onboardingCheck) {
            let onboardingExperience = Onboarding()
            onboardingExperience.isModalInPresentation = true
            onboardingExperience.modalPresentationStyle = .fullScreen   // iOS 13 ALLOWS VC TO BE SWIPED TO DISSMISS (CLASHES WITH ONBOARDING XP)
            self.present(onboardingExperience, animated: false, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode()
        
        // *.GESTURES
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPress.minimumPressDuration = 0.7
        view.addGestureRecognizer(longPress)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
        
    // GESTURE : TAP
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        
        drawShape(at: touchLocation)
    }
    
    // GESTURE : PRESS
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began && !shapes.isEmpty {  // CANVAS IS NOT BLANK
            if PHPhotoLibrary.authorizationStatus() == .authorized {
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == .authorized {
                        takeScreenshot()
                        self.cameraFlash()
                    }
                })
            }
            //exportToSVG(withWidth: self.view.bounds.width, withHeight: self.view.bounds.height)
        }
    }
    
    // GESTURE : SWIPE
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.up      : isometricOverlay()
            case UISwipeGestureRecognizer.Direction.down    : undoAction(isShake: false)
            case UISwipeGestureRecognizer.Direction.left    : mode(inverted: true)
            case UISwipeGestureRecognizer.Direction.right   : mode()
            default : break
            }
        }
    }
    
    // GESTURE : SHAKE
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake { undoAction(isShake: true) }
    }
    
    private func drawShape(at location: CGPoint) {
        
        let randomNumber: Int = Int.random(in: 1...8)
        currentLoopNum = randomNumber
        var count = 0
        
        for _ in 0..<randomNumber {
            if count == 0 {
                generateShape(atLocation: location, first: true, on: view)
                count += 1
                
            } else if count > 0 {
                generateShape(atLocation: location, on: view)
            }
        }
        if count == randomNumber { count = 0 }  // RESET COUNTER
    }
    
    /// REMOVING SHAPES INDIVIDUALLY WITH A SWIPE DOWN OR SHAKE TO REMOVE ALL (INCLUDING WIRE MESH)
    func undoAction(isShake: Bool) {

        if !shapes.isEmpty && !isShake {
            if let shape = shapes.popLast() {
                deleteAnimation(forSingle: true, shape: shape) {    // ENSURE ANIMATIONS COMPLETE W/@escaping CLOSURE
                    shape.removeFromSuperview()
                }
            }
            if !svgPathStrings.isEmpty {
                svgPathStrings.removeLast()
            }
        } else if !shapes.isEmpty && isShake {
            for _ in 0...currentLoopNum {
                if !shapes.isEmpty {
                    for shape in shapes {
                        deleteAnimation(forSingle: false, shape: shape) {
                            shape.removeFromSuperview() } // COMPLETELY PURGE ALL SHAPES FROM VIEW
                            shapes.removeAll()
                    }
                        if !svgPathStrings.isEmpty {
                            svgPathStrings.removeAll()
                    }
                }
            }
        }
    }
    
    // DETERMINE USER MODE (LIGHT/DARK) AND SWITCH COLOUR PALETE (BONUS : APP ICON TOO)
    func mode(inverted: Bool = false) {
        
        // MIMIC SYSTEM WIDE SETTINGS
        if self.traitCollection.userInterfaceStyle == .light && !inverted {
            changeBackground(toColour: .white)
        } else if self.traitCollection.userInterfaceStyle == .dark && !inverted {
            changeBackground(toColour: .black)
        }
        
        // OVERRIDE SYSTEM WIDE SETTINGS
        if self.traitCollection.userInterfaceStyle == .light && inverted {
            changeBackground(toColour: .black)
        } else if self.traitCollection.userInterfaceStyle == .dark && inverted {
            changeBackground(toColour: .white)
        }
    }
    
    func generateShape(atLocation: CGPoint, first attempt: Bool = false, on view: UIView) {
        
        let shape = ShapeGenerator()
        shape.generateRandomShape(at: atLocation, firstTime: attempt)
        
        shape.alpha = 0.0
        UIView.animate(withDuration: 0.2) { shape.alpha = 1.0 }
        view.addSubview(shape)
        shapes.append(shape)
    }
    
    // EASTER EGG : KEEP SWIPING UPWARD TO MAKE THE LINES MORE VIVID
    func isometricOverlay() {
        
        let isometricGridView = IsometricGrid()
        isometricGridView.backgroundColor = .clear
        isometricGridView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.bringSubviewToFront(isometricGridView)
        shapes.append(isometricGridView)
        view.addSubview(isometricGridView)
    }
    
    //HELPER : SIMULATE CAMERA FLASH
    private func cameraFlash() {
        
        DispatchQueue.main.async {
            let whiteOverlayView = UIView(frame: self.view.bounds)
            whiteOverlayView.backgroundColor = .white
            whiteOverlayView.alpha = 0
            self.view.addSubview(whiteOverlayView)
            
            UIView.animate(withDuration: 0.3, animations: {
                whiteOverlayView.alpha = 1
            }) { (finished) in
                UIView.animate(withDuration: 0.3, animations: {
                    whiteOverlayView.alpha = 0
                })
            }
        }
    }
    
    // HELPER : CHANGE BACKGROUND COLOUR
    private func changeBackground(toColour: UIColor) {
        
        UIView.transition(with      : view,
                          duration  : 0.2,
                          options   : .transitionCrossDissolve,
                          animations: { self.view.backgroundColor = toColour },
                          completion: nil)
    }
    
    // HELPER : SWAP APP ICON TO MATCH MODE (LIGHT/DARK)
    func alternateAppIconByMode() {

        // CHECK TO SEE IT ICON SWITCHING IS SUPPORTED
        if UIApplication.shared.supportsAlternateIcons {
            
            // SET ICON TO MIMIC LIGHT / DARK SETTING (WORKAROUND : ONLY CHANGE IF ICON DIFFERS FROM MODE, TO AVOID NAGGING)
            if self.traitCollection.userInterfaceStyle == .dark && iconLight {
                UIApplication.shared.setAlternateIconName("AppIconDark")
                UserDefaults.standard.set(false, forKey: "IconLight")
            } else if self.traitCollection.userInterfaceStyle == .light && !iconLight {
                UIApplication.shared.setAlternateIconName(nil)  // RESET TO DEFAULT (LIGHT)
                UserDefaults.standard.set(true, forKey: "IconLight")
            }
        }
    }
    
    // REMOVE SHAPE WITH TRANSITION EFFECT
    func deleteAnimation(forSingle sigleShape: Bool, shape: UIView, completion: @escaping () -> Void) {    // @escaping CLOSURE ALLOWS ANIMATIONS CONTINUE UNTIL COMPLETED
                
        UIView.animate(withDuration: 0.2, animations: {
            shape.backgroundColor = .gray
            shape.alpha = 0.2
        })

        // SINGLE SHAPE DROP DOWN (GESTURE : SWIPE DOWN)
        if sigleShape {
            UIView.animate(withDuration: 0.7, animations: {
                shape.frame.origin.y = self.view.frame.height + shape.frame.width
            }) { _ in
                completion()
            }
        // MULTIPLE SHAPES EXPLODE (GESTURE : SHAKE)
        } else {
            // FIXME : EXPANSION FROM TOP LEFT OF VIEW, RATHER THAN CENTRE OF CIRCLEÇ
            UIView.animate(withDuration: 0.7, animations: {
                shape.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }) { _ in
                completion()
            }
        }
    }
    
}

