//
//  Util.swift
//  StudyLogin
//
//  Created by app on 2022/06/08.
//

import Foundation
import UIKit

open class Util {
    
    static let shared = Util()
    
    open func changeRoot(storyboardName: String, destinationIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: identifier)
        UIApplication.shared.windows.first?.rootViewController = destination
        guard let firstWindow = UIApplication.shared.windows.first else { return }
        UIView.transition(with: firstWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {}) { isCompletion in }
    }
    
}
