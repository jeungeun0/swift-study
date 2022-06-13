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
                    
                    //doSomthing
                    let accessToken = oauthToken?.accessToken
                    print(accessToken ?? "")
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
    
    func errorAlert(error: Error) {
        let alert = UIAlertController(title: "카카오 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        if let vc = UIApplication.topViewController(base: nil) {
            vc.present(alert, animated: true)
        }
    }
}
