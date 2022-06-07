//
//  AppleLoginViewController.swift
//  StudyLogin
//
//  Created by app on 2022/05/18.
//

import UIKit
import AuthenticationServices

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
        if segue.identifier == "toSignInOrUp" {
            if let destination = segue.destination as? SignUpViewController, let isSignIn = sender as? Bool {
                destination.isSignIn = isSignIn
            }
        }
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
        
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        
        stackViewSignIn.addArrangedSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 50)])
            
        }
    }
    
    @objc func appleSignInButtonPress() {
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
    @objc func targetForLogin() {
        print("to login")
        performSegue(withIdentifier: "toSignInOrUp", sender: true)
    }
    
    @objc func targetForSignUp() {
        print("to sign up")
        performSegue(withIdentifier: "toSignInOrUp", sender: false)
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
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
//            print("User ID: \(userIdentifier)")
//            print("User Email: \(String(describing: email))")
//            print("User Name: \(String(describing: fullName))")
            
            UserDefaults.standard.set(userIdentifier, forKey: Global.shared.KEY_USER_ID)
            
            if email != nil {
                UserDefaults.standard.set(email, forKey: Global.shared.KEY_EMAIL)
            }
            if fullName != nil {
                UserDefaults.standard.set(fullName?.familyName, forKey: Global.shared.KEY_USER_NAME)
            }
            
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle Error
    }
    
}
