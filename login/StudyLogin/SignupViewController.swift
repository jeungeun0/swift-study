//
//  SignupViewController.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AlamofireImage
import Alamofire

class SignUpViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var signupStackView: UIStackView!
    var appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        signupStackView.arrangedSubviews.forEach { view in
            signupStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        addButton()
    }
    
    func addButton() {
        var underButtonCount: CGFloat = 0
        addAppleButton(underButtonCount)
        underButtonCount += 1
        addEmailButton(underButtonCount)
        underButtonCount += 1
        addKakaoButton(underButtonCount)
        underButtonCount += 1
        addNaverButton(underButtonCount)
    }
    
    
    func getBottomAnchorConstant(_ underButtonCount: CGFloat) -> CGFloat {
        let innerSpacing: CGFloat = 15
        let buttonHeight: CGFloat = 50
        let spacing: CGFloat = 24 + (innerSpacing * underButtonCount)
        let heightOfOtherButtons: CGFloat = buttonHeight * underButtonCount
        let bottom = spacing + heightOfOtherButtons
        return bottom
    }
    
    //일반 email 회원가입 버튼
    func addEmailButton(_ underButtonCount: CGFloat) {
        
        let button = Util.shared.makeButton1(target: self, title: "E-Mail 회원가입", titleColor: .black, borderWidth: 1, borderColor: UIColor.black.cgColor, action: #selector(signupEmail))
        Util.shared.setConstraint(button, source: self.view, anchor: Util.AnchorDetail(leading: 24, top: nil, trailing: 24, bottom: getBottomAnchorConstant(underButtonCount), width: nil, height: 50))
    }
    
    //Apple ID 로그인 버튼 생성
    func addAppleButton(_ underButtonCount: CGFloat) {
        let button = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        button.addTarget(self, action: #selector(self.appleSignUpButtonPress), for: .touchUpInside)
        
        Util.shared.setConstraint(button, source: self.view, anchor: Util.AnchorDetail(leading: 24, top: nil, trailing: 24, bottom: getBottomAnchorConstant(underButtonCount), width: nil, height: 50))
    
    }
    
    func addKakaoButton(_ underButtonCount: CGFloat) {
        
        let imageView = UIImageView(image: UIImage(named: "kakao_login_large"))
        let button = Util.shared.makeButton1(target: self, action: #selector(signupKakao))
        let anchor = Util.AnchorDetail(leading: 24, top: nil, trailing: 24, bottom: getBottomAnchorConstant(underButtonCount), width: nil, height: 50)
        Util.shared.setConstraints([(imageView, anchor), (button, anchor)], source: self.view)
        
    }
    
    func addNaverButton(_ underButtonCount: CGFloat) {
        let imageView = UIImageView(image: UIImage(named: "btnG_완성형"))
        let button = Util.shared.makeButton1(target: self, action: #selector(signupNaver))
        let anchor = Util.AnchorDetail(leading: 24, top: nil, trailing: 24, bottom: getBottomAnchorConstant(underButtonCount), width: nil, height: 50)
        Util.shared.setConstraints([(imageView, anchor), (button, anchor)], source: self.view)
    }
    
    @objc func signupEmail() {
        let alert = UIAlertController(title: "준비중", message: "해당 서비스는 준비중입니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @objc func appleSignUpButtonPress() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func signupKakao() {
        //카카오톡 설치여부
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    //예외처리
                    debugPrint(error.localizedDescription)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    //doSomthing
                    let accessToken = oauthToken?.accessToken
                    print(accessToken ?? "")
                    UserApi.shared.me { user, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("me() success.")
                            
                            let id = user?.id
                            let email = user?.kakaoAccount?.email
                            let name = user?.kakaoAccount?.legalName
                            let nickName = user?.kakaoAccount?.profile?.nickname
                            let imageUrl = user?.kakaoAccount?.profile?.profileImageUrl
                            
                            //유저 데이터 저장
                            if let id = id {
                                User.shared.identifier = String(id)
                            }
                            
                            User.shared.email = email
                            User.shared.name = name
                            User.shared.nickName = nickName
                            
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
                                        User.shared.thumbnail = image
                                    }
                                })
                            }
                            
                            Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
                            
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    //doSomething
                    UserApi.shared.me { user, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("me() success.")
                            
                            let id = user?.id
                            let email = user?.kakaoAccount?.email
                            let name = user?.kakaoAccount?.legalName
                            let nickName = user?.kakaoAccount?.profile?.nickname
                            let imageUrl = user?.kakaoAccount?.profile?.profileImageUrl
                            
                            //유저 데이터 저장
                            if let id = id {
                                User.shared.identifier = String(id)
                            }
                            
                            User.shared.email = email
                            User.shared.name = name
                            User.shared.nickName = nickName
                            
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
                                        User.shared.thumbnail = image
                                    }
                                })
                            }
                            Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
                            
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func signupNaver() {
        NaverSNSLogin.shared.login()
    }
    
}

