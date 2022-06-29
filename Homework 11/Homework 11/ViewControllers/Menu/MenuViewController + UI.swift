//
//  MenuViewController + UI.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import Foundation
import GoogleMobileAds

extension MenuViewController {
    //MARK: - SetupUI
    func loadInterstitial() {
        view.showLoading()
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                view.closeLoading()
                presentGameViewController()
                return
            }
            view.closeLoading()
            interstitial = ad
            interstitial?.present(fromRootViewController: self)
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func setupTappedViews() {
        setupTapGestureStartView()
        setupTapGestureSettingsView()
        setupTapGestureScoreView()
        setupTapGestureAboutView()
    }
    
    private func setupTapGestureStartView() {
        Setting.shared.onboardingCompleted = true
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(startGameViewTapped))
        startGameView.addGestureRecognizer(tapRecognizer)
        startGameView.isUserInteractionEnabled = true
    }
    
    private func setupTapGestureSettingsView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(settingsGameViewTapped))
        settingsBackgroundSecondViewController.addGestureRecognizer(tapRecognizer)
        settingsBackgroundSecondViewController.isUserInteractionEnabled = true
    }
    
    private func setupTapGestureScoreView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(scoreResultGameViewTapped))
        scoreResultGame.addGestureRecognizer(tapRecognizer)
        scoreResultGame.isUserInteractionEnabled = true
    }
    
    private func setupTapGestureAboutView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(aboutGameViewTapped))
        aboutGameView.addGestureRecognizer(tapRecognizer)
        aboutGameView.isUserInteractionEnabled = true
    }
}
