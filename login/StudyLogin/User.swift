//
//  User.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import Foundation

class User {
    let identifier: String
    let email: String
    let name: String
    
    init(identifier: String, email: String, name: String) {
        self.identifier = identifier
        self.email = email
        self.name = name
    }
}
