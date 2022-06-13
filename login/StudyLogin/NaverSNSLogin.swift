//
//  NaverLogin.swift
//  StudyLogin
//
//  Created by app on 2022/06/13.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

class NaverSNSLogin: NSObject {
    
    static let shared: NaverSNSLogin = NaverSNSLogin()
    
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    var success: ((_ loginData: NaverLogin) -> Void)? = { loginData in
        AlphadoUser.shared.snsKind = .Naver
        AlphadoUser.shared.email = loginData.response.email
        AlphadoUser.shared.name = loginData.response.name
        AlphadoUser.shared.identifier = loginData.response.id
        Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
    }
    var failure: ((_ error: AFError) -> Void)? = { error in
        print(error.localizedDescription)
    }
    
    struct NaverLogin: Decodable {
        var resultCode: String
        var response: Response
        var message: String
        
        struct Response: Decodable {
            var email: String
            var id: String
            var name: String
        }
        
        enum CodingKeys: String, CodingKey {
            case resultCode = "resultcode"
            case response
            case message
        }
    }
    
    private func getInfo() {
        
        guard let isValidAccessToken = instance?.isValidAccessTokenExpireTimeNow() else {
            //로그인 필요
            login()
            return
        }
        
        if !isValidAccessToken {
            //접근 토큰 갱신 필요
            refreshToken()
            return
        } else {
            userInfo()
        }
    }
    
    func login() {
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    func refreshToken() {
        instance?.delegate = self
        self.instance?.requestAccessTokenWithRefreshToken()
    }
    
    func logout() {
        instance?.delegate = self
        AlphadoUser.shared.removeAllData()
        instance?.resetToken()
    }
    
    func disConnect() {
        instance?.delegate = self
        AlphadoUser.shared.removeAllData()
        instance?.requestDeleteToken()
    }
    
    func userInfo() {
        
        guard let tokenType = instance?.tokenType else { return }
        guard let accessToken = instance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverLogin.self) { [self] response in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let loginData):
                print(loginData.resultCode)
                print(loginData.message)
                print(loginData.response)
                
                if let success = self.success {
                    success(loginData)
                }
                
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                
                if let failure = self.failure {
                    failure(error)
                }
                
                break
            }
        }
    }
}


extension NaverSNSLogin: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        getInfo()
    }
    // 토큰 갱신 성공 시 호출
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        getInfo()
    }
    // 연동해제 성공한 경우 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
    }
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        let alert = UIAlertController(title: "네이버 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
    
}
