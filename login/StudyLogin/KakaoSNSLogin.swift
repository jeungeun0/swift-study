//
//  KakaoSNSLogin.swift
//  StudyLogin
//
//  Created by app on 2022/06/13.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AlamofireImage
import Alamofire

class KakaoSNSLogin {
    
    static let shared: KakaoSNSLogin = KakaoSNSLogin()
    
    var success: ((_ user: User?) -> Void)? = { user in
        AlphadoUser.shared.snsKind = .Kakao
        let id = user?.id
        let email = user?.kakaoAccount?.email
        let name = user?.kakaoAccount?.legalName
        let nickName = user?.kakaoAccount?.profile?.nickname
        let imageUrl = user?.kakaoAccount?.profile?.profileImageUrl

        //유저 데이터 저장
        if let id = id {
            AlphadoUser.shared.identifier = String(id)
        }

        AlphadoUser.shared.email = email
        AlphadoUser.shared.name = name
        AlphadoUser.shared.nickName = nickName

        if imageUrl != nil {
            let downloader = ImageDownloader()
            let urlRequest = URLRequest(url: imageUrl!)
            let filter = AspectScaledToFillSizeFilter(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

            downloader.download(urlRequest, filter: filter, completion:  { response in

                print(response.request ?? "")
                print(response.response ?? "")
                debugPrint(response.result)

                if case .success(let image) = response.result {
                    print(image)
                    AlphadoUser.shared.thumbnail = image
                }
            })
        }
        Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
    }
    var failure: ((_ error: AFError) -> Void)? = { error in
//        print(error.localizedDescription)
        
        let alert = UIAlertController(title: "카카오 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
    
    func login() {
        
        //카카오톡 설치 여부 판단
        if UserApi.isKakaoTalkLoginAvailable() {
            //카카오앱을 열어서 로그인
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    //예외처리
                    self.errorAlert(error: error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    if let refreshToken = oauthToken?.refreshToken {
                        UserDefaults.standard.setValue(refreshToken, forKey: "REFRESH_TOKEN")
                        
                        //토큰을 키체인에 저장
                        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                                 kSecAttrService : "AlphadoPetPlus",
                                                 kSecAttrAccount : AlphadoUser.shared.email ?? "",
                                                 kSecAttrGeneric : refreshToken]
                        
                        let isSuccess = SecItemAdd(query as CFDictionary, nil) == errSecSuccess
                        print("is refreshToken save success? = \(isSuccess)")
                    }
                    //doSomthing
                    if let accessToken = oauthToken?.accessToken {
                        UserDefaults.standard.setValue(accessToken, forKey: "ACCESS_TOKEN")
                    }
                    
                    
                    
                    //유저 정보 얻기
                    self.userInfo()
                }
            }
        } else {
            //사파리를 열어서 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    //유저 정보 얻기
                    self.userInfo()
                }
            }
        }
    }
    
    private func userInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                //예외처리
                self.errorAlert(error: error)
            } else {
                print("me() success.")
                if let success = self.success {
                    success(user)
                }
            }
        }
    }
    
    func logout() {
        UserApi.shared.logout { error in
            if let error = error {
                self.errorAlert(error: error)
            } else {
                AlphadoUser.shared.removeAllData()
            }
        }
    }
    
    func disConnect() {
        UserApi.shared.unlink { error in
            if let error = error {
                self.errorAlert(error: error)
            } else {
                AlphadoUser.shared.removeAllData()
            }
        }
    }
    
    func tokenCheck(success: (() -> Void)?, failuer: (() -> Void)?) {
        //이전에 받은 토큰이 있는지 체크
        if AuthApi.hasToken() {
            //hasToken이 true여도 사용자가 현재 로그인 중인지 알 수 없음.
            //앱 내부에 저장 해 둔 토큰과 비교필요?
            
            //토큰 유효성 체크
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        //로그인 필요
                        if let failuer = failuer {
                            failuer()
                        }
                        
                    } else {
                        //기타 에러
                        print(error.localizedDescription)
                    }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    //완료 함수 실행
                    if let success = success {
                        success()
                    }
                }
            }
        } else {
            //이전에 받은 토큰이 없음
            //로그인이 필요
            if let failuer = failuer {
                failuer()
            }
        }
    }
    
    func errorAlert(error: Error) {
        let alert = UIAlertController(title: "카카오 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
}
