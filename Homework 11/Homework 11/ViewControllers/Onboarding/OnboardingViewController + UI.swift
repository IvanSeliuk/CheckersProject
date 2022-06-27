//
//  OnboardingViewController + UI.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import UIKit

extension OnboardingViewController {
    //MARK: - SetupUI
    func setupUI() {
        scrollView.delegate = self
        firstImageView.alpha = 0
        firstLabel.alpha = 0
        arrowImage.alpha = 0
        doneButton.isEnabled = false
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textFieldSecond.layer.cornerRadius = 25
        textFieldSecond.layer.borderWidth = 1
        textFieldSecond.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupAction() {
        textField.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
        textFieldSecond.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
    }
    
    func setupAnimationImage() {
        let imageAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        imageAnimation.toValue = NSNumber(value: Double.pi * 2)
        imageAnimation.repeatCount = 1.0
        imageAnimation.duration = 2.0
        imageAnimation.autoreverses = true
        imageAnimation.beginTime = CACurrentMediaTime()
        imageAnimation.isRemovedOnCompletion = false
        imageAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.36, 0, 0.66, -0.56)
        imageAnimation.fillMode = .both
        firstImageView.layer.add(imageAnimation, forKey: "rotationZAnimation")
        
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.curveEaseOut]) {
            self.firstImageView.alpha = 1
            self.firstLabel.alpha = 1
            self.arrowImage.alpha = 1
        }
        let arrowImageAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        arrowImageAnimation.toValue = view.frame.size.width / 2
        arrowImageAnimation.autoreverses = true
        arrowImageAnimation.repeatCount = .infinity
        arrowImageAnimation.fillMode = .both
        arrowImageAnimation.duration = 2.0
        arrowImageAnimation.beginTime = CACurrentMediaTime()
        arrowImageAnimation.isRemovedOnCompletion = false
        arrowImageAnimation.timingFunction = .easeOut
        self.arrowImage.layer.add(arrowImageAnimation, forKey: "transformTranslationX")
    }
    
    func setupAnimationButton() {
        secondLabel.alpha = 0
        textField.alpha = 0
        textFieldSecond.alpha = 0
        doneButton.alpha = 0
        
        let doneButtonAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        doneButtonAnimation.toValue = NSNumber(value: Double.pi * 4)
        doneButtonAnimation.repeatCount = 1.0
        doneButtonAnimation.duration = 2.0
        doneButtonAnimation.autoreverses = false
        doneButtonAnimation.beginTime = CACurrentMediaTime()
        doneButtonAnimation.isRemovedOnCompletion = false
        doneButtonAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
        doneButtonAnimation.fillMode = .both
        doneButton.layer.add(doneButtonAnimation, forKey: "rotationZAnimation2")
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseOut]) {
            self.doneButton.alpha = 1.0
            self.textField.alpha = 1.0
            self.textFieldSecond.alpha = 1.0
            self.secondLabel.alpha = 1.0
        }
    }
}
