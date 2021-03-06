//
//  MenuViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 8.02.22.
//

import UIKit
import GoogleMobileAds

class MenuViewController: UIViewController {
    
    @IBOutlet weak var startGameView: StartGameView!
    @IBOutlet weak var settingsBackgroundSecondViewController: SettingsGameView!
    @IBOutlet weak var scoreResultGame: ScoreGameView!
    @IBOutlet weak var aboutGameView: AboutGameView!
    var imageBack: UIImage?
    var interstitial: GADInterstitialAd?
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTappedViews()
    }
    
    //MARK: - Action & push
   
    @objc func startGameViewTapped() {
        loadInterstitial()
    }
    
    @objc func settingsGameViewTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        let background = UIAlertAction(title: "Change background".localized, style: .default) { _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        let languages = UIAlertAction(title:  "Change languages".localized, style: .default) { [weak self] _ in
            guard let vc = LanguagesViewController.getInstanceController else { return }
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(background)
        alert.addAction(languages)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func scoreResultGameViewTapped() {
        guard let scoreVC = ScoreGameViewController.getInstanceController as? ScoreGameViewController else {return}
        scoreVC.modalPresentationStyle = .fullScreen
        scoreVC.modalTransitionStyle = .crossDissolve
        present(scoreVC, animated: true, completion: nil)
    }
    
    @objc func aboutGameViewTapped() {
        guard let scoreVC = AboutViewController.getInstanceController as? AboutViewController else {return}
        scoreVC.modalPresentationStyle = .fullScreen
        scoreVC.modalTransitionStyle = .crossDissolve
        present(scoreVC, animated: true, completion: nil)
    }
    
    func presentGameViewController() {
        guard let vc = GamerViewController.getInstanceController as? GamerViewController else {return}
        vc.imageBlackGround = self.imageBack
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - ImagePicker
extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {         // галерея
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            Setting.shared.background = image
            imageBack = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - GoodleAdsDelegate
extension MenuViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        presentGameViewController()
        print("Ad did dismiss full screen content.")
    }
}
