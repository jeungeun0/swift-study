//
//  ViewController.swift
//  StudyLogin
//
//  Created by app on 2022/05/16.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnWithdrawal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogout.setTitle("로그아웃", for: .normal)
        btnWithdrawal.setTitle("회원탈퇴", for: .normal)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_EMAIL)
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_USER_NAME)
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_USER_ID)
        
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃되셨습니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    @IBAction func withdraw(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_EMAIL)
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_USER_NAME)
        UserDefaults.standard.removeObject(forKey: Global.shared.KEY_USER_ID)
        
        let alert = UIAlertController(title: "회원탈퇴", message: "탈퇴하셨습니다.\nApple ID로 회원가입하신 경우,\n[ 설정 > Apple ID 클릭 > 암호 및 보안 > 내 Apple ID를 사용하는 앱 ]에서도 삭제하셔야 완전한 회원탈퇴가 진행됩니다. ", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}
