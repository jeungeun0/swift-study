//
//  User.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import Foundation
import UIKit

class User {
    
    static let shared: User = User()
    
    enum LoginKind: Int {
        case Apple = 0
        case Kakao
        case Naver
        case Email
    }
    
    enum UserInfomation: String {
        case email = "이메일"
        case name = "이름"
        case nickName = "닉네임"
        case gender = "성별"
        case age = "연령대"
        case birth = "생일"
        case thumbnail = "썸네일"
        case identifier = "고유번호"
        case snsKind = "SNS로그인종류"
        
        func getKey() -> String {
            switch self {
            case .email:
                return UserInfomation.email.rawValue + "_E-Mail"
            case .name:
                return UserInfomation.name.rawValue + "_Name"
            case .nickName:
                return UserInfomation.nickName.rawValue + "_NickName"
            case .gender:
                return UserInfomation.gender.rawValue + "_Gender"
            case .age:
                return UserInfomation.age.rawValue + "_Age"
            case .birth:
                return UserInfomation.birth.rawValue + "_Birth"
            case .thumbnail:
                return UserInfomation.thumbnail.rawValue + "_Thumbnail"
            case .identifier:
                return UserInfomation.identifier.rawValue + "_Identifier"
            case .snsKind:
                return UserInfomation.snsKind.rawValue + "_LoginKind"
            }
        }
    }
    //TODO: - 키체인으로 바꾸어야 함
    
    var snsKind: LoginKind? {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: UserInfomation.snsKind.getKey())
            let loginKind = LoginKind(rawValue: rawValue)
            return loginKind
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue.rawValue, forKey: UserInfomation.snsKind.getKey())
            }
        }
    }
    var identifier: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.identifier.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.identifier.getKey())
            }
        }
    }
    var email: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.email.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.email.getKey())
            }
        }
    }
    var name: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.name.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.name.getKey())
            }
        }
    }
    var nickName: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.nickName.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.nickName.getKey())
            }
        }
    }
    var gender: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.gender.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.gender.getKey())
            }
        }
    }
    var age: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.age.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.age.getKey())
            }
        }
    }
    var birth: String? {
        get {
            return UserDefaults.standard.string(forKey: UserInfomation.birth.getKey())
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.birth.getKey())
            }
        }
    }
    var thumbnail: UIImage? {
        get {
            return UserDefaults.standard.object(forKey: UserInfomation.thumbnail.getKey()) as? UIImage
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.setValue(newValue, forKey: UserInfomation.thumbnail.getKey())
            }
        }
    }
    
    func removeIdentifier() {
        UserDefaults.standard.removeObject(forKey: UserInfomation.identifier.getKey())
    }
    
    func removeAllData() {
        UserDefaults.standard.removeObject(forKey: UserInfomation.snsKind.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.identifier.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.email.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.name.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.nickName.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.gender.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.age.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.birth.getKey())
        UserDefaults.standard.removeObject(forKey: UserInfomation.thumbnail.getKey())
    }
    
//    init(identifier: String, email: String, name: String? = nil, nickName: String? = nil, gender: String? = nil, age: String? = nil, birth: String? = nil, thumbnail: UIImage? = nil) {
//        self.identifier = identifier
//        self.email = email
//        self.name = name
//        self.nickName = nickName
//        self.gender = gender
//        self.age = age
//        self.birth = birth
//        self.thumbnail = thumbnail
//    }
}
