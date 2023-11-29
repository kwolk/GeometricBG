//
//  OnboardingViewController.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//


import UIKit
import Photos



enum OnboardingMode {
    case onboardingMode1, onboardingMode2, onboardingMode3, onboardingMode4, onboardingMode5, onboardingMode6, onboardingMode7
}

var onboardingRegister: [OnboardingMode : Bool] = [.onboardingMode1 : false,    // ONBOARDING : STEP #1
                                                   .onboardingMode2 : false,
                                                   .onboardingMode3 : false,
                                                   .onboardingMode4 : false,
                                                   .onboardingMode5 : false,
                                                   .onboardingMode6 : false,
                                                   .onboardingMode7 : false]


let onboarding1Text: String     = OnboardingLocalisation.onboarding1.localised
let onboarding2Text: String     = OnboardingLocalisation.onboarding2.localised
let onboarding3Text: String     = OnboardingLocalisation.onboarding3.localised
let onboarding4Text: String     = OnboardingLocalisation.onboarding4.localised
let onboarding5aText: String    = OnboardingLocalisation.onboarding5a.localised
let onboarding5bText: String    = OnboardingLocalisation.onboarding5b.localised
let onboarding6aText: String    = OnboardingLocalisation.onboarding6a.localised
let onboarding6bText: String    = OnboardingLocalisation.onboarding6b.localised
let onboarding7Text: String     = OnboardingLocalisation.onboarding7.localised

private var onboardingText: [UILabel] = []    // ONBOARDING : TEXT
private var onboardingShapes: [UIView]  = []    // ONBOARDING : SHAPES

let onboardingCheck: String = "onboardingFin"
let defaults = UserDefaults.standard


// ONBOARDING : STEP #1 (onboardingMode1)
// PULCING "TAP" TEXT ENTICES INTERACTION TO CREATE SHAPES
//
// ONBOARDING : STEP #2 (onboardingMode2)
// HOLD TO TAKE A SCREEN SHOT (PERMISSIONS)
//
// ONBOARDING : STEP #3 (onboardingMode3)
// SWIPE ONE OF THE COLOURED SHAPES DOWN TO DISAPPEAR
//
// ONBOARDING : STEP #4 (onboardingMode4)
// SHAKE TO REMOVE ALL
//
// ONBOARDING : STEP #5 (onboardingMode5)
// DARK <-> LIGHT MODE
//
// ONBOARDING : STEP #6 (onboardingMode6)
// ENJOY ! (FIN : CLEAN UP)
//


