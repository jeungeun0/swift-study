//
//  User.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import Foundation

class User {
    
    enum UserInfomation: String {
        case email = "이메일"
        case name = "이름"
        case nickName = "닉네임"
        case gender = "성별"
        case age = "연령대"
        case birth = "생일"
        case thumbnail = "썸네일"
    }
    
    let identifier: String
    let email: String
    let name: String?
    let nickName: String?
    let gender: String?
    let age: String?
    let birth: String?
    let thumbnail: String?
    
    init(identifier: String, email: String, name: String? = nil, nickName: String? = nil, gender: String? = nil, age: String? = nil, birth: String? = nil, thumbnail: String? = nil) {
        self.identifier = identifier
        self.email = email
        self.name = name
        self.nickName = nickName
        self.gender = gender
        self.age = age
        self.birth = birth
        self.thumbnail = thumbnail
    }
}
