//
//  Global.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import Foundation

open class Global {
    static let shared = Global()
    
    var FIRST_REGISTER = ""
    var loginKind: LoginKine?
    
    enum LoginKine {
        case Apple, Kakao, Naver, Email
    }
    
}
