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
        if UserDefaults.standard.value(forKey: Global.shared.KEY_EMAIL) != nil {
            performSegue(withIdentifier: "toMain", sender: nil)
        } else {
            performSegue(withIdentifier: "toSignIn", sender: nil)
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
