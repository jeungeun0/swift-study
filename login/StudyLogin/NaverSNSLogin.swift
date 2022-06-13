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
    
    //싱글톤 접근 상수
    static let shared: NaverSNSLogin = NaverSNSLogin()
    
    //네이버 로그인 인스턴스
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    //네이버 로그인 성공시 처리
    var success: ((_ loginData: NaverLogin) -> Void)? = { loginData in
        AlphadoUser.shared.snsKind = .Naver
        AlphadoUser.shared.email = loginData.response.email
        AlphadoUser.shared.name = loginData.response.name
        AlphadoUser.shared.identifier = loginData.response.id
        Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
    }
    //네이버 로그인 실패시 처리
    var failure: ((_ error: AFError) -> Void)? = { error in
        print(error.localizedDescription)
    }
    
    //네이버 사용자 정보를 받아올 구조체
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
    
    // 사용자 정보를 받아오기 전에 토큰 체크
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
    
    //로그인 한다.
    func login() {
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    //토큰을 갱신한다.
    func refreshToken() {
        instance?.delegate = self
        self.instance?.requestAccessTokenWithRefreshToken()
    }
    
    //로그아웃한다.
    func logout() {
        instance?.delegate = self
        AlphadoUser.shared.removeAllData()
        instance?.resetToken()
    }
    
    //네이버 로그인 서비스 연결을 해지한다.
    func disConnect() {
        instance?.delegate = self
        AlphadoUser.shared.removeAllData()
        instance?.requestDeleteToken()
    }
    
    //사용자 정보를 받아온다.
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


//MARK: - Naver Login Delegate
extension NaverSNSLogin: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        getInfo()
    }
    // 토큰 갱신 성공 시 호출 됨
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
        getInfo()
    }
    // 연동해제 성공한 경우 호출 됨
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
    }
    // 모든 error인 경우 호출 됨
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        let alert = UIAlertController(title: "네이버 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
    
}
