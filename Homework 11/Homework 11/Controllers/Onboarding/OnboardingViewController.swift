//
//  ViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 19.01.22.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldSecond: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scrollView.delegate = self
        textField.delegate = self
        textFieldSecond.delegate = self
        setupAction()
        navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }
    
    private func setupUI() {
        firstImageView.alpha = 0
        firstLabel.alpha = 0
        arrowImage.alpha = 0
        doneButton.isEnabled = false
    }
    
    private func setupAction() {
        textField.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
        textFieldSecond.addTarget(self, action: #selector(textFieldClick), for: .editingChanged)
    }
    
    @objc func textFieldClick() {
        doneButton.isEnabled = textField.text?.count ?? 0 > 0 || textFieldSecond.text?.count ?? 0 > 0
    }
    
    private func setupAnimation() {
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
 
    @IBAction func doneAction(_ sender: Any) {
        Setting.shared.namePlayer = textField.text
        Setting.shared.namePlayerSecond = textFieldSecond.text
        guard let menuVC = MenuViewController.getInstanceController else { return }
        navigationController?.pushViewController(menuVC, animated: true)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let onePageOffSet = scrollView.contentSize.width /
        CGFloat(pageControl.numberOfPages)
        pageControl.currentPage = Int(scrollView.contentOffset.x / onePageOffSet)
    }
}

//MARK: закрытие клавиатуры через return

extension OnboardingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
