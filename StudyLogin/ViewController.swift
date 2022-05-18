//
//  ViewController.swift
//  StudyLogin
//
//  Created by app on 2022/05/16.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var loginStatusLabel: UILabel!
    @IBOutlet weak var tokenExpireDateLabel: UILabel!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let loginInstance = loginInstance else { return }
        loginInstance.delegate = self
        
        if loginInstance.accessToken != nil {
            self.loginStatusLabel.text = "로그인 중"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            self.tokenExpireDateLabel.text = formatter.string(from: loginInstance.accessTokenExpireDate)
            print(loginInstance.getVersion())
            print(loginInstance.refreshToken)
            print(loginInstance.isValidAccessTokenExpireTimeNow())
//            loginInstance?.requestAccessTokenWithRefreshToken()
        } else {
            self.loginStatusLabel.text = "로그아웃 중"
            self.tokenExpireDateLabel.text = ""
        }
    }
    
    @IBAction func login(_ sender: Any) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logout(_ sender: Any) {
        loginInstance?.requestDeleteToken()
    }

    //RESTful API, id가져오기
    func getInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken { return }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        struct NaverLogin: Decodable {
            var resultCode: String
            var response: Response
            var message: String
            
            struct Response: Decodable {
                var email: String
                var id: String
            }
            
            enum CodingKeys: String, CodingKey {
                case resultCode = "resultcode"
                case response
                case message
            }
        }
        
        req.responseDecodable(of: NaverLogin.self) { response in
            print(response)
            print(response.result)
            
            switch response.result {
            case .success(let loginData):
                print(loginData.resultCode)
                print(loginData.message)
                print(loginData.response)
                
                self.emailLabel.text = loginData.response.email
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                break
            }
        }
        
//        req.responseJSON { response in
//
//            print(response)
//
//            guard let result = response.value as? [String: Any] else { return }
//
//            print(result)
//            guard let object = result["response"] as? [String: Any] else { return }
//            print(object)
////            guard let name = object["name"] as? String else { return }
//            guard let email = object["email"] as? String else { return }
////            guard let id = object["id"] as? String else {return}
//
//            print(email)
//
////            self.idLabel.text = id
////            self.nameLabel.text = name
//            self.emailLabel.text = email
//        }
    }

}


extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    //로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success Login")
        getInfo()
    }
    
    //refresh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    //로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    //모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailAuthorizationWithRecieveType receiveType: THIRDPARTYLOGIN_RECEIVE_TYPE) {
        switch receiveType {
        case SUCCESS:
            /**
             성공적으로 결괏값을 받은 경우
             라이브러리에서 인증 코드를 이용해 접근 토큰과 갱신 토큰을 받기 위해서 자동으로 네이버 서버를 호출합니다.
             */
            break
        case PARAMETERNOTSET:
            /**
             파라미터가 설정되지 않은 경우
             */
            break
        case CANCELBYUSER:
            
            break
        case NAVERAPPNOTINSTALLED: break
        case NAVERAPPVERSIONINVALID: break
        case OAUTHMETHODNOTSET: break
        default:
            break
        }
    }
    
    
}
