//
//  ViewController.swift
//  StudyLogin
//
//  Created by app on 2022/05/16.
//

import UIKit
import KakaoSDKUser

class MainViewController: UIViewController {
    

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnWithdrawal: UIButton!
    
    //로그아웃인지 아닌지의 플래그
    var isLogout: Bool = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserInformation", let destination = segue.destination as? UserInfomationViewController {
            var data: [(User.UserInfomation, Any)] = []
            
            if User.shared.email != nil {
                data.append((.email, User.shared.email!))
            }
            if User.shared.name != nil {
                data.append((.name, User.shared.name!))
            }
            if User.shared.nickName != nil {
                data.append((.nickName, User.shared.nickName!))
            }
            if User.shared.gender != nil {
                data.append((.gender, User.shared.gender!))
            }
            if User.shared.age != nil {
                data.append((.age, User.shared.age!))
            }
            if User.shared.birth != nil {
                data.append((.birth, User.shared.birth!))
            }
            if User.shared.thumbnail != nil {
                data.append((.thumbnail, User.shared.thumbnail!))
            }
            destination.infomationData = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogout.setTitle("로그아웃", for: .normal)
        btnWithdrawal.setTitle("회원탈퇴", for: .normal)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        if isLogout {
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃되셨습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                
                if User.shared.snsKind == .Kakao {
                    UserApi.shared.logout { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            User.shared.removeIdentifier()
                            self.btnLogout.setTitle("로그인", for: .normal)
                            self.isLogout = false
                        }
                    }
                } else if User.shared.snsKind == .Naver {
                    NaverSNSLogin.shared.logout()
                    self.btnLogout.setTitle("로그인", for: .normal)
                    self.isLogout = false
                } else if User.shared.snsKind == .Apple {
                    User.shared.removeAllData()
                    self.btnLogout.setTitle("로그인", for: .normal)
                    self.isLogout = false
                }
            }
            alert.addAction(ok)
            
            present(alert, animated: true)
        } else {
            Util.shared.changeRoot(storyboardName: "SignIn", destinationIdentifier: "SignIn")
        }
        
    }
    @IBAction func withdraw(_ sender: Any) {
        
        if User.shared.snsKind == .Naver {
            NaverSNSLogin.shared.disConnect()
            self.btnLogout.setTitle("로그인", for: .normal)
            self.isLogout = false
        } else {
            
        }
        
        /**
         if isLogout {
             let alert = UIAlertController(title: "회원탈퇴", message: "탈퇴하셨습니다.\nApple ID로 회원가입하신 경우,\n[ 설정 > Apple ID 클릭 > 암호 및 보안 > 내 Apple ID를 사용하는 앱 ]에서도 삭제하셔야 완전한 회원탈퇴가 진행됩니다. ", preferredStyle: .alert)
             let ok = UIAlertAction(title: "확인", style: .default) { _ in
                 //우리 서버에서 회원탈퇴.
                 //다시 애플로 가입하려고 하면, 탈퇴한 사람의 이메일과 동일한 이메일을 사용하게 되므로 다른 간편 회원가입을 권유해야 함.
                 //만약 사용했던 아이디를 다시 사용할 수 없다면, 해당 유저는 애플 간편 회원가입 및 로그인을 쓸 수 없게 됌.
 //                UserDefaults.standard.removeObject(forKey: Global.shared.KEY_EMAIL)
 //                UserDefaults.standard.removeObject(forKey: Global.shared.KEY_USER_NAME)
                 User.shared.removeAllData()
                 Global.shared.loginKind = nil
                 self.btnLogout.setTitle("로그인", for: .normal)
                 self.isLogout = false
             }
             alert.addAction(ok)
             
             present(alert, animated: true)
         } else {
             let alert = UIAlertController(title: "", message: "로그인을 먼저 해주세요.", preferredStyle: .alert)
             let ok = UIAlertAction(title: "확인", style: .default)
             alert.addAction(ok)
             
             present(alert, animated: true)
         }
         */
        
        
    }
    
    
}
