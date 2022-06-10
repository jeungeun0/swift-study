//
//  String+Extension.swift
//  StudyLogin
//
//  Created by app on 2022/06/09.
//

import Foundation
extension String {
    /// Localization을 쉽게 사용하기 위한 연산 프로퍼티
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: "")
    }
}
