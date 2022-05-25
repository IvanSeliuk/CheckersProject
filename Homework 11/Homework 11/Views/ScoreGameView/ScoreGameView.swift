//
//  ScoreGameView.swift
//  Homework 11
//
//  Created by Иван Селюк on 8.02.22.
//

import UIKit

@IBDesignable

class ScoreGameView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var lineImage: UIImageView!
    var images: [UIImage] = []
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !lineImage.isAnimating {
            self.setAnimation()
           
        }
    }
    
    private func setAnimation() {
        for i in 1...60 {
            if let image = UIImage(named: "\(i)") {
                images.append(image)
            }
        }
        lineImage.animationImages = images
        lineImage.animationRepeatCount = images.count * 2
        lineImage.animationDuration = Double(images.count) / 30.0
        lineImage.startAnimating()
    }
    
    private func setupUI() {
        Bundle(for: ScoreGameView.self).loadNibNamed("ScoreGameView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        textLabel.text = "SCORE".localized
    }
}