//MARK: -Apple Login
extension SignUpViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            //Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            //계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let familyName = appleIDCredential.fullName?.familyName
            let givenName = appleIDCredential.fullName?.givenName
            let middleName = appleIDCredential.fullName?.middleName
            let nickname = appleIDCredential.fullName?.nickname
            let email = appleIDCredential.email
            var name = ""
            
            //성, 이름은 바꾼대로 나옴 ==> 홍길동, 김첨지 등
            /**
             # 나라별 이름순서 출처
             https://en.wikipedia.org/wiki/Personal_name#Eastern_name_order
             https://www.reddit.com/r/MapPorn/comments/c14fha/naming_traditions_across_the_world/
             http://help.ads.microsoft.com/#apex/18/ko/10004/-1
             https://speckofdust.tistory.com/71
             
             # 서양식, 동양식 이름 표기법
             1. John 2. Franlkin 3.Kennedy
             1.홍 2. 길동
             ==> John: 태어나서 붙여진 이름 (한국으로 치면 길동과 같음) = First Name(맨 앞에 오기 때문에) | Given Name(태어나서 붙여진 이름이기 때문에)
             ==> Franklin: 세례명 = Middle Name(가운데 오기 때문에) | Christian Name
             ==> Kennedy: 성 (한국으로 치면 홍과 같음) = Family Name(온 가족이 같은 이름으로 쓰기 때문에) | Last Name(마지막에 오기 때문에) | Sur Name(성)
             
             한국, 중국, 일본, 베트남, 캄보디아, 헝가리(중부유럽..), (인도남부, 북동부)
             한국: ko
             중국: zh-chs, zh-cht
             일본: ja
             베트남: vi
             캄보디아: km, km-KH
             헝가리: ku
             */
            
            
            let lang = "language".localized
            if lang == "ko" || lang == "zh-chs" || lang == "zh-cht" || lang == "ja" || lang == "vi" || lang == "km-KH" || lang == "km" || lang == "ku" {
                name = (familyName ?? "") + " " + (givenName ?? "")
            } else {
                name = (givenName ?? "") + " " + (middleName ?? "") + (familyName ?? "")
            }
            
            User.shared.identifier = userIdentifier
            User.shared.nickName = nickname
            User.shared.email = email
            User.shared.name = name
            
            
//            if let code = code {
//                print("Code: \(code)")
//                print("Code2: \(code.base64EncodedString())")
//                print("Client ID: kr.co.alphadopetcare")
//                print("grant_type: authorization_code")
//            }
            
            
            if Global.shared.FIRST_REGISTER == "" {
                Global.shared.FIRST_REGISTER = email!
                
                let alert = UIAlertController(title: "알림", message: "회원가입되었습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    
                    Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
                }
                
                alert.addAction(ok)
                
                self.present(alert, animated: true)
            } else if Global.shared.FIRST_REGISTER == email {
                //우리 서버에서 사용자가 가입한 이메일인지 확인
                let alert = UIAlertController(title: "알림", message: "이미 가입된 아이디가 있습니다.\n로그인하시겠습니까?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
                    let cancelAlert = UIAlertController(title: "알림", message: "동일한 아이디로 가입이 불가합니다. 다른 간편회원가입을 이용하여 가입해주시기 바랍니다.", preferredStyle: .alert)
                    let cancelOk = UIAlertAction(title: "확인", style: .default)
                    cancelAlert.addAction(cancelOk)
                    self.present(cancelAlert, animated: true)
                }
                let ok = UIAlertAction(title: "확인", style: .default) { _ in
                    
                    Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
                }
                
                alert.addAction(ok)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            }
            
            break
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle Error
    }
    
}