class Onboarding: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // SHAKE GESTURE BEST MANAGED FROM VC
    override var canBecomeFirstResponder: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingModeDark()
        
        defaults.set(false, forKey: onboardingCheck)
                
    
        let onboardingTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(onboardingTapGesture)
        
        let onboardingLongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        onboardingLongPress.minimumPressDuration = 0.7
        view.addGestureRecognizer(onboardingLongPress)
        
        let onboardingSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(onboardingSwipeGesture))
        onboardingSwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(onboardingSwipeDown)
        
        let onboardingSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onboardingSwipeGesture))
        onboardingSwipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(onboardingSwipeLeft)
        
        let onboardingSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onboardingSwipeGesture))
        onboardingSwipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(onboardingSwipeRight)
        
        setOnboardingMode(to: .onboardingMode1)
    }
    
    private func onboarding1(_ view: UIView) { generateOnboardingLabel(withText: onboarding1Text,           onview: view) }
    private func onboarding2(_ view: UIView) { generateOnboardingLabel(withText: onboarding2Text,           onview: view) }
    private func onboarding3(_ view: UIView) { generateOnboardingLabel(withText: onboarding3Text,           onview: view) }
    private func onboarding4(_ view: UIView) { generateOnboardingLabel(withText: onboarding4Text,           onview: view) }
    private func onboarding5(_ view: UIView) { generateOnboardingLabel(withText: entryQuestionForMode(),    onview: view) }
    private func onboarding6(_ view: UIView) { generateOnboardingLabel(withText: partingQuestionForMode(),  onview: view) }
    private func onboarding7(_ view: UIView) { generateOnboardingLabel(withText: onboarding7Text,           onview: view, selfDestruct: true) }
    
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: view)
        
        drawOnboardingShape(at: touchLocation)
    }
    
    
    @objc private func onboardingSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down :
                
                onboardingUndoAction(isShake: false)
                
            case UISwipeGestureRecognizer.Direction.left :
                
                // ONBOARDING : SAMPLE DIFFERENT MODES (LIGHT/DARK)
                if getOnboardingMode() == .onboardingMode5 {
                    onboardingModeDark(inverted: true)
                    setOnboardingMode(to: .onboardingMode6)
                }
                
            case UISwipeGestureRecognizer.Direction.right :
                
                // ONBOARDING : ONCE MODE HAS FLIPPED THEN DISABLE
                if getOnboardingMode() == .onboardingMode6 {
                    onboardingModeDark()
                    removeOnboardingLabel()
                    setOnboardingMode(to: .onboardingMode7)
                }
                
            default : break
            }
        }
    }
    
    // ONBOARDING : STEP #1
    private func drawOnboardingShape(at location: CGPoint) {
        
        if getOnboardingMode() == .onboardingMode1 {
            var count = 0
            DispatchQueue.main.async {
            for _ in 0...10 {
                if count == 0 {
                    self.generateOnboardingShape(atLocation: location, first: true, on: self.view)
                    count += 1
                } else if count > 0 {
                    self.generateOnboardingShape(atLocation: location, on: self.view)
                    count += 1
                    // ONBOARDING : ONCE USER TAPS SCREEN DISABLE TAPS
                    if self.getOnboardingMode() == .onboardingMode1 && count == 10 {
                        // WORKAROUND : IF ONBOARDING QUIT PREMATURELY BUT PHOTO LIBRARY ACCESS PREVIOUSLY DENIED, THEN DO NOT ASK AGAIN
                        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                            self.setOnboardingMode(to: .onboardingMode2)
                        } else if PHPhotoLibrary.authorizationStatus() == .denied || PHPhotoLibrary.authorizationStatus() == .authorized {
                            self.setOnboardingMode(to: .onboardingMode3)
                        }
                    }
                }
            }
            }
        }
    }
    
    
    // ONBOARDING : STEP #2
    @objc private func longPress(_ sender: UILongPressGestureRecognizer) {
        
        if getOnboardingMode() == .onboardingMode2 {
            if sender.state == .began {
                // IF PRIVACY REQUEST ONLY ONCE
                if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if status == .authorized {
                            takeScreenshot()
                            self.simulateScreenshotFlash()
                            //TODO: EXPORT SVG TO iCLOUD
                            //exportToSVG(withWidth: self.view.bounds.width, withHeight: self.view.bounds.height)
                            
                                DispatchQueue.main.async {
                                    self.setOnboardingMode(to: .onboardingMode3)
                                }
                            } else if status == .denied {
                                DispatchQueue.main.async {
                                self.setOnboardingMode(to: .onboardingMode3)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    // ONBOARDING : STEP #3 && #4
    private func onboardingUndoAction(isShake: Bool) {
        
        if !onboardingShapes.isEmpty && !isShake {
            if getOnboardingMode() == .onboardingMode3 {
                let shape = onboardingShapes.popLast()
                shape?.removeFromSuperview()
                if !svgPathStrings.isEmpty {
                    svgPathStrings.removeLast()
                }
                // ONBOARDING : ONCE USER SWIPES SHAPE DISABLE SWIPING
                setOnboardingMode(to: .onboardingMode4)
            }
        } else if !onboardingShapes.isEmpty && isShake {
            
            for _ in 0...10 {
                if !onboardingShapes.isEmpty {
                    if getOnboardingMode() == .onboardingMode4 {
                        let shape = onboardingShapes.popLast()
                        shape?.removeFromSuperview()
                        if !svgPathStrings.isEmpty {
                            svgPathStrings.removeLast()
                        }
                    }
                }
            }
            // ONBOARDING : ONCE USER SWIPES DOWN, DISABLE
            if getOnboardingMode() == .onboardingMode4 {
                setOnboardingMode(to: .onboardingMode5)
            }
        }
    }
    
    
    // ONBOARDING : STEP #4 (REFERENCE ABOVE)
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if getOnboardingMode() == .onboardingMode4 {
            if motion == .motionShake {
                onboardingUndoAction(isShake: true)
            }
        }
    }
    
    // ONBOARDING : STEP #5 (DARK / LIGHT MODE)
    func onboardingModeDark(inverted: Bool = false) {
        
        // NORMAL FUNCTIONALITY TO MIMIC USER MODE SETTINGS
        if self.traitCollection.userInterfaceStyle == .light && !inverted {
            changeBackground(toColour: .white)
        } else if self.traitCollection.userInterfaceStyle == .light && inverted {
            changeBackground(toColour: .black)
        }
        
        // WORKAROUND : ONBOARDING REQUIRES DEMO OF ALTERNATE MODE, SO INVERSION IS TEMPORARILY NEEDED
        if self.traitCollection.userInterfaceStyle == .dark && !inverted {
            changeBackground(toColour: .black)
        } else if self.traitCollection.userInterfaceStyle == .dark && inverted {
            changeBackground(toColour: .white)
        }
    }
    
    // ONBOARDING : STEP #6 (FIN : CLEAN-UP)
    private func onboardingCleanUp() {
        
        onboardingText.removeAll()
        onboardingShapes.removeAll()
        
        // ENSURE ONBOARDING DOES NOT SHOW UP AGAIN
        if !defaults.bool(forKey: onboardingCheck) { defaults.set(true, forKey: onboardingCheck) }
        
        // EXIT ONBOARDING
        let normalViewController = ViewController()
        normalViewController.modalPresentationStyle = .fullScreen
        self.present(normalViewController, animated: false, completion: nil)
    }
    
    
    private func generateOnboardingLabel(withText: String, onview: UIView, selfDestruct: Bool = false) {
        
        DispatchQueue.main.async {
            let width   : CGFloat = 300 // SAFE FOR OLDER (SMALLER) iDEVICES
            let height  : CGFloat = 100
            let centreX : CGFloat = ((self.view.bounds.width / 2) - (width / 2))
            let centreY : CGFloat = ((self.view.bounds.height / 2) - (height / 2))
            let offset  : CGFloat = centreY / 5 // OPTICAL ILLUSION : LOWER WHITE SPACE MORE PLEASING
            let location: CGPoint = CGPoint(x: centreX, y: centreY - offset)
            
            let textLabel                       = UILabel()
            textLabel.text                      = withText
            textLabel.textColor                 = UIColor.lightGray
            textLabel.font                      = UIFont.systemFont(ofSize: 30)
            textLabel.numberOfLines             = 0
            textLabel.alpha                     = 0
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor        = 0.5
            textLabel.textAlignment             = .center

            textLabel.frame = CGRect(x      : location.x,
                                     y      : location.y,
                                     width  : width,
                                     height : 0)
            
            // CALCULATE BEST SIZE FOR INDIVIDUAL iDEVICE
            let sizeThatFits = textLabel.sizeThatFits(CGSize(width: width,
                                                             height: CGFloat.greatestFiniteMagnitude))
            
            textLabel.frame.size.height = sizeThatFits.height   // PREVENT TEXT GOING OFF SCREEN (LOCALISATION)
            
            
            // SMOOTH APPEAR
            UILabel.animate(withDuration: 1) { textLabel.alpha = 0.8 }
            
            if selfDestruct {
                UILabel.animate(withDuration: 1.0,
                                delay       : 0.5,
                                animations  : { textLabel.alpha = 0.0 }) { (finished) in
                                    
                                    textLabel.alpha = 0.8
                                    textLabel.removeFromSuperview()
                                    self.onboardingCleanUp()    // WORKAROUND : I HAD TO PLACE THIS HERE FOR THE FADE EFFECT TO FINISH IN TIME
                }
            }
            onboardingText.append(textLabel)
            self.view.addSubview(textLabel)
        }
    }
    
    private func generateOnboardingShape(atLocation: CGPoint, first attempt: Bool = false, on view: UIView) {
        
        let shape = ShapeGenerator()
        shape.generateRandomShape(at: atLocation, firstTime: attempt)
        
        shape.alpha = 0.0
        UIView.animate(withDuration: 0.2) { shape.alpha = 0.4 }
        view.addSubview(shape)
        onboardingShapes.append(shape)
    }
    
    // FIXME: I WOULD LIKE TO FADE OUT, BUT I CANNOT KNOW AT WHAT POINT THE FADE ANIMATION IS AT TO START THAT FADE FROM
    private func removeOnboardingLabel() {
        
        for label in onboardingText {
            DispatchQueue.main.async {
                label.removeFromSuperview()
            }
        }
        if !onboardingText.isEmpty { onboardingText.removeAll() }
    }
    
    // WORKAROUND : SCREEN "FLASH"
    private func simulateScreenshotFlash() {
        
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
    
    // HELPER : SET EVERY ONBOARDING VALUE TO FALSE
    private func setOnboardingMode(to mode: OnboardingMode) {
        
        removeOnboardingLabel()
        
        // ENSURE EVERY OTHER MODE IS SET TO FALSE OTHER THAN THE ONE CHANGED TO TRUE
        onboardingRegister = Dictionary(uniqueKeysWithValues: onboardingRegister.map { key, _ in
            return (key, key == mode)
        })
        
        instigateOnboardingMode(getOnboardingMode())
    }
    
    // HELPER : GET CURRENT ONBOARDING STATE
    private func getOnboardingMode() -> OnboardingMode { return onboardingRegister.first(where: { $0.value == true })?.key ?? .onboardingMode1 }
    
    // HELPER : CHANGE BACKGROUND COLOUR
    private func changeBackground(toColour: UIColor) {
        
        UIView.transition(with      : view,
                          duration  : 0.2,
                          options   : .transitionCrossDissolve,
                          animations: { self.view.backgroundColor = toColour },
                          completion: nil)
    }
    
    private func instigateOnboardingMode(_ mode: OnboardingMode) {
        
        switch mode {
        case .onboardingMode1 : onboarding1(view)
        case .onboardingMode2 : onboarding2(view)
        case .onboardingMode3 : onboarding3(view)
        case .onboardingMode4 : onboarding4(view)
        case .onboardingMode5 : onboarding5(view)
        case .onboardingMode6 : onboarding6(view)
        case .onboardingMode7 : onboarding7(view)
        }
    }
    
    // HELPER : SWITCH TEXT FOR LIGHT/DARK MODE : ENTRY
    private func entryQuestionForMode() -> String { return self.traitCollection.userInterfaceStyle == .light ? onboarding5aText : onboarding5bText }
    
    // HELPER : SWITCH TEXT FOR LIGHT/DARK MODE : EXIT
    private func partingQuestionForMode() -> String { return self.traitCollection.userInterfaceStyle == .light ? onboarding6aText : onboarding6bText }
}
