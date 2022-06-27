//
//  LanguagesViewController + UI.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import UIKit

extension LanguagesViewController {
    //MARK: - SetupUI
    func setLocalized() {
        chooseLabel.text = "chooseLabel".localized
        backButton.setTitle("BACK".localized, for: .normal)
        backButton.setTitle("BACK".localized, for: .disabled)
    }
    
    func setupUI() {
        pickerView.delegate = self
        pickerView.dataSource = self
        imageArray = [UIImage(named: "en"),
                      UIImage(named: "ru"),
                      UIImage(named: "de"),
                      UIImage(named: "fr"),
                      UIImage(named: "es")]
    }
}

