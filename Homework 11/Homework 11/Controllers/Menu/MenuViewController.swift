//
//  MenuViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 8.02.22.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var startGameView: StartGameView!
    @IBOutlet weak var settingsBackgroundSecondViewController: SettingsGameView!
    @IBOutlet weak var scoreResultGame: ScoreGameView!
    var imageBack: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTappedViews()
    }
    
    private func setupTappedViews() {
        setupTapGestureRecognizerStartView()
        setupTapGestureRecognizereSettingsView()
        setupTapGestureRecognizerScoreView()
    }
    
    private func setupTapGestureRecognizerStartView() {
        Setting.shared.onboardingCompleted = true
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(startGameViewTapped))
        startGameView.addGestureRecognizer(tapRecognizer)
        startGameView.isUserInteractionEnabled = true
    }
    @objc private func startGameViewTapped() {
        guard let vc = GamerViewController.getInstanceController as? GamerViewController else {return}
        vc.imageBlackGround = self.imageBack
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    private func setupTapGestureRecognizereSettingsView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(settingsGameViewTapped))
        settingsBackgroundSecondViewController.addGestureRecognizer(tapRecognizer)
        settingsBackgroundSecondViewController.isUserInteractionEnabled = true
    }
    
    @objc private func settingsGameViewTapped() {
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
    
    private func setupTapGestureRecognizerScoreView() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(scoreResultGameViewTapped))
        scoreResultGame.addGestureRecognizer(tapRecognizer)
        scoreResultGame.isUserInteractionEnabled = true
    }
    
    @objc private func scoreResultGameViewTapped() {
        guard let scoreVC = ScoreGameViewController.getInstanceController as? ScoreGameViewController else {return}
        scoreVC.modalPresentationStyle = .fullScreen
        scoreVC.modalTransitionStyle = .crossDissolve
        present(scoreVC, animated: true, completion: nil)
    }
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {         // галерея
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            Setting.shared.background = image
            imageBack = image
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}