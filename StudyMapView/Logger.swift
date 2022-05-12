//
//  Logger.swift
//  StudyMapView
//
//  Created by app on 2022/05/12.
//

import Foundation

class Logger {
    private enum Level: String {
        case e = "🚫"   //Error
        case w = "⚠️"   //Warning
        case i = "ℹ️"   //Info
        case d = "💬"   //Debug
        case v = "🔬"   //Verbose
        case wtf = "💢" //Angry developer
    }
    
    private static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    fileprivate static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func print(_ object: Any) {
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    private class func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    private class func __print(_ object: Any,
                               level: Level = Level.v,
                               filename: String = #file,
                               line: Int = #line,
                               column: Int = #column,
                               funcname: String = #function){
        
        #if DEBUG
        Swift.print("\(Date().toString4()) \(level.rawValue) [\(sourceFileName(filename))]:\(line) \(column) \(funcname) -> \(object)")
        #endif
    }
    
    
    /// "🚫"   Error
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func e(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .e, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    /// "⚠️"   Warning
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func w(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .w, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    /// "ℹ️"   Info
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func i(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .i, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    /// "💬"   Debug
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func d(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .d, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    /// "🔬"   Verbose
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func v(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .v, filename: filename, line: line, column: column, funcname: funcname)
    }
    
    
    /// "💢" Angry developer
    /// - Parameters:
    ///   - object: 디버그창에 띄울 내용
    public class func wtf(_ object: Any,
                        filename: String = #file,
                        line: Int = #line,
                        column: Int = #column,
                        funcname: String = #function){
        __print(object, level: .wtf, filename: filename, line: line, column: column, funcname: funcname)
    }
}

// MARK: Date extension for Logger
fileprivate extension Date {
    
    func toString4() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
