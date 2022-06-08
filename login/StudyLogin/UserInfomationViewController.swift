//
//  UserInfomationViewController.swift
//  StudyLogin
//
//  Created by app on 2022/06/08.
//

import UIKit

class UserInfomationViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var stackViewOfInfomationCategorys: UIStackView!
    @IBOutlet weak var stackViewOfInfomations: UIStackView!
    
    var infomationData: [(User.UserInfomation, Any)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //스택뷰 초기화
        stackViewOfInfomationCategorys.arrangedSubviews.forEach { view in
            stackViewOfInfomationCategorys.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        stackViewOfInfomations.arrangedSubviews.forEach { view in
            stackViewOfInfomations.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        //카테고리에 따른 라벨을 스택뷰에 추가
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

}
