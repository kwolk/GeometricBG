//
//  OnboardingLocalisation.swift
//  GeometricBG
//
//  Created by Samuel Corke on 26/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation

// CONVERT LOCALISED TEXT WITH SAFETY OF ENUM !
// h/t: Mendy Barouk : https://medium.com/@mendibarouk/enhance-your-localized-capabilities-on-your-ios-applications-d3ba17138077
enum OnboardingLocalisation: String {
    
    case onboarding1, onboarding2, onboarding3, onboarding4, onboarding5a, onboarding5b, onboarding6a, onboarding6b, onboarding7
    
    var localised: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
