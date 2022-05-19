//
//  AttrLogic.swift
//  PracticeAndStudyUI
//
//  Created by app on 2022/05/19.
//

import Foundation
import UIKit


/// AttributiedString 관련해서 처리하는 util class
class AttrLogic {
    
    static let shared = AttrLogic()
    
    typealias Attr = [NSAttributedString.Key: Any]
    var currentViewController: UIViewController?
    
    struct AttrElement {
        var font: UIFont? = nil
        var foregroundColor: UIColor? = nil
        var alignment: NSTextAlignment? = nil
        var lineHeight: CGFloat? = nil
        var lineSpacing: CGFloat? = nil
        var kern: CGFloat? = nil
        var strikethroughStyle: NSUnderlineStyle? = nil
        var strikethroughColor: UIColor? = nil
        var underlineStyle: NSUnderlineStyle? = nil
        var underlineColor: UIColor? = nil
        var lineBreakMode: NSLineBreakMode? = nil
    }
    
    func settingAttrsString(from object: UIView, ifButtonState state: UIControl.State? = nil, sourceText: String, elementsOfSourceText: AttrLogic.AttrElement, searchTexts: [String]? = nil, elementsOfsearchTexts: [AttrLogic.AttrElement]? = nil)
    {
        let attrString = getAttrsString(sourceText, elementsOfSourceText: elementsOfSourceText, searchTexts: searchTexts, elementsOfsearchTexts: elementsOfsearchTexts)
        
        setAttrInObject(object, ifButtonState: state, attrString: attrString)
    }
    
    func getAttrsString(_ sourceText: String, elementsOfSourceText: AttrLogic.AttrElement, searchTexts: [String]? = nil, ranges: [NSRange]? = nil, elementsOfsearchTexts: [AttrLogic.AttrElement]? = nil) -> NSMutableAttributedString
    {
        let sourceAttrString = getAttrString(text: sourceText, element: elementsOfSourceText)
        
        var adds: [AttrLogic.Attr]?
        var newRanges: [NSRange]?
        if let elementsOfsearchTexts = elementsOfsearchTexts {
            adds = .init()
            adds = getAttrs(elements: elementsOfsearchTexts)
        }
        if let searchTexts = searchTexts {
            newRanges = .init()
            newRanges = getRanges(sourceText, searchTexts: searchTexts)
        } else if let ranges = ranges {
            newRanges = ranges
        }
        
        guard let adds = adds, let newNewRanges = newRanges else {
            return sourceAttrString
        }

        return addAttrString(sourceAttrString, adds: adds, ranges: newNewRanges)
    }
    
    private func getAttr(element: AttrLogic.AttrElement) -> AttrLogic.Attr {
        let style = NSMutableParagraphStyle()
        var attr = AttrLogic.Attr()
        
        if let alignment = element.alignment {
            style.alignment = alignment
        }
        if let lineHeight = element.lineHeight {
            style.minimumLineHeight = lineHeight
            style.maximumLineHeight = lineHeight
            
            if let font = element.font {
                attr[.baselineOffset] = (lineHeight - font.lineHeight)/4
            }
            
        }
        if let lineSpacing = element.lineSpacing {
            style.lineSpacing = lineSpacing
        }
        
        if let lineBreakMode = element.lineBreakMode {
            style.lineBreakMode = lineBreakMode
        }
        
        if let font = element.font {
            attr[NSAttributedString.Key.font] = font
        }
        if let foregroundColor = element.foregroundColor {
            attr[NSAttributedString.Key.foregroundColor] = foregroundColor
        }
        if let kern = element.kern {
            attr[NSAttributedString.Key.kern] = kern
        }
        
        if let strikethroughStyle = element.strikethroughStyle {
            
            attr[NSAttributedString.Key.strikethroughStyle] = strikethroughStyle.rawValue
        }
        if let strikethroughColor = element.strikethroughColor {
            attr[NSAttributedString.Key.strikethroughColor] = strikethroughColor
        }
        if let underlineColor = element.underlineColor {
            attr[NSAttributedString.Key.underlineColor] = underlineColor
        }
        if let underlineStyle = element.underlineStyle {
            attr[NSAttributedString.Key.underlineStyle] = underlineStyle.rawValue
        }
        
        attr[.paragraphStyle] = style
        
        return attr
    }
    
    private func getAttrString(text txt: String, element: AttrLogic.AttrElement) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: txt, attributes: self.getAttr(element: element))
    }
    
    private func getRanges(_ sourceText: String, searchTexts texts: [String]) -> [NSRange] {
        var ranges = [NSRange]()
        for text in texts {
            let range = (sourceText as NSString).range(of: text, options: .caseInsensitive, range: sourceText.fullRange)
            ranges.append(range)
        }
        return ranges
    }
    
    private func getAttrs(elements: [AttrLogic.AttrElement]) -> [AttrLogic.Attr] {
        var attrs = [AttrLogic.Attr]()
        for element in elements {
            let style = NSMutableParagraphStyle()
            var attr = AttrLogic.Attr()
            
            if let alignment = element.alignment {
                style.alignment = alignment
            }
            if let lineHeight = element.lineHeight {
                style.minimumLineHeight = lineHeight
                style.maximumLineHeight = lineHeight
                
                if let font = element.font {
                    attr[.baselineOffset] = (lineHeight - font.lineHeight)/4
                }
            }
            if let lineSpacing = element.lineSpacing {
                style.lineSpacing = lineSpacing
            }
            
            if let font = element.font {
                attr[NSAttributedString.Key.font] = font
            }
            
            if let foregroundColor = element.foregroundColor {
                attr[NSAttributedString.Key.foregroundColor] = foregroundColor
            }
            
            if let kern = element.kern {
                attr[NSAttributedString.Key.kern] = kern
            }
            
            if let strikethroughStyle = element.strikethroughStyle {
                attr[NSAttributedString.Key.strikethroughStyle] = strikethroughStyle.rawValue
            }
            
            if let strikethroughColor = element.strikethroughColor {
                attr[NSAttributedString.Key.strikethroughColor] = strikethroughColor
            }
            
            if let underlineStyle = element.underlineStyle {
                attr[NSAttributedString.Key.underlineStyle] = underlineStyle.rawValue
            }
            
            if let underlineColor = element.underlineColor {
                attr[NSAttributedString.Key.underlineColor] = underlineColor
            }
            
            attr[NSAttributedString.Key.paragraphStyle] = style
            
            attrs.append(attr)
        }
        
        return attrs
    }
    private func addAttrString(_ attr: NSMutableAttributedString, adds: [AttrLogic.Attr], ranges: [NSRange]) -> NSMutableAttributedString
    {
        for i in 0..<ranges.count {
            adds[i].forEach { (key: NSAttributedString.Key, value: Any) in
                attr.addAttribute(key, value: value, range: ranges[i])
            }
        }
        return attr
    }
    
    private func setAttrInObject(_ object: UIView, ifButtonState state: UIControl.State? = nil, attrString: NSMutableAttributedString)
    {
        if let lbl = object as? UILabel {
            lbl.attributedText = attrString
        } else if let btn = object as? UIButton {
            btn.setAttributedTitle(attrString, for: state ?? .normal)
        } else if let tv = object as? UITextView {
            tv.attributedText = attrString
        }
    }
    
}
