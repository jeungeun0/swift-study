//
//  UIApplication+Extension.swift
//  StudyLogin
//
//  Created by app on 2022/06/13.
//

import Foundation
import UIKit


extension UIApplication {
    
    class func topViewController(base: UIViewController?) -> UIViewController? {
        var base = base
        if base == nil {
            var w: UIWindow?
            if #available(iOS 13.0, *) {
                w = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first{ $0.isKeyWindow }
            } else  {
                w = UIApplication.shared.keyWindow
            }
            
            base = w?.rootViewController
        }
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
}
