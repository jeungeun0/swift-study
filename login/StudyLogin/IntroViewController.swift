//
//  IntroViewController.swift
//  StudyLogin
//
//  Created by app on 2022/06/07.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //로그인이 되어 있으면 메인으로 보내고
        //로그인이 안 되어 있으면 로그인으로 보낸다.
        if AlphadoUser.shared.identifier != nil {
            performSegue(withIdentifier: "toMain", sender: nil)
        } else {
            performSegue(withIdentifier: "toSignIn", sender: nil)
        }
        
        if AlphadoUser.shared.snsKind == nil {
            performSegue(withIdentifier: "toSignIn", sender: nil)
        } else if AlphadoUser.shared.snsKind == .Kakao {
            KakaoSNSLogin.shared.tokenCheck { tokenInfo in
                //자동 로그인
                //검증한 토큰이 유효한 상태이므로 사용자 로그인 불필요.
                //해당 엑세스 토큰으로 카카오 API 호출 가능
                tokenInfo
            } failuer: {
                //로그인 화면으로 보내기
                //액세스 토큰 및 리스페시 토큰이 유효하지 않아 사용자 로그인 필요
                //각 에러에 맞는 처리 필요, 레퍼런스 참고
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

}
