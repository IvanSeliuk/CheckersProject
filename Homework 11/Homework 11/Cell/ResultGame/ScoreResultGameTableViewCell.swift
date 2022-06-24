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
    @IBOutlet weak var nameGameTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var whoIsWinner: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableViewCell()
        setupUI()
    }
    
    private func setupUI() {
        winnerBlackPlayerLabel.text = "WINNER".localized
        winnerWhitePlayerLabel.text = "WINNER".localized
        nameGameTimeLabel.text = "Game time".localized
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
    
    private func animation(winner: UILabel) {
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
        winner.layer.add(animation, forKey: "animation.description")
    }
    func setupCheckersCell(with checkers: Checkers) {
        nameBlackPlayerLabel.text = checkers.namePlayerSecond
        nameWhitePlayerLabel.text = checkers.namePlayer
        gameTimeLabel.text = checkers.timer
        whoIsWinner = checkers.winner
        dateLabel.text = checkers.date
        showWinner()
    }
    
    private func showWinner() {
        if whoIsWinner == nameBlackPlayerLabel.text {
            personBlackImage.borderColor = .red
            winnerWhitePlayerLabel.isHidden = true
            animation(winner: winnerBlackPlayerLabel)
        } else {
            personWhiteImage.borderColor = .red
            winnerBlackPlayerLabel.isHidden = true
            animation(winner: winnerWhitePlayerLabel)
        }
    }
}
