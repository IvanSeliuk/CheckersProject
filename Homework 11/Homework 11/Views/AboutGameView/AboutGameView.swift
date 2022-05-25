//
//  AboutGameView.swift
//  Homework 11
//
//  Created by Иван Селюк on 8.02.22.
//

import UIKit

@IBDesignable

class AboutGameView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
        animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation?.toValue = -160
        animation?.autoreverses = true
        animation?.repeatCount = .infinity
        animation?.fillMode = .both
        animation?.duration = 1.5
        animation?.beginTime = CACurrentMediaTime()
        animation?.isRemovedOnCompletion = false
        animation?.timingFunction = .easeOut
        if let animation = animation {
            imageView.layer.add(animation, forKey: animation.description)
        }
    }
    
    private func setupUI() {
        Bundle(for: AboutGameView.self).loadNibNamed("AboutGameView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        textLabel.text = "ABOUT".localized
    }
}
