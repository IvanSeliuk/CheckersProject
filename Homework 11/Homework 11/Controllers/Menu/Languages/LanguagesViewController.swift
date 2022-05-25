//
//  LanguagesViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 29.03.22.
//

import UIKit

class LanguagesViewController: UIViewController {
    
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    var imageArray = [UIImage?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setLocalized() {
        chooseLabel.text = "chooseLabel".localized
        backButton.setTitle("BACK".localized, for: .normal)
        backButton.setTitle("BACK".localized, for: .disabled)
    }
    
   private func setupUI() {
        pickerView.delegate = self
        pickerView.dataSource = self
        imageArray = [UIImage(named: "en"),
                      UIImage(named: "ru"),
                      UIImage(named: "de"),
                      UIImage(named: "fr"),
                      UIImage(named: "es")
        ]
    }
    
    @IBAction func backMenuButton(_ sender: Any) {
        guard let menuVC = MenuViewController.getInstanceController else { return }
        menuVC.modalPresentationStyle = .fullScreen
        menuVC.modalTransitionStyle = .crossDissolve
        self.present(menuVC, animated: true, completion: nil)
    }
}

extension LanguagesViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 135))
        myImageView.image = imageArray[row]
        myImageView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        pickerView.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return myImageView
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerView.selectRow(row, inComponent: component, animated: true)
        Setting.shared.currentLanguage = Setting.shared.languageCode[row]
        setLocalized()
    }
}

extension LanguagesViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageArray.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 135
    }
}
