//
//  AlphadoKeyChain.swift
//  StudyLogin
//
//  Created by app on 2022/06/14.
//

import Foundation


class AlphadoKeyChain {
    
    private let lastLoginTypeKey: String = "last_login_type"
    
    /// 토큰을 새로운 키체인을 만들어서 저장
    /// - Parameters:
    ///   - token: 저장할 리프레시 토큰
    ///   - loginKind: 로그인 타입
    /// - Returns: 키체인에 저장 성공 여부
    private func createKeychainForToken(_ token: String, loginType: AlphadoUser.LoginType) -> Bool {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "kr.co.alphado",
                                 kSecAttrAccount : loginType.getName(),
                                 kSecAttrGeneric : token]
        
        UserDefaults.standard.setValue(loginType.getName(), forKey: lastLoginTypeKey)
        
        let isSuccess = SecItemAdd(query as CFDictionary, nil) == errSecSuccess
        print("is refreshToken save success? = \(isSuccess)")
        
        return isSuccess
    }
    
    
    /// 키체인에 해당 로그인 타입으로 저장된 토큰이 존재하면 반환한다
    /// - Parameter loginKind: 로그인 타입
    /// - Returns: 리프레시 토큰
    func readToken() -> String? {
        
        guard let lastLoginType = UserDefaults.standard.string(forKey: lastLoginTypeKey) else {
            return nil
        }
        
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "kr.co.alphado",
                                 kSecAttrAccount : lastLoginType,
                                  kSecMatchLimit : kSecMatchLimitOne,
                            kSecReturnAttributes : true,
                                  kSecReturnData : true]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        guard let existingItem = item as? [CFString : Any],
              let data = existingItem[kSecAttrGeneric] as? String else {
            return nil
        }
        
        return data
    }
    
    func existToken() -> Bool {
        
        guard let lastLoginType = UserDefaults.standard.string(forKey: lastLoginTypeKey) else {
            return false
        }
        
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "kr.co.alphado",
                                 kSecAttrAccount : lastLoginType,
                                  kSecMatchLimit : kSecMatchLimitOne,
                            kSecReturnAttributes : true,
                                  kSecReturnData : true]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return false }
        guard let existingItem = item as? [CFString : Any],
              let _ = existingItem[kSecAttrGeneric] as? String else {
            return false
        }
        
        return true
    }
    
    /// 리프레시 토큰을 키체인에 저장한다.
    /// - Parameters:
    ///   - token: 저장할 리프레시 토큰
    ///   - loginType: 로그인 타입
    /// - Returns: 키체인에 저장 성공 여부
    func saveToken(_ token: String, loginType: AlphadoUser.LoginType) -> Bool {
        guard let lastLoginType = UserDefaults.standard.string(forKey: lastLoginTypeKey) else {
            return self.createKeychainForToken(token, loginType: loginType)
        }
        
        UserDefaults.standard.setValue(loginType.getName(), forKey: lastLoginTypeKey)
        
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "kr.co.alphado",
                                 kSecAttrAccount : lastLoginType]
        
        let attributes: [CFString : Any] = [kSecAttrAccount : loginType.getName(),
                                            kSecAttrGeneric : token]
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }
    
    func deleteToken() -> Bool {
        guard let lastLoginType = UserDefaults.standard.string(forKey: lastLoginTypeKey) else {
            return true
        }
        
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "kr.co.alphado",
                                 kSecAttrAccount : lastLoginType]
        
        UserDefaults.standard.removeObject(forKey: lastLoginTypeKey)
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
}
