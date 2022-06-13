//
//  UserInfomationViewController.swift
//  StudyLogin
//
//  Created by app on 2022/06/08.
//

import UIKit

class UserInfomationViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var ivThumbnail: UIImageView! {
        didSet {
            ivThumbnail.image = UIImage(named: "no_image")
        }
    }
    @IBOutlet weak var stackViewOfInfomationCategorys: UIStackView!
    @IBOutlet weak var stackViewOfInfomations: UIStackView!
    
    var infomationData: [(User.UserInfomation, Any)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //데이터가 없으면 뒤로가기
        if self.infomationData.count < 0 {
            let alert = UIAlertController(title: "", message: "유저 정보가 없습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                DispatchQueue.main.async {
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
            
            alert.addAction(ok)
            self.present(alert, animated: true)
            return
        }
        
        //스택뷰 초기화
        stackViewOfInfomationCategorys.arrangedSubviews.forEach { view in
            stackViewOfInfomationCategorys.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        stackViewOfInfomations.arrangedSubviews.forEach { view in
            stackViewOfInfomations.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        createInformationLabel()
    }
    
    
    /// 카테고리에 따른 라벨을 스택뷰에 추가
    func createInformationLabel() {
        guard self.infomationData.count > 0 else { return }
        
        self.infomationData.enumerated().forEach { index, item in
            
            let lblCategory = UILabel()
            let lblInfomation = UILabel()
            
            if let text = item.1 as? String {
                lblCategory.text = item.0.rawValue
                lblInfomation.text = text
                stackViewOfInfomationCategorys.addArrangedSubview(lblCategory)
                stackViewOfInfomations.addArrangedSubview(lblInfomation)
            } else if let image = item.1 as? UIImage {
                self.ivThumbnail.image = image
                self.ivThumbnail.contentMode = .scaleAspectFill
            }
            
        }
    }
}
