//
//  SecondViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 24.01.22.
//

import UIKit


enum ColorChecker: String {
    case white, black, whiteKing, blackKing
}

enum MovePlayer: Int {
    case whitePlaying
    case blackPlaying
}

class GamerViewController: UIViewController {
    
    @IBOutlet weak var namePlayerLabel: UILabel!
    @IBOutlet weak var backgroundSecondVC: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var whoMustMoveLabel: UILabel!
    
    var desk: UIView!
    var chechersArray: [SaveCheckers] = []
    var imageBlackGround: UIImage?
    var timer: Timer!
    var timeGame: Int!
    var beatWhiteCheckers: Int = 0
    var beatBlackCheckers: Int = 0
    var currentGamer: MovePlayer = .whitePlaying
    var saveCurrentMove: MovePlayer?
    let xLine: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    let yLine: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    var arrayBlackSquare = [Int]()
    var arrayBorder: [UIView] = []
    var arrayPossibleStepsWhite = [Int]()
    var arrayPossibleStepsBlack = [Int]()
    var arrayPossibleStepsQueenWhite = [Int]()
    var arrayPossibleStepsQueenBlack = [Int]()
    var checkersDB: [Checkers] = []
    var checherTag: ColorChecker = .white
    
    var seconds: Int = 0 {
        didSet {
            let min = Int(Double(self.seconds) / 60.0)
            let sec = Int(Double(self.seconds) - (Double(min) * 60.0))
            let min_string = min < 10 ? "0\(min)" : "\(min)"
            let sec_srting = sec < 10 ? "0\(sec)" : "\(sec)"
            timerLabel.text = "\(min_string):\(sec_srting)"
        }
    }
    
