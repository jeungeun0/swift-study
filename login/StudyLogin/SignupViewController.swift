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
        addAppleButton()
        addEmailButton()
        addKakaoButton()
    }
    
    //일반 email 회원가입 버튼
    func addEmailButton() {
        let button = UIButton()
        button.setTitle("E-Mail 회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(signupEmail), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                                         button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                                         button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -((50 + 15) * 2 + 24)),
                                         button.heightAnchor.constraint(equalToConstant: 50)])
        }
        
    }
    
    //Apple ID 로그인 버튼 생성
    func addAppleButton() {
        let button = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
        button.addTarget(self, action: #selector(self.appleSignUpButtonPress), for: .touchUpInside)
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                                         button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                                         button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24),
                                         button.heightAnchor.constraint(equalToConstant: 50)])
        }
    
    }
    
    func addKakaoButton() {
        let imageView = UIImageView(image: UIImage(named: "kakao_login_large"))
        let button = UIButton()
        button.addTarget(self, action: #selector(signupKakao), for: .touchUpInside)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        self.view.addSubview(button)
        
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                                         imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                                         imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(24 + 50 + 15)),
                                         imageView.heightAnchor.constraint(equalToConstant: 50),
                                         button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                                         button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                                         button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(24 + 50 + 15)),
                                         button.heightAnchor.constraint(equalToConstant: 50)])
        }
        
    }
    
    @objc func signupKakao() {
//        let alert = UIAlertController(title: "준비중", message: "해당 서비스는 준비중입니다.", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .default)
//        alert.addAction(ok)
//        present(alert, animated: true)
        
        //카카오톡 설치여부
//        if AuthApi.isKakaoTalkLoginAvailable()
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    //예외처리
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    //doSomthing
                    let accessToken = oauthToken?.accessToken
                    UserApi.shared.me { user, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("me() success.")
                            let email = user?.kakaoAccount?.email
                            let nickName = user?.kakaoAccount?.name
                            let name = user?.kakaoAccount?.legalName
                            let image = user?.kakaoAccount?.profileImageNeedsAgreement
                            
                            print(email)
                            print(nickName)
                            print(name)
                            print(image)
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
                            let email = user?.kakaoAccount?.email
                            let nickName = user?.kakaoAccount?.name
                            let name = user?.kakaoAccount?.legalName
                            let image = user?.kakaoAccount?.profileImageNeedsAgreement
                            
                            print(email)
                            print(nickName)
                            print(name)
                            print(image)
                        }
                    }
                }
            }
        }
        
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
        authorizationController(request: request)
    }
    
    func authorizationController(request: ASAuthorizationAppleIDRequest) {
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func getStatusOfApple(callback: @escaping (_ state: ASAuthorizationAppleIDProvider.CredentialState?) -> Void) {
        if UserDefaults.standard.string(forKey: Global.shared.KEY_USER_ID) != nil {
            appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: Global.shared.KEY_USER_ID)!) { state, error in
                switch state {
                case .authorized:
                    print("==> authorized")
                    callback(state)
                    break
                case .notFound:
                    print("==> notFound")
                    callback(state)
                    break
                case .revoked:
                    print("==> revoked")
                    callback(state)
                    break
                case .transferred:
                    print("==> transferred")
                    callback(state)
                    break
                @unknown default:
                    callback(nil)
                }
            }
        } else {
            callback(nil)
        }
    }
}
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
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let code = appleIDCredential.authorizationCode
            
//            if let code = code {
//                print("Code: \(code)")
//                print("Code2: \(code.base64EncodedString())")
//                print("Client ID: kr.co.alphadopetcare")
//                print("grant_type: authorization_code")
//            }
            print("User ID: \(userIdentifier)")
            print("User Email: \(String(describing: email))")
            print("User Name: \(String(describing: fullName))")
            
            UserDefaults.standard.set(userIdentifier, forKey: Global.shared.KEY_USER_ID)
            
            if email != nil {
                UserDefaults.standard.set(email!, forKey: Global.shared.KEY_EMAIL)
                if Global.shared.FIRST_REGISTER == "" {
                    Global.shared.FIRST_REGISTER = email!
                    
                    let alert = UIAlertController(title: "알림", message: "회원가입되었습니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        if fullName != nil {
                            UserDefaults.standard.set(fullName?.familyName, forKey: Global.shared.KEY_USER_NAME)
                        }

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
                        if fullName != nil {
                            UserDefaults.standard.set(fullName?.familyName, forKey: Global.shared.KEY_USER_NAME)
                        }

                        Util.shared.changeRoot(storyboardName: "Main", destinationIdentifier: "Main")
                    }

                    alert.addAction(ok)
                    alert.addAction(cancel)

                    self.present(alert, animated: true)
                }
            }
            
            break
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle Error
    }
    
}
