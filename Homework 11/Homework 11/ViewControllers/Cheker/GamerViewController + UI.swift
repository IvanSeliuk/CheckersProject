//
//  GamerViewController + UI.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import UIKit
import Lottie

extension GamerViewController {
    
    func setupUI() {
        setupBackGround()
        namePlayer()
        setupDesk()
    }
    
    private func setupDesk() {
        let sizeConstant = self.view.frame.width - 32
        desk = UIView(frame: CGRect(
            origin: .zero,
            size: CGSize(width: sizeConstant, height: sizeConstant)))
        desk.center = view.center
        view.addSubview(desk)
        desk.isUserInteractionEnabled = true
        desk.clipsToBounds = true
        desk.backgroundColor = .clear
        desk.layer.borderWidth = 2
        desk.layer.borderColor = UIColor.brown.cgColor
        fillDesk(view: desk)
    }
    
    func fillDesk(view: UIView) {
        var number: Int = 0
        let squareSize = view.frame.size.width / 8
        for yCoordinate in 0..<yLine.count {
            for xCoordinate in 0..<xLine.count {
                let square = UIView(frame: CGRect(
                    origin: CGPoint(x: CGFloat(xCoordinate) * squareSize,
                                    y: CGFloat(yCoordinate) * squareSize),
                    size: CGSize(width: squareSize, height: squareSize)))
                view.addSubview(square)
                square.tag = number
                number += 1
                if (xCoordinate + yCoordinate) % 2 == 0 {
                    square.backgroundColor = UIColor(named: "ColorWhite")
                } else {
                    square.backgroundColor = UIColor(named: "ColorBlack")
                    let imageName: ColorChecker? = (yCoordinate <= 2) ? ColorChecker.black : ((yCoordinate >= 5) ? ColorChecker.white : nil)
                    if let imageName = imageName {
                        let checker = addChecker(image: imageName)
                        square.addSubview(checker)
                        checker.frame = CGRect(x: .zero,
                                               y: .zero,
                                               width: square.frame.width,
                                               height: square.frame.height)
                    }
                }
            }
        }
    }
    
    func removeDesk() {
        for view in desk.subviews {
            view.removeFromSuperview()
        }
    }
    
    func addChecker(image: ColorChecker) -> UIImageView {
        let checker = UIImageView(image: UIImage(named: image.rawValue))
        switch image {
        case .white:
            checker.tag = 0
        case .black:
            checker.tag = 1
        case .whiteKing:
            checker.tag = 2
        case .blackKing:
            checker.tag = 3
        }
        createGestureRecognizer().forEach({ checker.addGestureRecognizer($0) })
        checker.isUserInteractionEnabled = true
        return checker
    }
    
