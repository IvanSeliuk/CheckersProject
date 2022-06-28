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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupBackGround()
        namePlayer()
        setupDesk()
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
    
    private func fillDesk(view: UIView) {
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
                    arrayBlackSquare.append(square.tag)
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
    
    private func addChecker(image: ColorChecker) -> UIImageView {
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
    
    func createGestureRecognizer() -> [UIGestureRecognizer] {
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
    }
    
    private func turnOnTimer() {
        timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    //MARK: - Light
    @objc private func longPressGesture(_ sender: UITapGestureRecognizer) {
        guard let checker = sender.view, let squareOfChecker = checker.superview else { return }
        let filterSevenTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 7)}
        let filterNineTop = desk.subviews.filter{($0.tag == (squareOfChecker.tag) + 9)}
        let filterSevenBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 7)}
        let filterNineBottom = desk.subviews.filter{($0.tag == (squareOfChecker.tag) - 9)}
//        let filterFourteenTop = desk.subviews.filter({$0.tag == (squareOfChecker.tag) + 14})
//        let filterEighteenTop = desk.subviews.filter({$0.tag == (squareOfChecker.tag) + 18})
//
//        let filterFourteenBottom = desk.subviews.filter({$0.tag == (squareOfChecker.tag) - 14})
//        let filterEighteenBottom = desk.subviews.filter({$0.tag == (squareOfChecker.tag) - 18})
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
                          (filterNineBottom.first?.subviews.first?.tag == 1 || filterNineBottom.first?.subviews.first?.tag == 1)))
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
    
    // MARK: - have to beat
    private func canStepCheckerWhite(recognizer: UIPanGestureRecognizer) {
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
    private func canStepCheckerBlack(recognizer: UIPanGestureRecognizer) {
        arrayPossibleStepsBlack.removeAll()
        for square in desk.subviews {
            if !square.subviews.isEmpty, square.subviews.first?.tag == 1 || square.subviews.first?.tag == 3 {
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
    
    //MARK: - Finish game
    func finishGame() {
        if beatBlackCheckers == 12 {
            showFinishGameAlert()
        } else {
            if beatWhiteCheckers == 12 {
                showFinishGameAlert()
            }
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
        let alert = UIAlertController(title: "Finish game", message:  (winner ?? "He") + " is winner!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            guard let scoreVC = ScoreGameViewController.getInstanceController as? ScoreGameViewController else {return}
            scoreVC.modalPresentationStyle = .fullScreen
            scoreVC.modalTransitionStyle = .crossDissolve
            self.present(scoreVC, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Moves
    @objc private func dragTheChecker(recognizer: UIPanGestureRecognizer) {
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
                            canStepCheckerWhite(recognizer: recognizer)
                            canStepCheckerBlack(recognizer: recognizer)
                        }
                        
                    } else {
                        if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
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
                                canStepCheckerWhite(recognizer: recognizer)
                                canStepCheckerBlack(recognizer: recognizer)
                            }
                        } else {
                            if arrayPossibleStepsWhite.isEmpty,
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
                                    canStepCheckerWhite(recognizer: recognizer)
                                    canStepCheckerBlack(recognizer: recognizer)
                                }
                            }
                            else {
                                
                                //MARK: - MOVE WHITE BACK
                                if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
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
                                        canStepCheckerWhite(recognizer: recognizer)
                                        canStepCheckerBlack(recognizer: recognizer)
                                    }
                                } else {
                                    if (arrayPossibleStepsWhite.contains(squareOfChecker.tag) || arrayPossibleStepsWhite.isEmpty),
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
                                            canStepCheckerWhite(recognizer: recognizer)
                                            canStepCheckerBlack(recognizer: recognizer)
                                        }
                                    } else {
                                        if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
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
                                                canStepCheckerBlack(recognizer: recognizer)
                                                canStepCheckerWhite(recognizer: recognizer)
                                            }
                                        }
                                        else {
                                            if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty), checker.tag == 1, currentGamer == .blackPlaying,
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
                                                    canStepCheckerBlack(recognizer: recognizer)
                                                    canStepCheckerWhite(recognizer: recognizer)
                                                }
                                            } else {
                                                if  arrayPossibleStepsBlack.isEmpty,
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
                                                        canStepCheckerBlack(recognizer: recognizer)
                                                        canStepCheckerWhite(recognizer: recognizer)
                                                    }
                                                    
                                                } else {
                                                    //MARK: - MOVE BLACK BACK
                                                    if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
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
                                                            canStepCheckerBlack(recognizer: recognizer)
                                                            canStepCheckerWhite(recognizer: recognizer)
                                                        }
                                                    } else {
                                                        if (arrayPossibleStepsBlack.contains(squareOfChecker.tag) || arrayPossibleStepsBlack.isEmpty),
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
                                                                canStepCheckerBlack(recognizer: recognizer)
                                                                canStepCheckerWhite(recognizer: recognizer)
                                                                
                                                                
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
    
    private func removeDesk() {
        for view in desk.subviews {
            view.removeFromSuperview()
        }
    }
    
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
            //сохранить массивы arrayPossibleStep
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





