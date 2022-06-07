//
//  SignupViewController.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import UIKit
import AuthenticationServices

class SignUpViewController: UIViewController {
    
    //MARK: - Properties
    var isSignIn: Bool = false
    let userIDKey = "USER_IDENTIFIER"
    let emailKey = "EMAIL"
    let nameKey = "FULL_NAME"
    var appleIDProvider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        addButton()
    }
    
    func addButton() {
        addAppleButton()
    }
    
    //Apple ID 로그인 버튼 생성
    func addAppleButton() {
        if isSignIn {
            
            let button = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            button.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
            self.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            DispatchQueue.main.async {
                NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
                                             button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
                                             button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24),
                                             button.heightAnchor.constraint(equalToConstant: 50)])
            }
        } else {
            let button = ASAuthorizationAppleIDButton(type: .signUp, style: .whiteOutline)
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
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func appleSignInButtonPress() {
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        authorizationController(request: request)
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
        if UserDefaults.standard.string(forKey: userIDKey) != nil {
            appleIDProvider.getCredentialState(forUserID: UserDefaults.standard.string(forKey: userIDKey)!) { state, error in
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
            
            UserDefaults.standard.set(userIdentifier, forKey: userIDKey)
            if email != nil {
                UserDefaults.standard.set(email, forKey: emailKey)
            }
            if fullName != nil {
                UserDefaults.standard.set(fullName?.familyName, forKey: nameKey)
            }
            break
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle Error
    }
    
}
