//
//  AboutViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 29.06.22.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        textLabel.text = "name".localized
        textLabel.layer.cornerRadius = 20
        groupLabel.text = "group".localized
        backButton.setTitle("BACK".localized, for: .normal)
        backButton.setTitle("BACK".localized, for: .disabled)
        backButton.layer.cornerRadius = 10
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        guard let menuVC = MenuViewController.getInstanceController else { return }
        menuVC.modalPresentationStyle = .fullScreen
        menuVC.modalTransitionStyle = .crossDissolve
        self.present(menuVC, animated: true, completion: nil)
    }
}

