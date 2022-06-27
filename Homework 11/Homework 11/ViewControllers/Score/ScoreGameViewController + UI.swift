//
//  ScoreGameViewController + UI.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import UIKit
import Lottie

extension ScoreGameViewController {
    //MARK: - SetupUI
    func setupUI() {
        backButton.setTitle("BACK".localized, for: .normal)
        backButton.setTitle("BACK".localized, for: .disabled)
        setupTableVeiw()
    }
    
    private func setupTableVeiw() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ScoreResultGameTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreResultGameTableViewCell")
    }
    
    func setupAnimation() {
        removeViewAnimate.animation = Animation.named(LottieImage.delete3.rawValue)
        removeViewAnimate.contentMode = .scaleAspectFit
        removeViewAnimate.loopMode = .loop
        removeViewAnimate.play()
    }
    
    func getDataScore() {
        let checkers = CoreDataManager.shared.getFromDB()
        checkersDB = checkers
        if checkersDB.count == 0 {
            removeViewAnimate.isHidden = true
        } else {
            removeViewAnimate.isHidden = false
        }
    }
    
    func removeScore() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeViewAnimateTap))
        removeViewAnimate.addGestureRecognizer(tapRecognizer)
    }
}
