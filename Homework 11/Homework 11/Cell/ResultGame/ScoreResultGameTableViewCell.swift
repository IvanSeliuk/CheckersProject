//
//  ScoreResultGameTableViewCell.swift
//  Homework 11
//
//  Created by Иван Селюк on 1.03.22.
//

import UIKit

class ScoreResultGameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personBlackImage: UIImageView!
    @IBOutlet weak var personWhiteImage: UIImageView!
    @IBOutlet weak var nameBlackPlayerLabel: UILabel!
    @IBOutlet weak var nameWhitePlayerLabel: UILabel!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var winnerBlackPlayerLabel: UILabel!
    @IBOutlet weak var winnerWhitePlayerLabel: UILabel!
    @IBOutlet weak var clearResultButton: UIButton!
    @IBOutlet weak var nameGameTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableViewCell()
        animationWinner()
        setupUI()
    }

    private func setupUI() {
        winnerBlackPlayerLabel.text = "WINNER".localized
        winnerWhitePlayerLabel.text = "WINNER".localized
        nameGameTimeLabel.text = "Game time".localized
        clearResultButton.setTitle("Clear the results".localized, for: .normal)
     //   clearResultButton.setTitle("Clear the results".localized, for: .disabled)
      //  clearResultButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
    }
    
    private func setupTableViewCell() {
        personBlackImage.layer.cornerRadius = 50
        personWhiteImage.layer.cornerRadius = 50
        if let nameUser = Setting.shared.namePlayer,
            let nameUserSecond = Setting.shared.namePlayerSecond {
            nameWhitePlayerLabel.text = nameUser
            nameBlackPlayerLabel.text = nameUserSecond
        }
        if let seconds = Setting.shared.timer {
            let min = Int(Double(seconds) / 60.0)
            let sec = Int(Double(seconds) - (Double(min) * 60.0))
            let min_string = min < 10 ? "0\(min)" : "\(min)"
            let sec_srting = sec < 10 ? "0\(sec)" : "\(sec)"
            gameTimeLabel.text = "\(min_string):\(sec_srting)"
        }
    }
    
    private func animationWinner() {
        personBlackImage.borderColor = .red
        winnerWhitePlayerLabel.isHidden = true
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.repeatCount = .infinity
        animation.duration = 0.6
        animation.autoreverses = false
        animation.beginTime = CACurrentMediaTime()
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .linear
        animation.fillMode = .both
        winnerBlackPlayerLabel.layer.add(animation, forKey: "animation.description")
    }

    @IBAction func clearTheResultButton(_ sender: Any) {
        gameTimeLabel.text = "00:00"
        personBlackImage.borderColor = .black
        winnerBlackPlayerLabel.layer.removeAnimation(forKey: "animation.description")
        winnerWhitePlayerLabel.isHidden = false
        
    }
}
