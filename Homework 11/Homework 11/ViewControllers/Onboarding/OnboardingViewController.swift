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

    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimationImage()
    }
    
    //MARK: - Action & Push
    @objc func textFieldClick() {
        doneButton.isEnabled = textField.text?.count ?? 0 > 0 || textFieldSecond.text?.count ?? 0 > 0
    }
    
    @IBAction func doneAction(_ sender: Any) {
        Setting.shared.namePlayer = textField.text
        Setting.shared.namePlayerSecond = textFieldSecond.text
        guard let menuVC = MenuViewController.getInstanceController else { return }
        navigationController?.pushViewController(menuVC, animated: true)
    }
}

//MARK: - ScrollView
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupAnimationButton()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let onePageOffSet = scrollView.contentSize.width /
        CGFloat(pageControl.numberOfPages)
        pageControl.currentPage = Int(scrollView.contentOffset.x / onePageOffSet)
    }
}
