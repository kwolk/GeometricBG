//
//  Screenshot.swift
//  GeometricBG
//
//  Created by Samuel Corke on 06/11/2023.
//  Copyright © 2023 CorkeProjects. All rights reserved.
//

import Foundation
import Photos
import UIKit


func takeScreenshot() {

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

    // CREATE AN IMAGE CONTECT WITH THE SCREEN SIZE
    UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0.0)
    
    if let context = UIGraphicsGetCurrentContext() {
        // GET CURRENT VIEW LAYER
        DispatchQueue.main.async {
            if let currentView = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                
                // RENDER CURRENT VIEW LAYER INTO THE CONTEXT
                currentView.layer.render(in: context)
                
                if let screenshot = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    
                    // PRIVACY CHECK : ACCESS PHOTO LIBRARY
                    PHPhotoLibrary.requestAuthorization { status in
                        if status == .authorized {
                            
                            // SAVE SCREENSHOT TO LIBRARY
                            PHPhotoLibrary.shared().performChanges({
                                PHAssetChangeRequest.creationRequestForAsset(from: screenshot)
                            }) { success, error in
                                if success {
                                    print("Screenshot saved to Photo Library.")
                                } else if let error = error {
                                    print("Error saving screenshot: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            print("Permission to access Photo Library denied.")
                        }
                    }
                }
            }
        }
    }
    }
}
