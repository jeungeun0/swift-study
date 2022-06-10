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
    
    struct AnchorDetail {
        var leading: CGFloat?
        var top: CGFloat?
        var trailing: CGFloat?
        var bottom: CGFloat?
        var width: CGFloat?
        var height: CGFloat?
    }
    
    func makeButton1(target: Any, title: String? = nil, titleColor: UIColor? = nil, borderWidth: CGFloat? = nil, borderColor: CGColor? = nil, action: Selector) -> UIButton {
        let button = UIButton()
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        if let titleColor = titleColor {
            button.setTitleColor(titleColor, for: .normal)
        }
        
        button.layer.cornerRadius = 8
        
        if let borderWidth = borderWidth {
            button.layer.borderWidth = borderWidth
        }
        
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)

        return button
    }
    
    
    func setConstraint(_ with: UIView, source: UIView, anchor: AnchorDetail) {
        source.addSubview(with)
        
        with.translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = anchor.leading {
            with.leadingAnchor.constraint(equalTo: source.leadingAnchor, constant: leading).isActive = true
        }
        if let top = anchor.top {
            with.topAnchor.constraint(equalTo: source.topAnchor, constant: top).isActive = true
        }
        if let trailing = anchor.trailing {
            with.trailingAnchor.constraint(equalTo: source.trailingAnchor, constant: -trailing).isActive = true
        }
        if let bottom = anchor.bottom {
            with.bottomAnchor.constraint(equalTo: source.bottomAnchor, constant: -bottom).isActive = true
        }
        if let height = anchor.height {
            with.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = anchor.width {
            with.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func setConstraints(_ with: [(UIView, AnchorDetail)], source: UIView) {
        
        with.enumerated().forEach { index, item in
            source.addSubview(item.0)
            item.0.translatesAutoresizingMaskIntoConstraints = false
            if let leading = item.1.leading {
                item.0.leadingAnchor.constraint(equalTo: source.leadingAnchor, constant: leading).isActive = true
            }
            if let top = item.1.top {
                item.0.topAnchor.constraint(equalTo: source.topAnchor, constant: top).isActive = true
            }
            if let trailing = item.1.trailing {
                item.0.trailingAnchor.constraint(equalTo: source.trailingAnchor, constant: -trailing).isActive = true
            }
            if let bottom = item.1.bottom {
                item.0.bottomAnchor.constraint(equalTo: source.bottomAnchor, constant: -bottom).isActive = true
            }
            if let height = item.1.height {
                item.0.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            if let width = item.1.width {
                item.0.widthAnchor.constraint(equalToConstant: width).isActive = true
            }
        }
        
    }
    
}