    //MARK: - Life cicle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard desk != nil else { return }
        desk.center = view.center
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    
    //MARK: - SQUARE LIGHT
    @objc func longPressGesture(_ sender: UITapGestureRecognizer) {
        guard let checker = sender.view, let squareOfChecker = checker.superview else { return }
        let filterSevenTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 7)}
        let filterNineTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 9)}
        let filterSevenBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 7)}
        let filterNineBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 9)}
        
        switch sender.state {
        case .began:
            arrayBorder.removeAll()
            for square in desk.subviews {
                if checker.tag == 0 && currentGamer == .whitePlaying &&
                    ((square.tag == (squareOfChecker.tag - 7) && filterSevenBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                     (square.tag == (squareOfChecker.tag - 9) && filterNineBottom.first(where: {$0.subviews.isEmpty}) != nil))
                    
                    
                    ||
                    checker.tag == 1 && currentGamer == .blackPlaying &&
                    (square.tag == (squareOfChecker.tag + 7) ||
                     square.tag == (squareOfChecker.tag + 9)) {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                        
                        arrayBorder.append(square)
                        arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBorder") } )
                    }
                }
                else {
                    if checker.tag == 0 && currentGamer == .whitePlaying &&
                        ((square.tag == (squareOfChecker.tag + 14) &&
                          (filterSevenTop.first?.subviews.first?.tag == 1 || filterSevenTop.first?.subviews.first?.tag == 3)) ||
                         (square.tag == (squareOfChecker.tag + 18) &&
                          (filterNineTop.first?.subviews.first?.tag == 1 || filterNineTop.first?.subviews.first?.tag == 3)) ||
                         (square.tag == (squareOfChecker.tag - 14) &&
                          (filterSevenBottom.first?.subviews.first?.tag == 1 || filterSevenBottom.first?.subviews.first?.tag == 3)) ||
                         (square.tag == (squareOfChecker.tag - 18) &&
                          (filterNineBottom.first?.subviews.first?.tag == 1 || filterNineBottom.first?.subviews.first?.tag == 3)))
                        ||
                        checker.tag == 1 && currentGamer == .blackPlaying &&
                        ((square.tag == (squareOfChecker.tag + 14) &&
                          (filterSevenTop.first?.subviews.first?.tag == 0 || filterSevenTop.first?.subviews.first?.tag == 2)) ||
                         (square.tag == (squareOfChecker.tag + 18) &&
                          (filterNineTop.first?.subviews.first?.tag == 0 || filterNineTop.first?.subviews.first?.tag == 2)) ||
                         (square.tag == (squareOfChecker.tag - 14) &&
                          (filterSevenBottom.first?.subviews.first?.tag == 0 || filterSevenBottom.first?.subviews.first?.tag == 2)) ||
                         (square.tag == (squareOfChecker.tag - 18) &&
                          (filterNineBottom.first?.subviews.first?.tag == 0 || filterNineBottom.first?.subviews.first?.tag == 2))) {
                        if square.subviews.isEmpty && square.backgroundColor == UIColor(named: "ColorBlack") {
                            arrayBorder.append(square)
                            arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBorder") } )
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                checker.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            }
            desk.bringSubviewToFront(squareOfChecker)
            if checker.tag == 0 && currentGamer == .blackPlaying ||
                checker.tag == 1 && currentGamer == .whitePlaying {
                whoMustMoveLabel.text = "It's not your move".localized
            }
            
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                checker.transform = .identity
            }
            if currentGamer == .blackPlaying {
                whoMustMoveLabel.text = "Black's move".localized
            } else {
                whoMustMoveLabel.text = "White's move".localized
            }
            arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
        default: break
        }
    }
    
    
    
    //MARK: - CHECKERS MOVE
    @objc func dragTheChecker(recognizer: UIPanGestureRecognizer) {
        guard let checker = recognizer.view, let squareOfChecker = checker.superview else { return }
        
        let filterSevenTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 7)}
        let filterNineTop = desk.subviews.filter{($0.tag == squareOfChecker.tag + 9)}
        let filterSevenBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 7)}
        let filterNineBottom = desk.subviews.filter{($0.tag == squareOfChecker.tag - 9)}
        
        if recognizer.state == .began {
            desk.bringSubviewToFront(squareOfChecker)
        }
        else if recognizer.state == .changed {
            let translation = recognizer.translation(in: desk)
            checker.center = CGPoint(x: checker.center.x + translation.x,
                                     y: checker.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: desk)
            //print(checker.center)
        }
        else if recognizer.state == .ended {
            
            // MARK: - MOVE WHITE FORWARD
            queenStepsGray(recognizer: recognizer)
            for square in desk.subviews {
                if square.frame.contains(recognizer.location(in: desk)) {
                    if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
                       (arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag) || arrayPossibleStepsQueenWhite.isEmpty),
                       checker.tag == 0, currentGamer == .whitePlaying, square.tag == (squareOfChecker.tag - 14) {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                           (filterSevenBottom.first(where: {$0.subviews.isEmpty}) == nil),
                           (filterSevenBottom.first?.subviews.first?.tag == 1 || filterSevenBottom.first?.subviews.first?.tag == 3) {
                            print("белая побила вправо")
                            filterSevenBottom.first?.subviews.first?.removeFromSuperview()
                            desk.bringSubviewToFront(square)
                            beatBlackCheckers += 1
                            finishGame()
                            if square.tag < 8, checker.tag == 0 {
                                checker.removeFromSuperview()
                                let checker = addChecker(image: .whiteKing)
                                square.addSubview(checker)
                                checker.frame = CGRect(x: .zero,
                                                       y: .zero,
                                                       width: square.frame.width,
                                                       height: square.frame.height)
                            } else {
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                            }
                            checkBeatCheckerWhite(recognizer: recognizer)
                            checkingStepsAllCheckers(recognizer: recognizer)
                        }
                        
                    } else {
                        if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
                           (arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag) || arrayPossibleStepsQueenWhite.isEmpty),
                           checker.tag == 0, currentGamer == .whitePlaying, square.tag == (squareOfChecker.tag - 18) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                               (filterNineBottom.first(where: {$0.subviews.isEmpty}) == nil),
                               (filterNineBottom.first?.subviews.first?.tag == 1 || filterNineBottom.first?.subviews.first?.tag == 3) {
                                print("белая побила влево")
                                filterNineBottom.first?.subviews.first?.removeFromSuperview()
                                desk.bringSubviewToFront(square)
                                beatBlackCheckers += 1
                                finishGame()
                                if square.tag < 8, checker.tag == 0 {
                                    checker.removeFromSuperview()
                                    let checker = addChecker(image: .whiteKing)
                                    square.addSubview(checker)
                                    checker.frame = CGRect(x: .zero,
                                                           y: .zero,
                                                           width: square.frame.width,
                                                           height: square.frame.height)
                                } else {
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                }
                                checkBeatCheckerWhite(recognizer: recognizer)
                                checkingStepsAllCheckers(recognizer: recognizer)
                            }
                        } else {
                            if arrayPossibleStepsWhite.isEmpty, arrayPossibleStepsQueenWhite.isEmpty,
                               checker.tag == 0, currentGamer == .whitePlaying,
                               (square.tag == (squareOfChecker.tag - 7) || square.tag == (squareOfChecker.tag - 9)) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                                    print("белая походила")
                                    desk.bringSubviewToFront(square)
                                    if square.tag < 8 {
                                        checker.removeFromSuperview()
                                        let checker = addChecker(image: .whiteKing)
                                        square.addSubview(checker)
                                        checker.frame = CGRect(x: .zero,
                                                               y: .zero,
                                                               width: square.frame.width,
                                                               height: square.frame.height)
                                    } else {
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                    }
                                    arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                    checkingStepsAllCheckers(recognizer: recognizer)
                                }
                                
//MARK: - MOVE WHITE BACK
                            } else {
                                if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
                                   (arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag) || arrayPossibleStepsQueenWhite.isEmpty),
                                   checker.tag == 0, currentGamer == .whitePlaying,
                                   (square.tag == (squareOfChecker.tag + 14)) {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                       (filterSevenTop.first(where: {$0.subviews.isEmpty}) == nil),
                                       (filterSevenTop.first?.subviews.first?.tag == 1 || filterSevenTop.first?.subviews.first?.tag == 3) {
                                        print("белая побила назад влево")
                                        filterSevenTop.first?.subviews.first?.removeFromSuperview()
                                        desk.bringSubviewToFront(square)
                                        beatBlackCheckers += 1
                                        finishGame()
                                        if square.tag < 8, checker.tag == 0 {
                                            checker.removeFromSuperview()
                                            let checker = addChecker(image: .whiteKing)
                                            square.addSubview(checker)
                                            checker.frame = CGRect(x: .zero,
                                                                   y: .zero,
                                                                   width: square.frame.width,
                                                                   height: square.frame.height)
                                        } else {
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                        }
                                        checkBeatCheckerWhite(recognizer: recognizer)
                                        checkingStepsAllCheckers(recognizer: recognizer)
                                    }
                                } else {
                                    if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
                                       (arrayPossibleStepsQueenWhite.contains(squareOfChecker.tag) || arrayPossibleStepsQueenWhite.isEmpty),
                                       checker.tag == 0, currentGamer == .whitePlaying,
                                       (square.tag == (squareOfChecker.tag + 18)) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                           (filterNineTop.first(where: {$0.subviews.isEmpty}) == nil),
                                           (filterNineTop.first?.subviews.first?.tag == 1 || filterNineTop.first?.subviews.first?.tag == 3) {
                                            print("белая побила назад вправо")
                                            filterNineTop.first?.subviews.first?.removeFromSuperview()
                                            desk.bringSubviewToFront(square)
                                            beatBlackCheckers += 1
                                            finishGame()
                                            if square.tag < 8, checker.tag == 0 {
                                                checker.removeFromSuperview()
                                                let checker = addChecker(image: .whiteKing)
                                                square.addSubview(checker)
                                                checker.frame = CGRect(x: .zero,
                                                                       y: .zero,
                                                                       width: square.frame.width,
                                                                       height: square.frame.height)
                                            } else {
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                            }
                                            checkBeatCheckerWhite(recognizer: recognizer)
                                            checkingStepsAllCheckers(recognizer: recognizer)
                                        }
                                    } else {
                                        if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
                                           (arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.isEmpty),
                                           checker.tag == 1, currentGamer == .blackPlaying,
                                           (square.tag == (squareOfChecker.tag + 14)) {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                               (filterSevenTop.first(where: { $0.subviews.isEmpty}) == nil),
                                               (filterSevenTop.first?.subviews.first?.tag == 0 || filterSevenTop.first?.subviews.first?.tag == 2) {
                                                print("черная побила влево")
                                                filterSevenTop.first?.subviews.first?.removeFromSuperview()
                                                desk.bringSubviewToFront(square)
                                                beatWhiteCheckers += 1
                                                finishGame()
                                                if square.tag > 55, checker.tag == 1 {
                                                    checker.removeFromSuperview()
                                                    let checker = addChecker(image: .blackKing)
                                                    square.addSubview(checker)
                                                    checker.frame = CGRect(x: .zero,
                                                                           y: .zero,
                                                                           width: square.frame.width,
                                                                           height: square.frame.height)
                                                } else {
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                }
                                                checkBeatCheckerBlack(recognizer: recognizer)
                                                checkingStepsAllCheckers(recognizer: recognizer)
                                            }
                                        }
                                        else {
                                            if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
                                               (arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.isEmpty),
                                               checker.tag == 1, currentGamer == .blackPlaying,
                                               (square.tag == (squareOfChecker.tag + 18)) {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                   (filterNineTop.first(where: { $0.subviews.isEmpty}) == nil),
                                                   (filterNineTop.first?.subviews.first?.tag == 0 || filterNineTop.first?.subviews.first?.tag == 2)  {
                                                    print("черная побила вправо")
                                                    filterNineTop.first?.subviews.first?.removeFromSuperview()
                                                    desk.bringSubviewToFront(square)
                                                    beatWhiteCheckers += 1
                                                    finishGame()
                                                    if square.tag > 55, checker.tag == 1 {
                                                        checker.removeFromSuperview()
                                                        let checker = addChecker(image: .blackKing)
                                                        square.addSubview(checker)
                                                        checker.frame = CGRect(x: .zero,
                                                                               y: .zero,
                                                                               width: square.frame.width,
                                                                               height: square.frame.height)
                                                    } else {
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                    }
                                                    checkBeatCheckerBlack(recognizer: recognizer)
                                                    checkingStepsAllCheckers(recognizer: recognizer)
                                                }
                                            } else {
                                                if  arrayPossibleStepsBlack.isEmpty, arrayPossibleStepsQueenBlack.isEmpty,
                                                    checker.tag == 1, currentGamer == .blackPlaying,
                                                    (square.tag == (squareOfChecker.tag + 7) || square.tag == (squareOfChecker.tag + 9)) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                                                        print("черная походила")
                                                        desk.bringSubviewToFront(square)
                                                        if square.tag > 55 {
                                                            checker.removeFromSuperview()
                                                            let checker = addChecker(image: .blackKing)
                                                            square.addSubview(checker)
                                                            checker.frame = CGRect(x: .zero,
                                                                                   y: .zero,
                                                                                   width: square.frame.width,
                                                                                   height: square.frame.height)
                                                        } else {
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                        }
                                                        arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                        checkingStepsAllCheckers(recognizer: recognizer)
                                                    }
                                                    
                                                } else {
//MARK: - MOVE BLACK BACK
                                                    if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
                                                       (arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.isEmpty),
                                                       checker.tag == 1, currentGamer == .blackPlaying,
                                                       (square.tag == (squareOfChecker.tag - 14)) {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                           (filterSevenBottom.first(where: {$0.subviews.isEmpty}) == nil),
                                                           (filterSevenBottom.first?.subviews.first?.tag == 0 || filterSevenBottom.first?.subviews.first?.tag == 2) {
                                                            print("черная побила назад влево")
                                                            filterSevenBottom.first?.subviews.first?.removeFromSuperview()
                                                            desk.bringSubviewToFront(square)
                                                            beatWhiteCheckers += 1
                                                            finishGame()
                                                            if square.tag > 55, checker.tag == 1 {
                                                                checker.removeFromSuperview()
                                                                let checker = addChecker(image: .blackKing)
                                                                square.addSubview(checker)
                                                                checker.frame = CGRect(x: .zero,
                                                                                       y: .zero,
                                                                                       width: square.frame.width,
                                                                                       height: square.frame.height)
                                                            } else {
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                            }
                                                            checkBeatCheckerBlack(recognizer: recognizer)
                                                            checkingStepsAllCheckers(recognizer: recognizer)
                                                        }
                                                    } else {
                                                        if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
                                                           (arrayPossibleStepsQueenBlack.contains(squareOfChecker.tag) || arrayPossibleStepsQueenBlack.isEmpty),
                                                           checker.tag == 1, currentGamer == .blackPlaying,
                                                           (square.tag == (squareOfChecker.tag - 18)) {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                               (filterNineBottom.first(where: {$0.subviews.isEmpty}) == nil),
                                                               (filterNineBottom.first?.subviews.first?.tag == 0 || filterNineBottom.first?.subviews.first?.tag == 2) {
                                                                print("черная побила назад вправо")
                                                                filterNineBottom.first?.subviews.first?.removeFromSuperview()
                                                                desk.bringSubviewToFront(square)
                                                                beatWhiteCheckers += 1
                                                                finishGame()
                                                                if square.tag > 55, checker.tag == 1 {
                                                                    checker.removeFromSuperview()
                                                                    let checker = addChecker(image: .blackKing)
                                                                    square.addSubview(checker)
                                                                    checker.frame = CGRect(x: .zero,
                                                                                           y: .zero,
                                                                                           width: square.frame.width,
                                                                                           height: square.frame.height)
                                                                } else {
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                }
                                                                checkBeatCheckerBlack(recognizer: recognizer)
                                                                checkingStepsAllCheckers(recognizer: recognizer)
                                                                
                                                                
                                                            }   }
                                                    }  }
                                            }  }
                                    }  }
                            }  }
                    }  }
                
                else {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                        checker.frame.origin = .zero
                    }
                }
            }
        }
    }
    
    //MARK: - ACTION
    private func loadSaveDesk() {
        for view in desk.subviews {
            view.subviews.forEach({ $0.removeFromSuperview() })
        }
        if let data = UserDefaults.standard.object(forKey: "chechersArray") as? Data {
            print(data)
            if let checkers = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SaveCheckers] {
                checkers.forEach {
                    print($0.number)
                    print($0.checkerName)
                }
                self.chechersArray = checkers
            }
        }
        
        for view in self.desk.subviews {
            if let checker = self.chechersArray.first(where: { $0.number == view.tag }) {
                if view.subviews.isEmpty {
                    let subview = self.addChecker(image: checker.checkerName)
                    view.addSubview(subview)
                    subview.frame = CGRect(origin: .zero, size: view.bounds.size)
                }
            }
        }
        seconds = Setting.shared.timer ?? 0
        turnOnTimer()
        currentGamer = Setting.shared.currentGamer
        whoMustMoveLabel.text = currentGamer == .whitePlaying ? "White's move".localized : "Black's move".localized
        beatBlackCheckers = Setting.shared.beatBlackCheckers ?? 0
        beatWhiteCheckers = Setting.shared.beatWhiteCheckers ?? 0
    }
    
    @IBAction func exitApplication(_ sender: Any) {
        let alert = UIAlertController(title: "Attention".localized, message: "Do you really want to go to the menu?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES".localized, style: .cancel, handler: {_ in
            guard let secondVC = MenuViewController.getInstanceController as? MenuViewController else {return}
            secondVC.modalPresentationStyle = .fullScreen
            secondVC.modalTransitionStyle = .crossDissolve
            self.present(secondVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveData(_ sender: Any) {
        let alert = UIAlertController(title: "Save Game".localized, message: "Do you want to save the game?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES".localized, style: .cancel, handler: { [self]_ in
            self.chechersArray.removeAll()
            for view in self.desk.subviews {
                if !view.subviews.isEmpty {
                    if let color = view.subviews.first?.tag {
                        switch color {
                        case 0: checherTag = .white
                        case 1: checherTag = .black
                        case 2: checherTag = .whiteKing
                        case 3: checherTag = .blackKing
                        default: break
                        }
                        self.chechersArray.append(SaveCheckers(number: view.tag, checkerName: checherTag))
                    }
                }
            }
            
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: self.chechersArray, requiringSecureCoding: true) {
                print(data)
                UserDefaults.standard.set(data, forKey: "chechersArray")
            }
            self.timeGame = seconds
            Setting.shared.timer = self.timeGame
            Setting.shared.currentGamer = saveCurrentMove ?? .whitePlaying
            Setting.shared.beatBlackCheckers = beatBlackCheckers
            Setting.shared.beatWhiteCheckers = beatWhiteCheckers
            print("black:\(beatBlackCheckers) and white:\(beatWhiteCheckers)")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetGame(_ sender: Any) {
        let alert = UIAlertController(title: "newGame".localized, message: "Do you really want to start a new game?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES".localized, style: .cancel, handler: { [self]_ in
            removeDesk()
            fillDesk(view: self.desk)
            timer.invalidate()
            self.seconds = 0
            turnOnTimer()
            currentGamer = .whitePlaying
            whoMustMoveLabel.text = "White makes the first move".localized
            beatBlackCheckers = 0
            beatWhiteCheckers = 0
            arrayPossibleStepsWhite.removeAll()
            arrayPossibleStepsBlack.removeAll()
            arrayPossibleStepsQueenBlack.removeAll()
            arrayPossibleStepsQueenWhite.removeAll()
        }))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: Совместная работа двух Recognizer на одной View
extension GamerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}





