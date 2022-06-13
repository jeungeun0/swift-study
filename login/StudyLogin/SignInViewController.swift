//
//  AppleLoginViewController.swift
//  StudyLogin
//
//  Created by app on 2022/05/18.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AlamofireImage
import Alamofire

class SignInViewController: UIViewController {
    @IBOutlet weak var tfEmail: HoshiTextField!
    @IBOutlet weak var tfPW: HoshiTextField!
    @IBOutlet weak var stackViewSignIn: UIStackView!
    @IBOutlet weak var btnSignIn: UIButton! {
        didSet {
            btnSignIn.setTitle("계속하기", for: .normal)
            btnSignIn.addTarget(self, action: #selector(targetForLogin), for: .touchUpInside)
        }
    }
    @IBOutlet weak var btnSignUp: UIButton! {
        didSet {
            btnSignUp.setTitle("회원가입", for: .normal)
            btnSignUp.addTarget(self, action: #selector(targetForSignUp), for: .touchUpInside)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    var appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        /**
         #애플 로그인 해제
         */
        
        
    }
    
    
    //MARK: - Functions
      
    func setUI() {
        tfEmail.placeholder = "이메일"
        tfPW.placeholder = "비밀번호"
        
        stackViewSignIn.arrangedSubviews.forEach { view in
            stackViewSignIn.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        //초기화
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        let kakaoButton = UIButton()
        let naverButton = UIButton()
        let kakaoImageView = UIImageView()
        let naverImageView = UIImageView()
        let kakaoView = UIView()
        let naverView = UIView()
        
        //디자인
        kakaoImageView.image = UIImage(named: "kakao_login_large")
        naverImageView.image = UIImage(named: "btnG_완성형")
        
        //타겟
        appleButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        kakaoButton.addTarget(self, action: #selector(kakaoSignInButtonPress), for: .touchUpInside)
        naverButton.addTarget(self, action: #selector(naverSignInButtonPress), for: .touchUpInside)
        
        //추가
        kakaoView.addSubview(kakaoImageView)
        kakaoView.addSubview(kakaoButton)
        naverView.addSubview(naverImageView)
        naverView.addSubview(naverButton)
        stackViewSignIn.addArrangedSubview(appleButton)
        stackViewSignIn.addArrangedSubview(kakaoView)
        stackViewSignIn.addArrangedSubview(naverView)
        
        //제약조건
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoImageView.translatesAutoresizingMaskIntoConstraints = false
        naverImageView.translatesAutoresizingMaskIntoConstraints = false
        kakaoButton.translatesAutoresizingMaskIntoConstraints = false
        naverButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoView.translatesAutoresizingMaskIntoConstraints = false
        naverView.translatesAutoresizingMaskIntoConstraints = false
        
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([kakaoImageView.leadingAnchor.constraint(equalTo: kakaoView.leadingAnchor),
                                         kakaoImageView.topAnchor.constraint(equalTo: kakaoView.topAnchor),
                                         kakaoImageView.trailingAnchor.constraint(equalTo: kakaoView.trailingAnchor),
                                         kakaoImageView.bottomAnchor.constraint(equalTo: kakaoView.bottomAnchor),
                                         kakaoButton.leadingAnchor.constraint(equalTo: kakaoView.leadingAnchor),
                                         kakaoButton.topAnchor.constraint(equalTo: kakaoView.topAnchor),
                                         kakaoButton.trailingAnchor.constraint(equalTo: kakaoView.trailingAnchor),
                                         kakaoButton.bottomAnchor.constraint(equalTo: kakaoView.bottomAnchor),
                                         naverImageView.leadingAnchor.constraint(equalTo: naverView.leadingAnchor),
                                         naverImageView.topAnchor.constraint(equalTo: naverView.topAnchor),
                                         naverImageView.trailingAnchor.constraint(equalTo: naverView.trailingAnchor),
                                         naverImageView.bottomAnchor.constraint(equalTo: naverView.bottomAnchor),
                                         naverButton.leadingAnchor.constraint(equalTo: naverView.leadingAnchor),
                                         naverButton.topAnchor.constraint(equalTo: naverView.topAnchor),
                                         naverButton.trailingAnchor.constraint(equalTo: naverView.trailingAnchor),
                                         naverButton.bottomAnchor.constraint(equalTo: naverView.bottomAnchor),
                                         appleButton.heightAnchor.constraint(equalToConstant: 50),
                                         kakaoView.heightAnchor.constraint(equalToConstant: 50),
                                         naverView.heightAnchor.constraint(equalToConstant: 50)])
        }
        
    }
    
    /**
     애플 로그인
     ```
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
     ```
     이 delegate함수로 결과값이 온다.
     */
    @objc func appleSignInButtonPress() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func kakaoSignInButtonPress() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    //예외처리
                    print(error.localizedDescription)
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
    
    @objc func naverSignInButtonPress() {
        NaverSNSLogin.shared.login()
    }
    
    @objc func targetForLogin() {
        print("to login")
//        performSegue(withIdentifier: "toSignInOrUp", sender: true)
    }
    
    @objc func targetForSignUp() {
        print("to sign up")
        performSegue(withIdentifier: "toSignUp", sender: false)
    }
    
}


extension SignInViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
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
                name = (givenName ?? "") + " " + (familyName ?? "")
            }
            debugPrint(familyName ?? "")  //성
            debugPrint(givenName ?? "")   //이름
            debugPrint(middleName ?? "")
            debugPrint(nickname ?? "")
            debugPrint(name)
            
            User.shared.identifier = userIdentifier
            User.shared.nickName = nickname
            User.shared.email = email
            User.shared.name = name
            
            Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
            
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle Error
    }
    
}
