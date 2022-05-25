//
//  localized.swift
//  Homework 11
//
//  Created by Иван Селюк on 1.04.22.
//

import Foundation
extension String {
    
    var localized: String {
        guard let url = Bundle.main.url(forResource: Setting.shared.currentLanguage, withExtension: "lproj"),
              let bundle = Bundle(url: url) else { return self }
        return NSLocalizedString(self, tableName: "Localized", bundle: bundle, comment: "")
    }
}
