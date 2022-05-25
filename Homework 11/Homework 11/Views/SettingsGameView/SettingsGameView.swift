//
//  SettingsGameView.swift
//  Homework 11
//
//  Created by Иван Селюк on 8.02.22.
//

import UIKit

@IBDesignable

class SettingsGameView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var squareImage: UIImageView!
    private var animation: CABasicAnimation?
    
    @IBInspectable var bgColor: UIColor {
        set { contentView.backgroundColor = newValue }
        get { return contentView.backgroundColor ?? .clear }
    }
    
    @IBInspectable var text: String {
        set { textLabel.text = newValue }
        get { return textLabel.text ?? "" }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAnimation()
    }
    
    private func setAnimation() {
        animation = CABasicAnimation(keyPath: "opacity")
        animation?.fromValue = 1
        animation?.toValue = 0
        animation?.repeatCount = .infinity
        animation?.duration = 0.3
        animation?.autoreverses = false
        animation?.beginTime = CACurrentMediaTime()
        animation?.isRemovedOnCompletion = false
        animation?.timingFunction = .linear
        animation?.fillMode = .both
        if let animation = animation {
            squareImage.layer.add(animation, forKey: animation.description)
        }
    }
    
    private func setupUI() {
        Bundle(for: SettingsGameView.self).loadNibNamed("SettingsGameView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        textLabel.text = "SETTINGS".localized
    }
}