   private func createGestureRecognizer() -> [UIGestureRecognizer] {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        longPressGestureRecognizer.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragTheChecker))
        panGestureRecognizer.delegate = self
        return [longPressGestureRecognizer, panGestureRecognizer]
    }
    
    private func namePlayer() {
        if let nameUser = Setting.shared.namePlayer,
           let nameUserSecond = Setting.shared.namePlayerSecond {
            namePlayerLabel.text = "Welcome,".localized + " \n\(nameUser)  :  \(nameUserSecond)"
        }
    }
    
    private func setupBackGround() {
        backgroundSecondVC.image = imageBlackGround
        backgroundSecondVC.image = Setting.shared.background
        whoMustMoveLabel.text = "White makes the first move".localized
        buttonSave.layer.cornerRadius = 40
        buttonReset.layer.cornerRadius = 40
        buttonSave.setTitle("SAVE".localized, for: .normal)
        buttonSave.setTitle("SAVE".localized, for: .disabled)
        buttonReset.setTitle("RESET".localized, for: .normal)
        buttonReset.setTitle("RESET".localized, for: .disabled)
        animationView.isHidden = true
        buttonVolume.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
    }
    
    func setupAnimation() {
        animationView.animation = Animation.named("salute")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func turnOnTimer() {
        timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    func nextMove(nextMove: MovePlayer, text: String) {
        currentGamer = nextMove
        whoMustMoveLabel.text = text.localized
        saveCurrentMove = currentGamer
    }
    
    func alertLoadGame() {
        let alert = UIAlertController(title: "Load Game".localized, message: "Do you want to load the last game?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: {
            [self]_ in
            turnOnTimer()
        }))
        alert.addAction(UIAlertAction(title: "YES".localized, style: .cancel, handler: { [self]_ in
            loadSaveDesk()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - FINISH GAME
    func finishGame() {
        if beatBlackCheckers == 12 || beatWhiteCheckers == 12 {
            AudioManager.shared.playSoundPlayer(with: SoundsChoice.salute.rawValue)
            animationView.isHidden = false
            view.bringSubviewToFront(animationView)
            showFinishGameAlert()
        }
    }
    
    private func showFinishGameAlert(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy \nHH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        let winner: String?
        if beatWhiteCheckers == 12 {
            winner = Setting.shared.namePlayerSecond
        } else {
            winner = Setting.shared.namePlayer
        }
        checkersDB.append(Checkers(namePlayer: Setting.shared.namePlayer,
                                   namePlayerSecond: Setting.shared.namePlayerSecond,
                                   winner: winner,
                                   timer: timerLabel.text,
                                   date: date))
        CoreDataManager.shared.saveScoreInDB(checkers: checkersDB)
        
        timer.invalidate()
        UserDefaults.standard.removeObject(forKey: "chechersArray")
        let alert = UIAlertController(title: "Finish game", message:  (winner ?? "He") + " is winner!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            AudioManager.shared.clearSoundPlayer()
            self.animationView.isHidden = true
            guard let scoreVC = ScoreGameViewController.getInstanceController as? ScoreGameViewController else {return}
            scoreVC.modalPresentationStyle = .fullScreen
            scoreVC.modalTransitionStyle = .crossDissolve
            self.present(scoreVC, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - QUEENS MOVE
    func queenStepsGray(recognizer: UIPanGestureRecognizer) {
        guard let checker = recognizer.view, let squareOfChecker = checker.superview else {return}
        let sevenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 7)}
        let nineTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 9)}
        let fourteenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 14)}
        let eighteenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 18)}
        let twentyOneTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 21)}
        let twentySevenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 27)}
        let twentyEightTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 28)}
        let thirtyFiveTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 35)}
        let thirtySixTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 36)}
        let fortyTwoTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 42)}
        let fortyFiveTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 45)}
        let sevenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 7)}
        let nineBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 9)}
        let fourteenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 14)}
        let eighteenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 18)}
        let twentyOneBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 21)}
        let twentySevenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 27)}
        let twentyEightBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 28)}
        let thirtyFiveBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 35)}
        let thirtySixBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 36)}
        let fortyTwoBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 42)}
        let fortyFiveBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 45)}
        
        //MARK: - BLACK QUEEN FORWARD
        for square in desk.subviews {
            if square.frame.contains(recognizer.location(in: desk)) {
                if checker.tag == 3, currentGamer == .blackPlaying {
                    if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                       (square.tag == (squareOfChecker.tag - 7) ||
                        square.tag == (squareOfChecker.tag - 9) ||
                        square.tag == (squareOfChecker.tag + 7) ||
                        square.tag == (squareOfChecker.tag + 9))  {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                            desk.bringSubviewToFront(square)
                            square.addSubview(checker)
                            checker.frame.origin = .zero
                            nextMove(nextMove: .whitePlaying, text: "White's move")
                            checkingStepsAllCheckers(recognizer: recognizer)
                        }
                    } else {
                        if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                           square.tag == (squareOfChecker.tag + 14) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                desk.bringSubviewToFront(square)
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                checkingStepsAllCheckers(recognizer: recognizer)
                            }
                        } else {
                            if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                               square.tag == (squareOfChecker.tag + 18) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil {
                                    desk.bringSubviewToFront(square)
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                    checkingStepsAllCheckers(recognizer: recognizer)
                                }
                            } else {
                                if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                    arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                    square.tag == (squareOfChecker.tag + 21) {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                       ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                        sevenTop.first?.subviews.first?.removeFromSuperview()
                                        fourteenTop.first?.subviews.first?.removeFromSuperview()
                                        desk.bringSubviewToFront(square)
                                        beatWhiteCheckers += 1
                                        finishGame()
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                        checkBeatCheckerBlack(recognizer: recognizer)
                                        checkingStepsAllCheckers(recognizer: recognizer)
                                        }
                                    } else {
                                        if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                           square.tag == (squareOfChecker.tag + 21) {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                desk.bringSubviewToFront(square)
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                checkingStepsAllCheckers(recognizer: recognizer)
                                    }
                                } else {
                                    if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                    arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                       square.tag == (squareOfChecker.tag + 27) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                           ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                            nineTop.first?.subviews.first?.removeFromSuperview()
                                            eighteenTop.first?.subviews.first?.removeFromSuperview()
                                            desk.bringSubviewToFront(square)
                                            beatWhiteCheckers += 1
                                            finishGame()
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                            checkBeatCheckerBlack(recognizer: recognizer)
                                            checkingStepsAllCheckers(recognizer: recognizer)
                                            }
                                        } else {
                                            if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                               square.tag == (squareOfChecker.tag + 27) {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                    desk.bringSubviewToFront(square)
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                        }
                                    } else {
                                        if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                            arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                            square.tag == (squareOfChecker.tag + 36) {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                               ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentySevenTop.first?.subviews.first?.tag == 0 || twentySevenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                nineTop.first?.subviews.first?.removeFromSuperview()
                                                eighteenTop.first?.subviews.first?.removeFromSuperview()
                                                twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                                desk.bringSubviewToFront(square)
                                                beatWhiteCheckers += 1
                                                finishGame()
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                checkBeatCheckerBlack(recognizer: recognizer)
                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                }
                                            } else {
                                                if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                   square.tag == (squareOfChecker.tag + 36) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                        desk.bringSubviewToFront(square)
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                            }
                                        } else {
                                            if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                               square.tag == (squareOfChecker.tag + 45) {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                   ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((twentySevenTop.first?.subviews.first?.tag == 0 || twentySevenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((thirtySixTop.first?.subviews.first?.tag == 0 || thirtySixTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                    nineTop.first?.subviews.first?.removeFromSuperview()
                                                    eighteenTop.first?.subviews.first?.removeFromSuperview()
                                                    twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                                    thirtySixTop.first?.subviews.first?.removeFromSuperview()
                                                    desk.bringSubviewToFront(square)
                                                    beatWhiteCheckers += 1
                                                    finishGame()
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    checkBeatCheckerBlack(recognizer: recognizer)
                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                                    }
                                                } else {
                                                    if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                       square.tag == (squareOfChecker.tag + 45) {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                            desk.bringSubviewToFront(square)
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                            checkingStepsAllCheckers(recognizer: recognizer)
                                                }
                                            } else {
                                                if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                    arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                                   square.tag == (squareOfChecker.tag + 54) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                       ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentySevenTop.first?.subviews.first?.tag == 0 || twentySevenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((thirtySixTop.first?.subviews.first?.tag == 0 || thirtySixTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&  fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fortyFiveTop.first?.subviews.first?.tag == 0 || fortyFiveTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                        nineTop.first?.subviews.first?.removeFromSuperview()
                                                        eighteenTop.first?.subviews.first?.removeFromSuperview()
                                                        twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                                        thirtySixTop.first?.subviews.first?.removeFromSuperview()
                                                        fortyFiveTop.first?.subviews.first?.removeFromSuperview()
                                                        desk.bringSubviewToFront(square)
                                                        beatWhiteCheckers += 1
                                                        finishGame()
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        checkBeatCheckerBlack(recognizer: recognizer)
                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                                        }
                                                    } else {
                                                        if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                           square.tag == (squareOfChecker.tag + 54) {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil
                                                            {
                                                                desk.bringSubviewToFront(square)
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                    }
                                                } else {
                                                    if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                        arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                                       square.tag == (squareOfChecker.tag + 28) {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                           ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                            ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                            ((twentyOneTop.first?.subviews.first?.tag == 0 || twentyOneTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                            sevenTop.first?.subviews.first?.removeFromSuperview()
                                                            fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                            twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                            desk.bringSubviewToFront(square)
                                                            beatWhiteCheckers += 1
                                                            finishGame()
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                            checkBeatCheckerBlack(recognizer: recognizer)
                                                            checkingStepsAllCheckers(recognizer: recognizer)
                                                            }
                                                        } else {
                                                            if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                               square.tag == (squareOfChecker.tag + 28) {
                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                    desk.bringSubviewToFront(square)
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                                        }
                                                    } else {
                                                        if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                            arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                                           square.tag == (squareOfChecker.tag + 35) {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                               ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                ((twentyOneTop.first?.subviews.first?.tag == 0 || twentyOneTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                ((twentyEightTop.first?.subviews.first?.tag == 0 || twentyEightTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                sevenTop.first?.subviews.first?.removeFromSuperview()
                                                                fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                                twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                                twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                                desk.bringSubviewToFront(square)
                                                                beatWhiteCheckers += 1
                                                                finishGame()
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                checkBeatCheckerBlack(recognizer: recognizer)
                                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                                }
                                                            } else {
                                                                if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                                   square.tag == (squareOfChecker.tag + 35) {
                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                        desk.bringSubviewToFront(square)
                                                                        square.addSubview(checker)
                                                                        checker.frame.origin = .zero
                                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                                            }
                                                        } else {
                                                            if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                                arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                                               square.tag == (squareOfChecker.tag + 42) {
                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                   ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                    ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                    ((twentyOneTop.first?.subviews.first?.tag == 0 || twentyOneTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                    ((twentyEightTop.first?.subviews.first?.tag == 0 || twentyEightTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                    ((thirtyFiveTop.first?.subviews.first?.tag == 0 || thirtyFiveTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                    sevenTop.first?.subviews.first?.removeFromSuperview()
                                                                    fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                                    twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                                    twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                                    thirtyFiveTop.first?.subviews.first?.removeFromSuperview()
                                                                    desk.bringSubviewToFront(square)
                                                                    beatWhiteCheckers += 1
                                                                    finishGame()
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                    checkBeatCheckerBlack(recognizer: recognizer)
                                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                                                    }
                                                                } else {
                                                                    if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                                       square.tag == (squareOfChecker.tag + 42) {
                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                            desk.bringSubviewToFront(square)
                                                                            square.addSubview(checker)
                                                                            checker.frame.origin = .zero
                                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                            checkingStepsAllCheckers(recognizer: recognizer)
                                                                }
                                                            } else {
                                                                if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                                    arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                                                    square.tag == (squareOfChecker.tag + 49) {
                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                       ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((twentyOneTop.first?.subviews.first?.tag == 0 || twentyOneTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((twentyEightTop.first?.subviews.first?.tag == 0 || twentyEightTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((thirtyFiveTop.first?.subviews.first?.tag == 0 || thirtyFiveTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((fortyTwoTop.first?.subviews.first?.tag == 0 || fortyTwoTop.first?.subviews.first?.tag == 2) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                        sevenTop.first?.subviews.first?.removeFromSuperview()
                                                                        fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                                        twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                                        twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                                        thirtyFiveTop.first?.subviews.first?.removeFromSuperview()
                                                                        fortyTwoTop.first?.subviews.first?.removeFromSuperview()
                                                                        desk.bringSubviewToFront(square)
                                                                        beatWhiteCheckers += 1
                                                                        finishGame()
                                                                        square.addSubview(checker)
                                                                        checker.frame.origin = .zero
                                                                        checkBeatCheckerBlack(recognizer: recognizer)
                                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                                                       }
                                                                    } else {
                                                                        if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                                           square.tag == (squareOfChecker.tag + 49) {
                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                desk.bringSubviewToFront(square)
                                                                                square.addSubview(checker)
                                                                                checker.frame.origin = .zero
                                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                                    }
//MARK: - BLACK QUEEN BACK
   } else {
       if  arrayPossibleStepsBlack.isEmpty,
           arrayPossibleStepsQueenBlack.isEmpty,
           square.tag == (squareOfChecker.tag - 14) {
           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
               desk.bringSubviewToFront(square)
               square.addSubview(checker)
               checker.frame.origin = .zero
               nextMove(nextMove: .whitePlaying, text: "White's move")
               checkingStepsAllCheckers(recognizer: recognizer)
           }
       } else {
           if arrayPossibleStepsBlack.isEmpty,
              arrayPossibleStepsQueenBlack.isEmpty,
              square.tag == (squareOfChecker.tag - 18) {
               if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil {
                   desk.bringSubviewToFront(square)
                   square.addSubview(checker)
                   checker.frame.origin = .zero
                   nextMove(nextMove: .whitePlaying, text: "White's move")
                   checkingStepsAllCheckers(recognizer: recognizer)
               }
           } else {
               if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                  arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                  square.tag == (squareOfChecker.tag - 21) {
                   if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                      ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                       sevenBottom.first?.subviews.first?.removeFromSuperview()
                       fourteenBottom.first?.subviews.first?.removeFromSuperview()
                       desk.bringSubviewToFront(square)
                       beatWhiteCheckers += 1
                       finishGame()
                       square.addSubview(checker)
                       checker.frame.origin = .zero
                       checkBeatCheckerBlack(recognizer: recognizer)
                       checkingStepsAllCheckers(recognizer: recognizer)
                       }
                   } else {
                       if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                          square.tag == (squareOfChecker.tag - 21) {
                           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                               desk.bringSubviewToFront(square)
                               square.addSubview(checker)
                               checker.frame.origin = .zero
                               nextMove(nextMove: .whitePlaying, text: "White's move")
                               checkingStepsAllCheckers(recognizer: recognizer)
                   }
               } else {
                   if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                      arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                      square.tag == (squareOfChecker.tag - 27) {
                       if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                          ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                           nineBottom.first?.subviews.first?.removeFromSuperview()
                           eighteenBottom.first?.subviews.first?.removeFromSuperview()
                           desk.bringSubviewToFront(square)
                           beatWhiteCheckers += 1
                           finishGame()
                           square.addSubview(checker)
                           checker.frame.origin = .zero
                           checkBeatCheckerBlack(recognizer: recognizer)
                           checkingStepsAllCheckers(recognizer: recognizer)
                          }
                       } else {
                           if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                              square.tag == (squareOfChecker.tag - 27) {
                               if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                   desk.bringSubviewToFront(square)
                                   square.addSubview(checker)
                                   checker.frame.origin = .zero
                                   nextMove(nextMove: .whitePlaying, text: "White's move")
                                   checkingStepsAllCheckers(recognizer: recognizer)
                       }
                   } else {
                       if arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                          square.tag == (squareOfChecker.tag - 36) {
                           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                              ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentySevenBottom.first?.subviews.first?.tag == 0 || twentySevenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                               nineBottom.first?.subviews.first?.removeFromSuperview()
                               eighteenBottom.first?.subviews.first?.removeFromSuperview()
                               twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                               desk.bringSubviewToFront(square)
                               beatWhiteCheckers += 1
                               finishGame()
                               square.addSubview(checker)
                               checker.frame.origin = .zero
                               checkBeatCheckerBlack(recognizer: recognizer)
                               checkingStepsAllCheckers(recognizer: recognizer)
                              }
                           } else {
                               if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                  square.tag == (squareOfChecker.tag - 36) {
                                   if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                       desk.bringSubviewToFront(square)
                                       square.addSubview(checker)
                                       checker.frame.origin = .zero
                                       nextMove(nextMove: .whitePlaying, text: "White's move")
                                       checkingStepsAllCheckers(recognizer: recognizer)
                           }
                       } else {
                           if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                              arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                              square.tag == (squareOfChecker.tag - 45) {
                               if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                  ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((twentySevenBottom.first?.subviews.first?.tag == 0 || twentySevenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((thirtySixBottom.first?.subviews.first?.tag == 0 || thirtySixBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                   nineBottom.first?.subviews.first?.removeFromSuperview()
                                   eighteenBottom.first?.subviews.first?.removeFromSuperview()
                                   twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                                   thirtySixBottom.first?.subviews.first?.removeFromSuperview()
                                   desk.bringSubviewToFront(square)
                                   beatWhiteCheckers += 1
                                   finishGame()
                                   square.addSubview(checker)
                                   checker.frame.origin = .zero
                                   checkBeatCheckerBlack(recognizer: recognizer)
                                   checkingStepsAllCheckers(recognizer: recognizer)
                                   }
                               } else {
                                   if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                      square.tag == (squareOfChecker.tag - 45) {
                                       if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                           desk.bringSubviewToFront(square)
                                           square.addSubview(checker)
                                           checker.frame.origin = .zero
                                           nextMove(nextMove: .whitePlaying, text: "White's move")
                                           checkingStepsAllCheckers(recognizer: recognizer)
                               }
                           } else {
                               if arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag), square.tag == (squareOfChecker.tag - 54) {
                                   if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                      ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((twentySevenBottom.first?.subviews.first?.tag == 0 || twentySevenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((thirtySixBottom.first?.subviews.first?.tag == 0 || thirtySixBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((fortyFiveBottom.first?.subviews.first?.tag == 0 || fortyFiveBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                       nineBottom.first?.subviews.first?.removeFromSuperview()
                                       eighteenBottom.first?.subviews.first?.removeFromSuperview()
                                       twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                                       thirtySixBottom.first?.subviews.first?.removeFromSuperview()
                                       fortyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                       desk.bringSubviewToFront(square)
                                       beatWhiteCheckers += 1
                                       finishGame()
                                       square.addSubview(checker)
                                       checker.frame.origin = .zero
                                       checkBeatCheckerBlack(recognizer: recognizer)
                                       checkingStepsAllCheckers(recognizer: recognizer)
                                       }
                                   } else {
                                       if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                          square.tag == (squareOfChecker.tag - 54) {
                                           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                               desk.bringSubviewToFront(square)
                                               square.addSubview(checker)
                                               checker.frame.origin = .zero
                                               nextMove(nextMove: .whitePlaying, text: "White's move")
                                               checkingStepsAllCheckers(recognizer: recognizer)
                                   }
                               } else {
                                   if arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                      square.tag == (squareOfChecker.tag - 28) {
                                       if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                          ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((twentyOneBottom.first?.subviews.first?.tag == 0 || twentyOneBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                           sevenBottom.first?.subviews.first?.removeFromSuperview()
                                           fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                           twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                           desk.bringSubviewToFront(square)
                                           beatWhiteCheckers += 1
                                           finishGame()
                                           square.addSubview(checker)
                                           checker.frame.origin = .zero
                                           checkBeatCheckerBlack(recognizer: recognizer)
                                           checkingStepsAllCheckers(recognizer: recognizer)
                                           }
                                       } else {
                                           if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                              square.tag == (squareOfChecker.tag - 28) {
                                               if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                   desk.bringSubviewToFront(square)
                                                   square.addSubview(checker)
                                                   checker.frame.origin = .zero
                                                   nextMove(nextMove: .whitePlaying, text: "White's move")
                                                   checkingStepsAllCheckers(recognizer: recognizer)
                                       }
                                   } else {
                                       if arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag), square.tag == (squareOfChecker.tag - 35) {
                                           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                              ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentyOneBottom.first?.subviews.first?.tag == 0 || twentyOneBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentyEightBottom.first?.subviews.first?.tag == 0 || twentyEightBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                               sevenBottom.first?.subviews.first?.removeFromSuperview()
                                               fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                               twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                               twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                               desk.bringSubviewToFront(square)
                                               beatWhiteCheckers += 1
                                               finishGame()
                                               square.addSubview(checker)
                                               checker.frame.origin = .zero
                                               checkBeatCheckerBlack(recognizer: recognizer)
                                               checkingStepsAllCheckers(recognizer: recognizer)
                                               }
                                           } else {
                                               if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                  square.tag == (squareOfChecker.tag - 35) {
                                                   if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                       desk.bringSubviewToFront(square)
                                                       square.addSubview(checker)
                                                       checker.frame.origin = .zero
                                                       nextMove(nextMove: .whitePlaying, text: "White's move")
                                                       checkingStepsAllCheckers(recognizer: recognizer)
                                           }
                                       } else {
                                           if arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag),
                                              square.tag == (squareOfChecker.tag - 42) {
                                               if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                  ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((twentyOneBottom.first?.subviews.first?.tag == 0 || twentyOneBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((twentyEightBottom.first?.subviews.first?.tag == 0 || twentyEightBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((thirtyFiveBottom.first?.subviews.first?.tag == 0 || thirtyFiveBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                   sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                   fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                   twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                   twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                                   thirtyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                                   desk.bringSubviewToFront(square)
                                                   beatWhiteCheckers += 1
                                                   finishGame()
                                                   square.addSubview(checker)
                                                   checker.frame.origin = .zero
                                                   checkBeatCheckerBlack(recognizer: recognizer)
                                                   checkingStepsAllCheckers(recognizer: recognizer)
                                                   }
                                               } else {
                                                   if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                      square.tag == (squareOfChecker.tag - 42) {
                                                       if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                           desk.bringSubviewToFront(square)
                                                           square.addSubview(checker)
                                                           checker.frame.origin = .zero
                                                           nextMove(nextMove: .whitePlaying, text: "White's move")
                                                           checkingStepsAllCheckers(recognizer: recognizer)
                                               }
                                           } else {
                                               if arrayPossibleStepsBlack.contains(squareOfChecker.tag) ||
                                                  arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag), square.tag == (squareOfChecker.tag - 49) {
                                                   if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                      ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentyOneBottom.first?.subviews.first?.tag == 0 || twentyOneBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentyEightBottom.first?.subviews.first?.tag == 0 || twentyEightBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((thirtyFiveBottom.first?.subviews.first?.tag == 0 || thirtyFiveBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fortyTwoBottom.first?.subviews.first?.tag == 0 || fortyTwoBottom.first?.subviews.first?.tag == 2) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                       sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                       fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                       twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                       twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                                       thirtyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                                       fortyTwoBottom.first?.subviews.first?.removeFromSuperview()
                                                       desk.bringSubviewToFront(square)
                                                       beatWhiteCheckers += 1
                                                       finishGame()
                                                       square.addSubview(checker)
                                                       checker.frame.origin = .zero
                                                       checkBeatCheckerBlack(recognizer: recognizer)
                                                       checkingStepsAllCheckers(recognizer: recognizer)
                                                       }
                                                   } else {
                                                       if arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                          square.tag == (squareOfChecker.tag - 49) {
                                                           if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                               desk.bringSubviewToFront(square)
                                                               square.addSubview(checker)
                                                               checker.frame.origin = .zero
                                                               nextMove(nextMove: .whitePlaying, text: "White's move")
                                                               checkingStepsAllCheckers(recognizer: recognizer)
                                                           }}
                                                   }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
// MARK: - WHITE QUEEN FORWARD
} else {
    if checker.tag == 2, currentGamer == .whitePlaying {
       if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
          (square.tag == (squareOfChecker.tag - 7) ||
           square.tag == (squareOfChecker.tag - 9) ||
           square.tag == (squareOfChecker.tag + 7) ||
           square.tag == (squareOfChecker.tag + 9))  {
            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
            desk.bringSubviewToFront(square)
            square.addSubview(checker)
            checker.frame.origin = .zero
            nextMove(nextMove: .blackPlaying, text: "Black's move")
            checkingStepsAllCheckers(recognizer: recognizer)
        }
    } else {
        if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
           square.tag == (squareOfChecker.tag + 14) {
            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                desk.bringSubviewToFront(square)
                square.addSubview(checker)
                checker.frame.origin = .zero
                nextMove(nextMove: .blackPlaying, text: "Black's move")
                checkingStepsAllCheckers(recognizer: recognizer)
            }
        } else {
            if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
               square.tag == (squareOfChecker.tag + 18) {
                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil {
                    desk.bringSubviewToFront(square)
                    square.addSubview(checker)
                    checker.frame.origin = .zero
                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                    checkingStepsAllCheckers(recognizer: recognizer)
                }
            } else {
                if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                    square.tag == (squareOfChecker.tag + 21) {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                       ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                        sevenTop.first?.subviews.first?.removeFromSuperview()
                        fourteenTop.first?.subviews.first?.removeFromSuperview()
                        desk.bringSubviewToFront(square)
                        beatBlackCheckers += 1
                        finishGame()
                        square.addSubview(checker)
                        checker.frame.origin = .zero
                        checkBeatCheckerWhite(recognizer: recognizer)
                        checkingStepsAllCheckers(recognizer: recognizer)
                        }
                    } else {
                        if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                           square.tag == (squareOfChecker.tag + 21) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                desk.bringSubviewToFront(square)
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                checkingStepsAllCheckers(recognizer: recognizer)
                    }
                } else {
                    if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                        arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                       square.tag == (squareOfChecker.tag + 27) {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                           ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil) {
                            nineTop.first?.subviews.first?.removeFromSuperview()
                            eighteenTop.first?.subviews.first?.removeFromSuperview()
                            desk.bringSubviewToFront(square)
                            beatBlackCheckers += 1
                            finishGame()
                            square.addSubview(checker)
                            checker.frame.origin = .zero
                            checkBeatCheckerWhite(recognizer: recognizer)
                            checkingStepsAllCheckers(recognizer: recognizer)
                            }
                        } else {
                            if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                               square.tag == (squareOfChecker.tag + 27) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                    desk.bringSubviewToFront(square)
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                    checkingStepsAllCheckers(recognizer: recognizer)
                        }
                    } else {
                        if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                            square.tag == (squareOfChecker.tag + 36) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                               ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentySevenTop.first?.subviews.first?.tag == 1 || twentySevenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                nineTop.first?.subviews.first?.removeFromSuperview()
                                eighteenTop.first?.subviews.first?.removeFromSuperview()
                                twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                desk.bringSubviewToFront(square)
                                beatBlackCheckers += 1
                                finishGame()
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                                checkBeatCheckerWhite(recognizer: recognizer)
                                checkingStepsAllCheckers(recognizer: recognizer)
                                }
                            } else {
                                if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                   square.tag == (squareOfChecker.tag + 36) {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                        desk.bringSubviewToFront(square)
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                        checkingStepsAllCheckers(recognizer: recognizer)
                            }
                        } else {
                            if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                               square.tag == (squareOfChecker.tag + 45) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                   ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((twentySevenTop.first?.subviews.first?.tag == 1 || twentySevenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((thirtySixTop.first?.subviews.first?.tag == 1 || thirtySixTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                    nineTop.first?.subviews.first?.removeFromSuperview()
                                    eighteenTop.first?.subviews.first?.removeFromSuperview()
                                    twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                    thirtySixTop.first?.subviews.first?.removeFromSuperview()
                                    desk.bringSubviewToFront(square)
                                    beatBlackCheckers += 1
                                    finishGame()
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    checkBeatCheckerWhite(recognizer: recognizer)
                                    checkingStepsAllCheckers(recognizer: recognizer)
                                    }
                                } else {
                                    if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                       square.tag == (squareOfChecker.tag + 45) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil {
                                            desk.bringSubviewToFront(square)
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                            checkingStepsAllCheckers(recognizer: recognizer)
                                }
                            } else {
                                if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                   square.tag == (squareOfChecker.tag + 54) {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                       ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((twentySevenTop.first?.subviews.first?.tag == 1 || twentySevenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((thirtySixTop.first?.subviews.first?.tag == 1 || thirtySixTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&  fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((fortyFiveTop.first?.subviews.first?.tag == 1 || fortyFiveTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                        nineTop.first?.subviews.first?.removeFromSuperview()
                                        eighteenTop.first?.subviews.first?.removeFromSuperview()
                                        twentySevenTop.first?.subviews.first?.removeFromSuperview()
                                        thirtySixTop.first?.subviews.first?.removeFromSuperview()
                                        fortyFiveTop.first?.subviews.first?.removeFromSuperview()
                                        desk.bringSubviewToFront(square)
                                        beatBlackCheckers += 1
                                        finishGame()
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                        checkBeatCheckerWhite(recognizer: recognizer)
                                        checkingStepsAllCheckers(recognizer: recognizer)
                                        }
                                    } else {
                                        if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                           square.tag == (squareOfChecker.tag + 54) {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil
                                            {
                                                desk.bringSubviewToFront(square)
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                checkingStepsAllCheckers(recognizer: recognizer)
                                    }
                                } else {
                                    if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                        arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                       square.tag == (squareOfChecker.tag + 28) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                           ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((twentyOneTop.first?.subviews.first?.tag == 1 || twentyOneTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                            sevenTop.first?.subviews.first?.removeFromSuperview()
                                            fourteenTop.first?.subviews.first?.removeFromSuperview()
                                            twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                            desk.bringSubviewToFront(square)
                                            beatBlackCheckers += 1
                                            finishGame()
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                            checkBeatCheckerWhite(recognizer: recognizer)
                                            checkingStepsAllCheckers(recognizer: recognizer)
                                            }
                                        } else {
                                            if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                               square.tag == (squareOfChecker.tag + 28) {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                    desk.bringSubviewToFront(square)
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                        }
                                    } else {
                                        if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                           square.tag == (squareOfChecker.tag + 35) {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                               ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentyOneTop.first?.subviews.first?.tag == 1 || twentyOneTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentyEightTop.first?.subviews.first?.tag == 1 || twentyEightTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                sevenTop.first?.subviews.first?.removeFromSuperview()
                                                fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                desk.bringSubviewToFront(square)
                                                beatBlackCheckers += 1
                                                finishGame()
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                checkBeatCheckerWhite(recognizer: recognizer)
                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                }
                                            } else {
                                                if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                   square.tag == (squareOfChecker.tag + 35) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                        desk.bringSubviewToFront(square)
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                            }
                                        } else {
                                            if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                               square.tag == (squareOfChecker.tag + 42) {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                   ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((twentyOneTop.first?.subviews.first?.tag == 1 || twentyOneTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((twentyEightTop.first?.subviews.first?.tag == 1 || twentyEightTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                    ((thirtyFiveTop.first?.subviews.first?.tag == 1 || thirtyFiveTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                    sevenTop.first?.subviews.first?.removeFromSuperview()
                                                    fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                    twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                    twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                    thirtyFiveTop.first?.subviews.first?.removeFromSuperview()
                                                    desk.bringSubviewToFront(square)
                                                    beatBlackCheckers += 1
                                                    finishGame()
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    checkBeatCheckerWhite(recognizer: recognizer)
                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                                    }
                                                } else {
                                                    if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                       square.tag == (squareOfChecker.tag + 42) {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                            desk.bringSubviewToFront(square)
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                            checkingStepsAllCheckers(recognizer: recognizer)
                                                }
                                            } else {
                                                if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                                    square.tag == (squareOfChecker.tag + 49) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                       ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentyOneTop.first?.subviews.first?.tag == 1 || twentyOneTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentyEightTop.first?.subviews.first?.tag == 1 || twentyEightTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((thirtyFiveTop.first?.subviews.first?.tag == 1 || thirtyFiveTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fortyTwoTop.first?.subviews.first?.tag == 1 || fortyTwoTop.first?.subviews.first?.tag == 3) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                                        sevenTop.first?.subviews.first?.removeFromSuperview()
                                                        fourteenTop.first?.subviews.first?.removeFromSuperview()
                                                        twentyOneTop.first?.subviews.first?.removeFromSuperview()
                                                        twentyEightTop.first?.subviews.first?.removeFromSuperview()
                                                        thirtyFiveTop.first?.subviews.first?.removeFromSuperview()
                                                        fortyTwoTop.first?.subviews.first?.removeFromSuperview()
                                                        desk.bringSubviewToFront(square)
                                                        beatBlackCheckers += 1
                                                        finishGame()
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        checkBeatCheckerWhite(recognizer: recognizer)
                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                                       }
                                                    } else {
                                                        if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                           square.tag == (squareOfChecker.tag + 49) {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                desk.bringSubviewToFront(square)
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                    }
//MARK: - WHITE QUEEN BACK
  } else {
      if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
          square.tag == (squareOfChecker.tag - 14) {
          if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
              desk.bringSubviewToFront(square)
              square.addSubview(checker)
              checker.frame.origin = .zero
              nextMove(nextMove: .blackPlaying, text: "Black's move")
              checkingStepsAllCheckers(recognizer: recognizer)
          }
      } else {
          if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
             square.tag == (squareOfChecker.tag - 18) {
              if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil {
                  desk.bringSubviewToFront(square)
                  square.addSubview(checker)
                  checker.frame.origin = .zero
                  nextMove(nextMove: .blackPlaying, text: "Black's move")
                  checkingStepsAllCheckers(recognizer: recognizer)
              }
          } else {
              if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                 square.tag == (squareOfChecker.tag - 21) {
                  if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                     ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                      sevenBottom.first?.subviews.first?.removeFromSuperview()
                      fourteenBottom.first?.subviews.first?.removeFromSuperview()
                      desk.bringSubviewToFront(square)
                      beatBlackCheckers += 1
                      finishGame()
                      square.addSubview(checker)
                      checker.frame.origin = .zero
                      checkBeatCheckerWhite(recognizer: recognizer)
                      checkingStepsAllCheckers(recognizer: recognizer)
                  }
              } else {
                  if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                     square.tag == (squareOfChecker.tag - 21) {
                      if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                          desk.bringSubviewToFront(square)
                          square.addSubview(checker)
                          checker.frame.origin = .zero
                          nextMove(nextMove: .blackPlaying, text: "Black's move")
                          checkingStepsAllCheckers(recognizer: recognizer)
                      }
                  } else {
                      if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                         square.tag == (squareOfChecker.tag - 27) {
                          if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                             ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                              nineBottom.first?.subviews.first?.removeFromSuperview()
                              eighteenBottom.first?.subviews.first?.removeFromSuperview()
                              desk.bringSubviewToFront(square)
                              beatBlackCheckers += 1
                              finishGame()
                              square.addSubview(checker)
                              checker.frame.origin = .zero
                              checkBeatCheckerWhite(recognizer: recognizer)
                              checkingStepsAllCheckers(recognizer: recognizer)
                          }
                      } else {
                          if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                             square.tag == (squareOfChecker.tag - 27) {
                              if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                  desk.bringSubviewToFront(square)
                                  square.addSubview(checker)
                                  checker.frame.origin = .zero
                                  nextMove(nextMove: .blackPlaying, text: "Black's move")
                                  checkingStepsAllCheckers(recognizer: recognizer)
                              }
                          } else {
                              if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                 square.tag == (squareOfChecker.tag - 36) {
                                  if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                     ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((twentySevenBottom.first?.subviews.first?.tag == 1 || twentySevenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                      nineBottom.first?.subviews.first?.removeFromSuperview()
                                      eighteenBottom.first?.subviews.first?.removeFromSuperview()
                                      twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                                      desk.bringSubviewToFront(square)
                                      beatBlackCheckers += 1
                                      finishGame()
                                      square.addSubview(checker)
                                      checker.frame.origin = .zero
                                      checkBeatCheckerWhite(recognizer: recognizer)
                                      checkingStepsAllCheckers(recognizer: recognizer)
                                  }
                              } else {
                                  if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                     square.tag == (squareOfChecker.tag - 36) {
                                      if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                          desk.bringSubviewToFront(square)
                                          square.addSubview(checker)
                                          checker.frame.origin = .zero
                                          nextMove(nextMove: .blackPlaying, text: "Black's move")
                                          checkingStepsAllCheckers(recognizer: recognizer)
                                      }
                                  } else {
                                      if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                         square.tag == (squareOfChecker.tag - 45) {
                                          if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                             ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((twentySevenBottom.first?.subviews.first?.tag == 1 || twentySevenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                ((thirtySixBottom.first?.subviews.first?.tag == 1 || thirtySixBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                              nineBottom.first?.subviews.first?.removeFromSuperview()
                                              eighteenBottom.first?.subviews.first?.removeFromSuperview()
                                              twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                                              thirtySixBottom.first?.subviews.first?.removeFromSuperview()
                                              desk.bringSubviewToFront(square)
                                              beatBlackCheckers += 1
                                              finishGame()
                                              square.addSubview(checker)
                                              checker.frame.origin = .zero
                                              checkBeatCheckerWhite(recognizer: recognizer)
                                              checkingStepsAllCheckers(recognizer: recognizer)
                                          }
                                      } else {
                                          if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                             square.tag == (squareOfChecker.tag - 45) {
                                              if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                  desk.bringSubviewToFront(square)
                                                  square.addSubview(checker)
                                                  checker.frame.origin = .zero
                                                  nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                  checkingStepsAllCheckers(recognizer: recognizer)
                                              }
                                          } else {
                                              if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag), square.tag == (squareOfChecker.tag - 54) {
                                                  if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                     ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentySevenBottom.first?.subviews.first?.tag == 1 || twentySevenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((thirtySixBottom.first?.subviews.first?.tag == 1 || thirtySixBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((fortyFiveBottom.first?.subviews.first?.tag == 1 || fortyFiveBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                      nineBottom.first?.subviews.first?.removeFromSuperview()
                                                      eighteenBottom.first?.subviews.first?.removeFromSuperview()
                                                      twentySevenBottom.first?.subviews.first?.removeFromSuperview()
                                                      thirtySixBottom.first?.subviews.first?.removeFromSuperview()
                                                      fortyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                                      desk.bringSubviewToFront(square)
                                                      beatBlackCheckers += 1
                                                      finishGame()
                                                      square.addSubview(checker)
                                                      checker.frame.origin = .zero
                                                      checkBeatCheckerWhite(recognizer: recognizer)
                                                      checkingStepsAllCheckers(recognizer: recognizer)
                                                  }
                                              } else {
                                                  if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                     square.tag == (squareOfChecker.tag - 54) {
                                                      if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                          desk.bringSubviewToFront(square)
                                                          square.addSubview(checker)
                                                          checker.frame.origin = .zero
                                                          nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                          checkingStepsAllCheckers(recognizer: recognizer)
                                                      }
                                                  } else {
                                                      if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                                         square.tag == (squareOfChecker.tag - 28) {
                                                          if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                             ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                ((twentyOneBottom.first?.subviews.first?.tag == 1 || twentyOneBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                              sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                              fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                              twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                              desk.bringSubviewToFront(square)
                                                              beatBlackCheckers += 1
                                                              finishGame()
                                                              square.addSubview(checker)
                                                              checker.frame.origin = .zero
                                                              checkBeatCheckerWhite(recognizer: recognizer)
                                                              checkingStepsAllCheckers(recognizer: recognizer)
                                                          }
                                                      } else {
                                                          if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                             square.tag == (squareOfChecker.tag - 28) {
                                                              if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                  desk.bringSubviewToFront(square)
                                                                  square.addSubview(checker)
                                                                  checker.frame.origin = .zero
                                                                  nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                  checkingStepsAllCheckers(recognizer: recognizer)
                                                              }
                                                          } else {
                                                              if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                                                    square.tag == (squareOfChecker.tag - 35) {
                                                                  if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                     ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((twentyOneBottom.first?.subviews.first?.tag == 1 || twentyOneBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                        ((twentyEightBottom.first?.subviews.first?.tag == 1 || twentyEightBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                      sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                                      fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                                      twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                                      twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                                                      desk.bringSubviewToFront(square)
                                                                      beatBlackCheckers += 1
                                                                      finishGame()
                                                                      square.addSubview(checker)
                                                                      checker.frame.origin = .zero
                                                                      checkBeatCheckerWhite(recognizer: recognizer)
                                                                      checkingStepsAllCheckers(recognizer: recognizer)
                                                                  }
                                                              } else {
                                                                  if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                                     square.tag == (squareOfChecker.tag - 35) {
                                                                      if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                          desk.bringSubviewToFront(square)
                                                                          square.addSubview(checker)
                                                                          checker.frame.origin = .zero
                                                                          nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                          checkingStepsAllCheckers(recognizer: recognizer)
                                                                      }
                                                                  } else {
                                                                      if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                                            arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag),
                                                                         square.tag == (squareOfChecker.tag - 42) {
                                                                          if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                             ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                ((twentyOneBottom.first?.subviews.first?.tag == 1 || twentyOneBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                ((twentyEightBottom.first?.subviews.first?.tag == 1 || twentyEightBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                ((thirtyFiveBottom.first?.subviews.first?.tag == 1 || thirtyFiveBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                              sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                                              fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                                              twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                                              twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                                                              thirtyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                                                              desk.bringSubviewToFront(square)
                                                                              beatBlackCheckers += 1
                                                                              finishGame()
                                                                              square.addSubview(checker)
                                                                              checker.frame.origin = .zero
                                                                              checkBeatCheckerWhite(recognizer: recognizer)
                                                                              checkingStepsAllCheckers(recognizer: recognizer)
                                                                          }
                                                                      } else {
                                                                          if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                                             square.tag == (squareOfChecker.tag - 42) {
                                                                              if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                  desk.bringSubviewToFront(square)
                                                                                  square.addSubview(checker)
                                                                                  checker.frame.origin = .zero
                                                                                  nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                  checkingStepsAllCheckers(recognizer: recognizer)
                                                                              }
                                                                          } else {
                                                                              if arrayPossibleStepsWhite.contains(squareOfChecker.tag) ||
                                                                                    arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag), square.tag == (squareOfChecker.tag - 49) {
                                                                                  if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                     ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((twentyOneBottom.first?.subviews.first?.tag == 1 || twentyOneBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((twentyEightBottom.first?.subviews.first?.tag == 1 || twentyEightBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((thirtyFiveBottom.first?.subviews.first?.tag == 1 || thirtyFiveBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((fortyTwoBottom.first?.subviews.first?.tag == 1 || fortyTwoBottom.first?.subviews.first?.tag == 3) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                                                                      sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      fourteenBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      twentyOneBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      twentyEightBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      thirtyFiveBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      fortyTwoBottom.first?.subviews.first?.removeFromSuperview()
                                                                                      desk.bringSubviewToFront(square)
                                                                                      beatBlackCheckers += 1
                                                                                      finishGame()
                                                                                      square.addSubview(checker)
                                                                                      checker.frame.origin = .zero
                                                                                      checkBeatCheckerWhite(recognizer: recognizer)
                                                                                      checkingStepsAllCheckers(recognizer: recognizer)
                                                                                  }
                                                                              } else {
                                                                                  if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                                                                                     square.tag == (squareOfChecker.tag - 49) {
                                                                                      if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                          desk.bringSubviewToFront(square)
                                                                                          square.addSubview(checker)
                                                                                          checker.frame.origin = .zero
                                                                                          nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                          checkingStepsAllCheckers(recognizer: recognizer)
                                                                                      }}
                                                                                  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}
                
 //MARK: - CAN YOU MOVE AGAIN
extension GamerViewController {
    
    func checkBeatCheckerWhite(recognizer: UIPanGestureRecognizer) {
        arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
        if canYouMove(gesture: recognizer, checkerMove: 0, queenMove: 2, checkerCheck: 1, queenCheck: 3) {
            currentGamer = .whitePlaying
            whoMustMoveLabel.text = "White's move".localized
            saveCurrentMove = currentGamer
        } else {
            currentGamer = .blackPlaying
            whoMustMoveLabel.text = "Black's move".localized
            saveCurrentMove = currentGamer
        }
    }
    
    func checkBeatCheckerBlack(recognizer: UIPanGestureRecognizer) {
        arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
        if canYouMove(gesture: recognizer, checkerMove: 1, queenMove: 3, checkerCheck: 0, queenCheck: 2) {
            currentGamer = .blackPlaying
            whoMustMoveLabel.text = "Black's move".localized
            saveCurrentMove = currentGamer
        } else {
            currentGamer = .whitePlaying
            whoMustMoveLabel.text = "White's move".localized
            saveCurrentMove = currentGamer
        }
    }
    
    func canYouMove(gesture: UIPanGestureRecognizer, checkerMove: Int, queenMove: Int, checkerCheck: Int, queenCheck: Int) -> Bool {
        guard let checker = gesture.view, let squareOfChecker = checker.superview else {return true}
        var takeStep: Bool?
        let sevenTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 7)}
        let nineTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 9)}
        let fourteenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 14)}
        let eighteenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 18)}
        let twentyOneTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 21)}
        let twentySevenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 27)}
        let twentyEightTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 28)}
        let thirtyFiveTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 35)}
        let thirtySixTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 36)}
        let fortyTwoTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 42)}
        let fortyFiveTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 45)}
        let sevenBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 7)}
        let nineBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 9)}
        let fourteenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 14)}
        let eighteenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 18)}
        let twentyOneBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 21)}
        let twentySevenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 27)}
        let twentyEightBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 28)}
        let thirtyFiveBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 35)}
        let thirtySixBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 36)}
        let fortyTwoBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 42)}
        let fortyFiveBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 45)}
        
        for square in desk.subviews {
            if checker.tag == checkerMove || checker.tag == queenMove, square.tag == (squareOfChecker.tag + 14), squareOfChecker.tag < 48 {
                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                   sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck {
                    takeStep = true
                }
            } else {
                if checker.tag == checkerMove || checker.tag == queenMove, square.tag == (squareOfChecker.tag + 18), squareOfChecker.tag < 48 {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                       nineTop.first?.subviews.first?.tag == checkerCheck || nineTop.first?.subviews.first?.tag == queenCheck {
                        takeStep = true
                    }
                } else {
                    if checker.tag == checkerMove || checker.tag == queenMove, square.tag == (squareOfChecker.tag - 14), squareOfChecker.tag > 15 {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                           sevenBottom.first?.subviews.first?.tag == checkerCheck ||
                            sevenBottom.first?.subviews.first?.tag == queenCheck {
                            takeStep = true
                        }
                    } else {
                        if checker.tag == checkerMove || checker.tag == queenMove, square.tag == (squareOfChecker.tag - 18), squareOfChecker.tag > 15 {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                nineBottom.first?.subviews.first?.tag == checkerCheck ||
                                nineBottom.first?.subviews.first?.tag == queenCheck {
                                takeStep = true
                            }
                        } else {
                            if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 27) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                    ((nineTop.first?.subviews.first?.tag == checkerCheck || nineTop.first?.subviews.first?.tag == queenCheck) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((eighteenTop.first?.subviews.first?.tag == checkerCheck || eighteenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                    takeStep = true
                                }
                            } else {
                                    if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 36) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                            ((nineTop.first?.subviews.first?.tag == checkerCheck || nineTop.first?.subviews.first?.tag == queenCheck) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((eighteenTop.first?.subviews.first?.tag == checkerCheck || eighteenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((twentySevenTop.first?.subviews.first?.tag == checkerCheck || twentySevenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil)  {
                                            takeStep = true
                                        }
} else {
    if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 45) {
        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
            ((nineTop.first?.subviews.first?.tag == checkerCheck || nineTop.first?.subviews.first?.tag == queenCheck) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((eighteenTop.first?.subviews.first?.tag == checkerCheck || eighteenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((twentySevenTop.first?.subviews.first?.tag == checkerCheck || twentySevenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((thirtySixTop.first?.subviews.first?.tag == checkerCheck || thirtySixTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil)   {
            takeStep = true
        }
    } else {
        if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 54) {
            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                ((nineTop.first?.subviews.first?.tag == checkerCheck || nineTop.first?.subviews.first?.tag == queenCheck) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((eighteenTop.first?.subviews.first?.tag == checkerCheck || eighteenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((twentySevenTop.first?.subviews.first?.tag == checkerCheck || twentySevenTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((thirtySixTop.first?.subviews.first?.tag == checkerCheck || thirtySixTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil  && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((fortyFiveTop.first?.subviews.first?.tag == checkerCheck || fortyFiveTop.first?.subviews.first?.tag == queenCheck) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil)    {
                takeStep = true
            }
         } else {
            if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 21) {
                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                    ((sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                    ((fourteenTop.first?.subviews.first?.tag == checkerCheck || fourteenTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                    takeStep = true
                }
            } else {
                if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 28) {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                        ((sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((fourteenTop.first?.subviews.first?.tag == checkerCheck || fourteenTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((twentyOneTop.first?.subviews.first?.tag == checkerCheck || twentyOneTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil) {
                        takeStep = true
                    }
                } else {
                    if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 35) {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                            ((sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((fourteenTop.first?.subviews.first?.tag == checkerCheck || fourteenTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyOneTop.first?.subviews.first?.tag == checkerCheck || twentyOneTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyEightTop.first?.subviews.first?.tag == checkerCheck || twentyEightTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil) {
                            takeStep = true
                    }
                } else {
                    if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 42) {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                            ((sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((fourteenTop.first?.subviews.first?.tag == checkerCheck || fourteenTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyOneTop.first?.subviews.first?.tag == checkerCheck || twentyOneTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyEightTop.first?.subviews.first?.tag == checkerCheck || twentyEightTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((thirtyFiveTop.first?.subviews.first?.tag == checkerCheck || thirtyFiveTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil) {
                            takeStep = true
                        }
                    } else {
                        if checker.tag == queenMove, square.tag == (squareOfChecker.tag + 49) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                ((sevenTop.first?.subviews.first?.tag == checkerCheck || sevenTop.first?.subviews.first?.tag == queenCheck) && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((fourteenTop.first?.subviews.first?.tag == checkerCheck || fourteenTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentyOneTop.first?.subviews.first?.tag == checkerCheck || twentyOneTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentyEightTop.first?.subviews.first?.tag == checkerCheck || twentyEightTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((thirtyFiveTop.first?.subviews.first?.tag == checkerCheck || thirtyFiveTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((fortyTwoTop.first?.subviews.first?.tag == checkerCheck || fortyTwoTop.first?.subviews.first?.tag == queenCheck) && sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) {
                                takeStep = true
                            }
                        } else {
                            if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 27) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                    ((nineBottom.first?.subviews.first?.tag == checkerCheck || nineBottom.first?.subviews.first?.tag == queenCheck) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((eighteenBottom.first?.subviews.first?.tag == checkerCheck || eighteenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                    takeStep = true
                                }
                            } else {
                                    if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 36) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                            ((nineBottom.first?.subviews.first?.tag == checkerCheck || nineBottom.first?.subviews.first?.tag == queenCheck) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((eighteenBottom.first?.subviews.first?.tag == checkerCheck || eighteenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((twentySevenBottom.first?.subviews.first?.tag == checkerCheck || twentySevenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil)  {
                                            takeStep = true
                                        }
} else {
    if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 45) {
        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
            ((nineBottom.first?.subviews.first?.tag == checkerCheck || nineBottom.first?.subviews.first?.tag == queenCheck) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((eighteenBottom.first?.subviews.first?.tag == checkerCheck || eighteenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((twentySevenBottom.first?.subviews.first?.tag == checkerCheck || twentySevenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
            ((thirtySixBottom.first?.subviews.first?.tag == checkerCheck || thirtySixBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil)   {
            takeStep = true
        }
    } else {
        if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 54) {
            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                ((nineBottom.first?.subviews.first?.tag == checkerCheck || nineBottom.first?.subviews.first?.tag == queenCheck) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((eighteenBottom.first?.subviews.first?.tag == checkerCheck || eighteenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((twentySevenBottom.first?.subviews.first?.tag == checkerCheck || twentySevenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((thirtySixBottom.first?.subviews.first?.tag == checkerCheck || thirtySixBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                ((fortyFiveBottom.first?.subviews.first?.tag == checkerCheck || fortyFiveBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                takeStep = true
            }
        } else {
            if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 21) {
                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                    ((sevenBottom.first?.subviews.first?.tag == checkerCheck || sevenBottom.first?.subviews.first?.tag == queenCheck) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                    ((fourteenBottom.first?.subviews.first?.tag == checkerCheck || fourteenBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                    takeStep = true
                }
            } else {
                if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 28) {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                        ((sevenBottom.first?.subviews.first?.tag == checkerCheck || sevenBottom.first?.subviews.first?.tag == queenCheck) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((fourteenBottom.first?.subviews.first?.tag == checkerCheck || fourteenBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                        ((twentyOneBottom.first?.subviews.first?.tag == checkerCheck || twentyOneBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                        takeStep = true
                    }
                } else {
                     if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 35) {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                            ((sevenBottom.first?.subviews.first?.tag == checkerCheck || sevenBottom.first?.subviews.first?.tag == queenCheck) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((fourteenBottom.first?.subviews.first?.tag == checkerCheck || fourteenBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyOneBottom.first?.subviews.first?.tag == checkerCheck || twentyOneBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                            ((twentyEightBottom.first?.subviews.first?.tag == checkerCheck || twentyEightBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                            takeStep = true
                        }
                     } else {
                         if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 42) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                ((sevenBottom.first?.subviews.first?.tag == checkerCheck || sevenBottom.first?.subviews.first?.tag == queenCheck) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((fourteenBottom.first?.subviews.first?.tag == checkerCheck || fourteenBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentyOneBottom.first?.subviews.first?.tag == checkerCheck || twentyOneBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((twentyEightBottom.first?.subviews.first?.tag == checkerCheck || twentyEightBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                ((thirtyFiveBottom.first?.subviews.first?.tag == checkerCheck || thirtyFiveBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                takeStep = true
                              }
                         } else {
                             if checker.tag == queenMove, square.tag == (squareOfChecker.tag - 49) {
                                 if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                    ((sevenBottom.first?.subviews.first?.tag == checkerCheck || sevenBottom.first?.subviews.first?.tag == queenCheck) && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((fourteenBottom.first?.subviews.first?.tag == checkerCheck || fourteenBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((twentyOneBottom.first?.subviews.first?.tag == checkerCheck || twentyOneBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((twentyEightBottom.first?.subviews.first?.tag == checkerCheck || twentyEightBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((thirtyFiveBottom.first?.subviews.first?.tag == checkerCheck || thirtyFiveBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                        ((fortyTwoBottom.first?.subviews.first?.tag == checkerCheck || fortyTwoBottom.first?.subviews.first?.tag == queenCheck) && sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil && twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                     takeStep = true
                                 }}}}}}}}}}}}}}}}}}}}}}}}
        return takeStep ?? false
    }
}


// MARK: - YOU HAVE TO BEAT
extension GamerViewController {
    
    func checkingStepsAllCheckers(recognizer: UIPanGestureRecognizer) {
        canStepQueenBlack(gesture: recognizer)
        canStepQueenWhite(gesture: recognizer)
        canStepCheckerBlack(recognizer: recognizer)
        canStepCheckerWhite(recognizer: recognizer)
    }
    
    func canStepCheckerWhite(recognizer: UIPanGestureRecognizer) {
        arrayPossibleStepsWhite.removeAll()
        for square in desk.subviews {
            if square.subviews.first?.tag == 0 || square.subviews.first?.tag == 2 {
                let filterSevenTop = desk.subviews.filter({$0.tag == square.tag + 7})
                let filterNineTop = desk.subviews.filter({$0.tag == square.tag + 9})
                let filterFourteenTop = desk.subviews.filter({$0.tag == square.tag + 14})
                let filterEighteenTop = desk.subviews.filter({$0.tag == square.tag + 18})
                let filterSevenBottom = desk.subviews.filter({$0.tag == square.tag - 7})
                let filterNineBottom = desk.subviews.filter({$0.tag == square.tag - 9})
                let filterFourteenBottom = desk.subviews.filter({$0.tag == square.tag - 14})
                let filterEighteenBottom = desk.subviews.filter({$0.tag == square.tag - 18})
                if  ((filterSevenTop.first?.subviews.first?.tag == 1 || filterSevenTop.first?.subviews.first?.tag == 3) &&
                     filterFourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                     filterFourteenTop.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterNineTop.first?.subviews.first?.tag == 1 || filterNineTop.first?.subviews.first?.tag == 3) &&
                         filterEighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterEighteenTop.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterSevenBottom.first?.subviews.first?.tag == 1 || filterSevenBottom.first?.subviews.first?.tag == 3) &&
                         filterFourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterFourteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterNineBottom.first?.subviews.first?.tag == 1 || filterNineBottom.first?.subviews.first?.tag == 3) &&
                         filterEighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterEighteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) {
                    arrayPossibleStepsWhite.append(square.tag)
                    print("white\(arrayPossibleStepsWhite)")
                }
            }
        }
    }
    
    func canStepCheckerBlack(recognizer: UIPanGestureRecognizer) {
        arrayPossibleStepsBlack.removeAll()
        for square in desk.subviews {
            if square.subviews.first?.tag == 1 || square.subviews.first?.tag == 3 {
                let filterSevenTop = desk.subviews.filter({$0.tag == square.tag + 7})
                let filterNineTop = desk.subviews.filter({$0.tag == square.tag + 9})
                let filterFourteenTop = desk.subviews.filter({$0.tag == square.tag + 14})
                let filterEighteenTop = desk.subviews.filter({$0.tag == square.tag + 18})
                let filterSevenBottom = desk.subviews.filter({$0.tag == square.tag - 7})
                let filterNineBottom = desk.subviews.filter({$0.tag == square.tag - 9})
                let filterFourteenBottom = desk.subviews.filter({$0.tag == square.tag - 14})
                let filterEighteenBottom = desk.subviews.filter({$0.tag == square.tag - 18})
                if  ((filterSevenTop.first?.subviews.first?.tag == 0 || filterSevenTop.first?.subviews.first?.tag == 2) &&
                     filterFourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                     filterFourteenTop.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterNineTop.first?.subviews.first?.tag == 0 || filterNineTop.first?.subviews.first?.tag == 2) &&
                         filterEighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterEighteenTop.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterSevenBottom.first?.subviews.first?.tag == 0 || filterSevenBottom.first?.subviews.first?.tag == 2) &&
                         filterFourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterFourteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack"))
                        ||
                        ((filterNineBottom.first?.subviews.first?.tag == 0 || filterNineBottom.first?.subviews.first?.tag == 2) &&
                         filterEighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                         filterEighteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) {
                    arrayPossibleStepsBlack.append(square.tag)
                    print("black \(arrayPossibleStepsBlack)")
                }
            }
        }
    }
    
    func canStepQueenBlack(gesture: UIPanGestureRecognizer) {
        arrayPossibleStepsQueenBlack.removeAll()
        for square in self.desk.subviews {
            if square.subviews.first?.tag == 3 {
                let sevenTop = desk.subviews.filter{($0.tag == square.tag + 7)}
                let nineTop = desk.subviews.filter{($0.tag == square.tag + 9)}
                let fourteenTop = desk.subviews.filter{($0.tag == square.tag + 14)}
                let eighteenTop = desk.subviews.filter{($0.tag == square.tag + 18)}
                let sevenBottom = desk.subviews.filter{($0.tag == square.tag - 7)}
                let nineBottom = desk.subviews.filter{($0.tag == square.tag - 9)}
                let fourteenBottom = desk.subviews.filter{($0.tag == square.tag - 14)}
                let eighteenBottom = desk.subviews.filter{($0.tag == square.tag - 18)}
                let twentyOneTop = desk.subviews.filter{($0.tag == square.tag + 21)}
                let twentyEightTop = desk.subviews.filter{($0.tag == square.tag + 28)}
                let thirtyFiveTop = desk.subviews.filter{($0.tag == square.tag + 35)}
                let twentySevenTop = desk.subviews.filter{($0.tag == square.tag + 27)}
                let thirtySixTop = desk.subviews.filter{($0.tag == square.tag + 36)}
                let fortyFiveTop = desk.subviews.filter{($0.tag == square.tag + 45)}
                let twentyOneBottom = desk.subviews.filter{($0.tag == square.tag - 21)}
                let twentyEightBottom = desk.subviews.filter{($0.tag == square.tag - 28)}
                let thirtyFiveBottom = desk.subviews.filter{($0.tag == square.tag - 35)}
                let twentySevenBottom = desk.subviews.filter{($0.tag == square.tag - 27)}
                let thirtySixBottom = desk.subviews.filter{($0.tag == square.tag - 36)}
                let fortyFiveBottom = desk.subviews.filter{($0.tag == square.tag - 45)}
                
    //MARK: - (+ 14)
                if ((sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2) &&
                    fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil || twentyOneTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil || twentyEightTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    fourteenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                    
                    ((fourteenTop.first?.subviews.first?.tag == 0 || fourteenTop.first?.subviews.first?.tag == 2) &&
                    sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil || twentyEightTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentyOneTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                     
                    ((twentyOneTop.first?.subviews.first?.tag == 0 || twentyOneTop.first?.subviews.first?.tag == 2) &&
                    sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentyEightTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                     
                    ((twentyEightTop.first?.subviews.first?.tag == 0 || twentyEightTop.first?.subviews.first?.tag == 2) &&
                    sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtyFiveTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
    //MARK: - (+ 18)
                    ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) &&
                    eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil || twentySevenTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil || thirtySixTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                     (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    eighteenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                     
                    ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) &&
                    nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil || thirtySixTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentySevenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                      
                    ((twentySevenTop.first?.subviews.first?.tag == 0 || twentySevenTop.first?.subviews.first?.tag == 2) &&
                    nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                    thirtySixTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                       
                    ((thirtySixTop.first?.subviews.first?.tag == 0 || thirtySixTop.first?.subviews.first?.tag == 2) &&
                    nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                    fortyFiveTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
    //MARK: - (- 14)
                    ((sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2) &&
                    fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyOneBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyEightBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    fourteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                     
                    ((fourteenBottom.first?.subviews.first?.tag == 0 || fourteenBottom.first?.subviews.first?.tag == 2) &&
                    sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyEightBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentyOneBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                      
                    ((twentyOneBottom.first?.subviews.first?.tag == 0 || twentyOneBottom.first?.subviews.first?.tag == 2) &&
                    sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentyEightBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                      
                    ((twentyEightBottom.first?.subviews.first?.tag == 0 || twentyEightBottom.first?.subviews.first?.tag == 0) &&
                    sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtyFiveBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
    //MARK: - (- 18)
                    ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) &&
                    eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil || twentySevenBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtySixBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    eighteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                     
                    ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) &&
                    nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtySixBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    twentySevenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                      
                    ((twentySevenBottom.first?.subviews.first?.tag == 0 || twentySevenBottom.first?.subviews.first?.tag == 2) &&
                    nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                    thirtySixBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                                 
                    ((thirtySixBottom.first?.subviews.first?.tag == 0 || thirtySixBottom.first?.subviews.first?.tag == 2) &&
                    nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                    fortyFiveBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) {
                    self.arrayPossibleStepsQueenBlack.append(square.tag)
                    print("queenBlack: \(arrayPossibleStepsQueenBlack)")
                }
            }
        }
    }

    func canStepQueenWhite(gesture: UIPanGestureRecognizer) {
        arrayPossibleStepsQueenWhite.removeAll()
        for square in self.desk.subviews {
            if square.subviews.first?.tag == 2 {
                let sevenTop = desk.subviews.filter{($0.tag == square.tag + 7)}
                let nineTop = desk.subviews.filter{($0.tag == square.tag + 9)}
                let fourteenTop = desk.subviews.filter{($0.tag == square.tag + 14)}
                let eighteenTop = desk.subviews.filter{($0.tag == square.tag + 18)}
                let sevenBottom = desk.subviews.filter{($0.tag == square.tag - 7)}
                let nineBottom = desk.subviews.filter{($0.tag == square.tag - 9)}
                let fourteenBottom = desk.subviews.filter{($0.tag == square.tag - 14)}
                let eighteenBottom = desk.subviews.filter{($0.tag == square.tag - 18)}
                let twentyOneTop = desk.subviews.filter{($0.tag == square.tag + 21)}
                let twentyEightTop = desk.subviews.filter{($0.tag == square.tag + 28)}
                let thirtyFiveTop = desk.subviews.filter{($0.tag == square.tag + 35)}
                let twentySevenTop = desk.subviews.filter{($0.tag == square.tag + 27)}
                let thirtySixTop = desk.subviews.filter{($0.tag == square.tag + 36)}
                let fortyFiveTop = desk.subviews.filter{($0.tag == square.tag + 45)}
                let twentyOneBottom = desk.subviews.filter{($0.tag == square.tag - 21)}
                let twentyEightBottom = desk.subviews.filter{($0.tag == square.tag - 28)}
                let thirtyFiveBottom = desk.subviews.filter{($0.tag == square.tag - 35)}
                let twentySevenBottom = desk.subviews.filter{($0.tag == square.tag - 27)}
                let thirtySixBottom = desk.subviews.filter{($0.tag == square.tag - 36)}
                let fortyFiveBottom = desk.subviews.filter{($0.tag == square.tag - 45)}
                
            //MARK: - (+ 14)
            if ((sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3) &&
                fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil || twentyOneTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                (twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil || twentyEightTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                fourteenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                
                ((fourteenTop.first?.subviews.first?.tag == 1 || fourteenTop.first?.subviews.first?.tag == 3) &&
                sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil || twentyEightTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentyOneTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                 
                ((twentyOneTop.first?.subviews.first?.tag == 1 || twentyOneTop.first?.subviews.first?.tag == 3) &&
                sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentyEightTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                 
                ((twentyEightTop.first?.subviews.first?.tag == 1 || twentyEightTop.first?.subviews.first?.tag == 3) &&
                sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtyFiveTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
//MARK: - (+ 18)
                ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) &&
                eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil || twentySevenTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil || thirtySixTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                 (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                eighteenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                 
                ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) &&
                nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil || thirtySixTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentySevenTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                  
                ((twentySevenTop.first?.subviews.first?.tag == 1 || twentySevenTop.first?.subviews.first?.tag == 3) &&
                nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil &&
                (fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveTop.first(where: {$0.subviews.isEmpty}) == nil) &&
                thirtySixTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                   
                ((thirtySixTop.first?.subviews.first?.tag == 1 || thirtySixTop.first?.subviews.first?.tag == 3) &&
                nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                fortyFiveTop.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
//MARK: - (- 14)
                ((sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3) &&
                fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyOneBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyEightBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                fourteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                 
                ((fourteenBottom.first?.subviews.first?.tag == 1 || fourteenBottom.first?.subviews.first?.tag == 3) &&
                sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil || twentyEightBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentyOneBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                  
                ((twentyOneBottom.first?.subviews.first?.tag == 1 || twentyOneBottom.first?.subviews.first?.tag == 3) &&
                sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentyEightBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                  
                ((twentyEightBottom.first?.subviews.first?.tag == 1 || twentyEightBottom.first?.subviews.first?.tag == 3) &&
                sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtyFiveBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
//MARK: - (- 18)
                ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) &&
                eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil || twentySevenBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtySixBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                eighteenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                 
                ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) &&
                nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil || thirtySixBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                twentySevenBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                  
                ((twentySevenBottom.first?.subviews.first?.tag == 1 || twentySevenBottom.first?.subviews.first?.tag == 3) &&
                nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                (fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil || fortyFiveBottom.first(where: {$0.subviews.isEmpty}) == nil) &&
                thirtySixBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) ||
                             
                ((thirtySixBottom.first?.subviews.first?.tag == 1 || thirtySixBottom.first?.subviews.first?.tag == 3) &&
                nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                fortyFiveBottom.first?.backgroundColor == UIColor(named: "ColorBlack")) {
                self.arrayPossibleStepsQueenWhite.append(square.tag)
                print("queenWhite: \(arrayPossibleStepsQueenWhite)")
                }
            }
        }
    }
}

