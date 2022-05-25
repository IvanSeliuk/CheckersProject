//
//  LoadingViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 7.02.22.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveEaseOut]) {
            self.loadingLabel.alpha = 0
        } completion: { _ in
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut]) {
                self.loadingImage.alpha = 0
            } completion: { _ in
                
                if Setting.shared.onboardingCompleted {
                    guard let vc = MenuViewController.getInstanceController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    guard let vc = OnboardingViewController.getInstanceController else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
