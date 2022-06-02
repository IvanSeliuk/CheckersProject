//
//  SecondViewController.swift
//  Homework 11
//
//  Created by Иван Селюк on 24.01.22.
//

import UIKit
import GoogleMobileAds

enum ColorChecker: String {
    case white, black
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
    private var interstitial: GADInterstitialAd?
    
    var desk: UIView!
    var chechersArray: [SaveCheckers] = []
    var imageBlackGround: UIImage?
    var timer: Timer!
    var timeGame: Int!
    var currentGamer: MovePlayer = .whitePlaying
    var saveCurrentMove: MovePlayer?
    let xLine: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    let yLine: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    var arrayBorder: [UIView] = []
    
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
        loadInterstitial()
        navigationController?.navigationBar.isHidden = true
        setupBackGround()
        namePlayer()
        setupDesk()
        if Setting.shared.isSave {
            loadSaveDesk()
        } else {
            turnOnTimer()
        }
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
        checker.tag = image == .white ? 0 : 1
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
    
    @objc private func longPressGesture(_ sender: UITapGestureRecognizer) {
        guard let checker = sender.view, let squareOfChecker = checker.superview else { return }
        
        switch sender.state {
        case .began:
            arrayBorder.removeAll()
            for square in desk.subviews {
                if checker.tag == 0 &&
                    (square.tag == (squareOfChecker.tag - 7) ||
                     square.tag == (squareOfChecker.tag - 9))
                    ||
                    checker.tag == 1 &&
                    (square.tag == (squareOfChecker.tag + 7) ||
                     square.tag == (squareOfChecker.tag + 9)) {
                    if square.subviews.isEmpty && square.backgroundColor == UIColor(named: "ColorBlack") {
                        arrayBorder.append(square)
                        arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBorder") } )
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
    
    @objc private func dragTheChecker(recognizer: UIPanGestureRecognizer) {
        guard let checker = recognizer.view, let squareOfChecker = checker.superview else { return }
        
        if recognizer.state == .began {
            desk.bringSubviewToFront(squareOfChecker)
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: desk)
            checker.center = CGPoint(x: checker.center.x + translation.x,
                                     y: checker.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: desk)
        } else if recognizer.state == .ended {
            for square in desk.subviews {
                if square.frame.contains(recognizer.location(in: desk)) {
                    if checker.tag == 0 &&
                        currentGamer == .whitePlaying &&
                        
                        (square.tag == (squareOfChecker.tag - 7) || square.tag == (squareOfChecker.tag - 9))
                        ||
                        checker.tag == 1 &&
                        currentGamer == .blackPlaying &&
                        (square.tag == (squareOfChecker.tag + 7) || square.tag == (squareOfChecker.tag + 9)) {
                        
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"){
                            
                            //                        }  &&
                            //                               (square.tag == (squareOfChecker.tag - 14) || square.tag == (squareOfChecker.tag - 18)) {
                            desk.bringSubviewToFront(square)
                            square.addSubview(checker)
                            checker.frame.origin = .zero
                            arrayBorder.forEach({ $0.backgroundColor = UIColor(named: "ColorBlack") } )
                            if currentGamer == .whitePlaying {
                                currentGamer = .blackPlaying
                                whoMustMoveLabel.text = "Black's move".localized
                            } else {
                                currentGamer = .whitePlaying
                                whoMustMoveLabel.text = "White's move".localized
                            }
                            saveCurrentMove = currentGamer
                        } else {
                            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                                checker.frame.origin = .zero
                            }
                        }
                    } else {
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                            checker.frame.origin = .zero
                        }
                    }
                    //                    } else {
                    //                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
                    //                            checker.frame.origin = .zero
                    //                    }
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
    }
    
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.present(fromRootViewController: self)
            interstitial?.fullScreenContentDelegate = self
        })
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
            Setting.shared.isSave = true
            self.chechersArray.removeAll()
            for view in self.desk.subviews {
                if !view.subviews.isEmpty {
                    if let color = view.subviews.first?.tag {
                        self.chechersArray.append(SaveCheckers(number: view.tag, checkerName: color == 0 ? .white : .black))
                        self.chechersArray.forEach {
                            print($0.number)
                            print($0.checkerName)
                        }
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
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetGame(_ sender: Any) {
        let alert = UIAlertController(title: "newGame".localized, message: "Do you really want to start a new game?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES".localized, style: .cancel, handler: { [self]_ in
            loadInterstitial()
            Setting.shared.isSave = false
            removeDesk()
            fillDesk(view: self.desk)
            timer.invalidate()
            self.seconds = 0
            turnOnTimer()
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

extension GamerViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        turnOnTimer()
        print("Ad did fail to present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        turnOnTimer()
        print("Ad did dismiss full screen content.")
    }
}



