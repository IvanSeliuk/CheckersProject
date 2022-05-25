//
//  Extension.swift
//  lesson 13
//
//  Created by Иван Селюк on 24.01.22.
//


import UIKit

extension UIView {
    func setupUI(_ cornerRadius: CGFloat,_ borderColor: UIColor) {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = layer.borderColor else {
                return .clear
            }
            return UIColor(cgColor: color)
        }
        
        set {
            layer.borderColor = newValue.cgColor
            
        }
    }
    @IBInspectable var textLael: String? {
        get {
            return nil
        }
        set {
            if let text = newValue, !text.isEmpty {
                let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
                label.text = text
                label.font = UIFont.systemFont(ofSize: 12.0)
                
                addSubview(label)
                label.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
            }
        }
    }
}
