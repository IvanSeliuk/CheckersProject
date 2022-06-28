//
//  GamerViewControllerWithQueen.swift
//  Homework 11
//
//  Created by Иван Селюк on 27.06.22.
//

import UIKit

extension GamerViewController {
    
    func nextMove(nextMove: MovePlayer, text: String) {
        currentGamer = nextMove
        whoMustMoveLabel.text = text.localized
        saveCurrentMove = currentGamer
    }
    
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
        
        //MARK: - Step black king
        for square in desk.subviews {
            if square.frame.contains(recognizer.location(in: desk)) {
                if checker.tag == 3, currentGamer == .blackPlaying {
                    if (square.tag == (squareOfChecker.tag - 7) ||
                        square.tag == (squareOfChecker.tag - 9) ||
                        square.tag == (squareOfChecker.tag + 7) ||
                        square.tag == (squareOfChecker.tag + 9))  {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                            desk.bringSubviewToFront(square)
                            square.addSubview(checker)
                            checker.frame.origin = .zero
                            nextMove(nextMove: .whitePlaying, text: "White's move")
                        }
                        
                    } else {
                        if square.tag == (squareOfChecker.tag + 14) {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first?.subviews.first?.tag == 0 || sevenTop.first?.subviews.first?.tag == 2 {
                                sevenTop.first?.subviews.first?.removeFromSuperview()
                                desk.bringSubviewToFront(square)
                                beatWhiteCheckers += 1
                                finishGame()
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                                checkBeatCheckerBlack(recognizer: recognizer)
                            } else {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                    desk.bringSubviewToFront(square)
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                }
                            }
                        } else {
                            if square.tag == (squareOfChecker.tag + 18) {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2 {
                                    nineTop.first?.subviews.first?.removeFromSuperview()
                                    desk.bringSubviewToFront(square)
                                    beatWhiteCheckers += 1
                                    finishGame()
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    checkBeatCheckerBlack(recognizer: recognizer)
                                } else {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil {
                                        desk.bringSubviewToFront(square)
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                    }
                                }
                            } else {
                                if square.tag == (squareOfChecker.tag + 21) {
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
                                    } else {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                            desk.bringSubviewToFront(square)
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                        }
                                    }
                                } else {
                                    if square.tag == (squareOfChecker.tag + 27) {
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
                                        } else {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                desk.bringSubviewToFront(square)
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                            }
                                        }
                                    } else {
                                        if square.tag == (squareOfChecker.tag + 36) {
                                            if view.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
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
                                            } else {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                    desk.bringSubviewToFront(square)
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                }
                                            }
                                        } else {
                                            if square.tag == (squareOfChecker.tag + 36) {
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
                                                } else {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                        desk.bringSubviewToFront(square)
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                    }
                                                }
                                            } else {
                                                if square.tag == (squareOfChecker.tag + 54) {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                       ((nineTop.first?.subviews.first?.tag == 0 || nineTop.first?.subviews.first?.tag == 2) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((eighteenTop.first?.subviews.first?.tag == 0 || eighteenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((twentySevenTop.first?.subviews.first?.tag == 0 || twentySevenTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                        ((thirtySixTop.first?.subviews.first?.tag == 0 || thirtySixTop.first?.subviews.first?.tag == 2) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
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
                                                    } else {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                           nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                            desk.bringSubviewToFront(square)
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                        }
                                                    }
                                                } else {
                                                    if square.tag == (squareOfChecker.tag + 28) {
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
                                                        } else {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                               sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                desk.bringSubviewToFront(square)
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                            }
                                                        }
                                                    } else {
                                                        if square.tag == (squareOfChecker.tag + 35) {
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
                                                            } else {
                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                    desk.bringSubviewToFront(square)
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                }
                                                            }
                                                        } else {
                                                            if square.tag == (squareOfChecker.tag + 42) {
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
                                                                } else {
                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                       sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                        fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                        twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                        twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                        thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                        desk.bringSubviewToFront(square)
                                                                        square.addSubview(checker)
                                                                        checker.frame.origin = .zero
                                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                    }
                                                                }
                                                            } else {
                                                                if square.tag == (squareOfChecker.tag + 49) {
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
                                                                    } else {
                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                           sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                            fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                            twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                            twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                            thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                            fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                            desk.bringSubviewToFront(square)
                                                                            square.addSubview(checker)
                                                                            checker.frame.origin = .zero
                                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                        }
                                                                    }
                                                                    //MARK: - Step black king back
                                                                } else {
                                                                    if square.tag == (squareOfChecker.tag - 14) {
                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first?.subviews.first?.tag == 0 || sevenBottom.first?.subviews.first?.tag == 2 {
                                                                            sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                                            desk.bringSubviewToFront(square)
                                                                            beatWhiteCheckers += 1
                                                                            finishGame()
                                                                            square.addSubview(checker)
                                                                            checker.frame.origin = .zero
                                                                            checkBeatCheckerBlack(recognizer: recognizer)
                                                                        } else {
                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                desk.bringSubviewToFront(square)
                                                                                square.addSubview(checker)
                                                                                checker.frame.origin = .zero
                                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                            }
                                                                        }
                                                                    } else {
                                                                        if square.tag == (squareOfChecker.tag - 18) {
                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2 {
                                                                                nineBottom.first?.subviews.first?.removeFromSuperview()
                                                                                desk.bringSubviewToFront(square)
                                                                                beatWhiteCheckers += 1
                                                                                finishGame()
                                                                                square.addSubview(checker)
                                                                                checker.frame.origin = .zero
                                                                                checkBeatCheckerBlack(recognizer: recognizer)
                                                                            } else {
                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                    desk.bringSubviewToFront(square)
                                                                                    square.addSubview(checker)
                                                                                    checker.frame.origin = .zero
                                                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                }
                                                                            }
                                                                        } else {
                                                                            if square.tag == (squareOfChecker.tag - 21) {
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
                                                                                } else {
                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                        desk.bringSubviewToFront(square)
                                                                                        square.addSubview(checker)
                                                                                        checker.frame.origin = .zero
                                                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                if square.tag == (squareOfChecker.tag - 27) {
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
                                                                                    } else {
                                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                            desk.bringSubviewToFront(square)
                                                                                            square.addSubview(checker)
                                                                                            checker.frame.origin = .zero
                                                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                        }
                                                                                    }
                                                                                } else {
                                                                                    if square.tag == (squareOfChecker.tag - 36) {
                                                                                        if view.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
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
                                                                                        } else {
                                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                               nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                desk.bringSubviewToFront(square)
                                                                                                square.addSubview(checker)
                                                                                                checker.frame.origin = .zero
                                                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                            }
                                                                                        }
                                                                                    } else {
                                                                                        if square.tag == (squareOfChecker.tag - 36) {
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
                                                                                            } else {
                                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                   nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                    desk.bringSubviewToFront(square)
                                                                                                    square.addSubview(checker)
                                                                                                    checker.frame.origin = .zero
                                                                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                                }
                                                                                            }
                                                                                        } else {
                                                                                            if square.tag == (squareOfChecker.tag - 54) {
                                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                   ((nineBottom.first?.subviews.first?.tag == 0 || nineBottom.first?.subviews.first?.tag == 2) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                                    ((eighteenBottom.first?.subviews.first?.tag == 0 || eighteenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                                    ((twentySevenBottom.first?.subviews.first?.tag == 0 || twentySevenBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                                    ((thirtySixBottom.first?.subviews.first?.tag == 0 || thirtySixBottom.first?.subviews.first?.tag == 2) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
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
                                                                                                } else {
                                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                        desk.bringSubviewToFront(square)
                                                                                                        square.addSubview(checker)
                                                                                                        checker.frame.origin = .zero
                                                                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                                    }
                                                                                                }
                                                                                            } else {
                                                                                                if square.tag == (squareOfChecker.tag - 28) {
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
                                                                                                    } else {
                                                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                           sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                            desk.bringSubviewToFront(square)
                                                                                                            square.addSubview(checker)
                                                                                                            checker.frame.origin = .zero
                                                                                                            nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                                        }
                                                                                                    }
                                                                                                } else {
                                                                                                    if square.tag == (squareOfChecker.tag - 35) {
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
                                                                                                        } else {
                                                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                               sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                                desk.bringSubviewToFront(square)
                                                                                                                square.addSubview(checker)
                                                                                                                checker.frame.origin = .zero
                                                                                                                nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                                            }
                                                                                                        }
                                                                                                    } else {
                                                                                                        if square.tag == (squareOfChecker.tag - 42) {
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
                                                                                                            } else {
                                                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                                   sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                    fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                    twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                    twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                    thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                                    desk.bringSubviewToFront(square)
                                                                                                                    square.addSubview(checker)
                                                                                                                    checker.frame.origin = .zero
                                                                                                                    nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                                                }
                                                                                                            }
                                                                                                        } else {
                                                                                                            if square.tag == (squareOfChecker.tag - 49) {
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
                                                                                                                } else {
                                                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                                       sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                        fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                        twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                        twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                        thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                                        fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                                        desk.bringSubviewToFront(square)
                                                                                                                        square.addSubview(checker)
                                                                                                                        checker.frame.origin = .zero
                                                                                                                        nextMove(nextMove: .whitePlaying, text: "White's move")
                                                                                            }}}}}}}}}}}}}}}}}}}}}}}}}
                           
// MARK: - Step White King
} else {
    if checker.tag == 2, currentGamer == .whitePlaying {
        if (square.tag == (squareOfChecker.tag + 7) ||
            square.tag == (squareOfChecker.tag + 9) ||
            square.tag == (squareOfChecker.tag - 7) ||
            square.tag == (squareOfChecker.tag - 9))  {
            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack") {
                desk.bringSubviewToFront(square)
                square.addSubview(checker)
                checker.frame.origin = .zero
                nextMove(nextMove: .blackPlaying, text: "Black's move")
            }
        } else {
            if square.tag == (squareOfChecker.tag + 14) {
                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first?.subviews.first?.tag == 1 || sevenTop.first?.subviews.first?.tag == 3 {
                    sevenTop.first?.subviews.first?.removeFromSuperview()
                    desk.bringSubviewToFront(square)
                    beatBlackCheckers += 1
                    finishGame()
                    square.addSubview(checker)
                    checker.frame.origin = .zero
                    checkBeatCheckerWhite(recognizer: recognizer)
                } else {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                        desk.bringSubviewToFront(square)
                        square.addSubview(checker)
                        checker.frame.origin = .zero
                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                    }
                }
            } else {
                if square.tag == (squareOfChecker.tag + 18) {
                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3 {
                        nineTop.first?.subviews.first?.removeFromSuperview()
                        desk.bringSubviewToFront(square)
                        beatBlackCheckers += 1
                        finishGame()
                        square.addSubview(checker)
                        checker.frame.origin = .zero
                        checkBeatCheckerWhite(recognizer: recognizer)
                    } else {
                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil {
                            desk.bringSubviewToFront(square)
                            square.addSubview(checker)
                            checker.frame.origin = .zero
                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                        }
                    }
                } else {
                    if square.tag == (squareOfChecker.tag + 21) {
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
                        } else {
                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                desk.bringSubviewToFront(square)
                                square.addSubview(checker)
                                checker.frame.origin = .zero
                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                            }
                        }
                    } else {
                        if square.tag == (squareOfChecker.tag + 27) {
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
                            } else {
                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                    nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                    eighteenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                    desk.bringSubviewToFront(square)
                                    square.addSubview(checker)
                                    checker.frame.origin = .zero
                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                }
                            }
                        } else {
                            if square.tag == (squareOfChecker.tag + 36) {
                                if view.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
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
                                } else {
                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil {
                                        desk.bringSubviewToFront(square)
                                        square.addSubview(checker)
                                        checker.frame.origin = .zero
                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                    }
                                }
                            } else {
                                if square.tag == (squareOfChecker.tag + 36) {
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
                                    } else {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil {
                                            desk.bringSubviewToFront(square)
                                            square.addSubview(checker)
                                            checker.frame.origin = .zero
                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                        }
                                    }
                                } else {
                                    if square.tag == (squareOfChecker.tag + 54) {
                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                           ((nineTop.first?.subviews.first?.tag == 1 || nineTop.first?.subviews.first?.tag == 3) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((eighteenTop.first?.subviews.first?.tag == 1 || eighteenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((twentySevenTop.first?.subviews.first?.tag == 1 || twentySevenTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                            ((thirtySixTop.first?.subviews.first?.tag == 1 || thirtySixTop.first?.subviews.first?.tag == 3) && nineTop.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil && thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil) ||
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
                                        } else {
                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                               nineTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                eighteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                twentySevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                thirtySixTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                fortyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                desk.bringSubviewToFront(square)
                                                square.addSubview(checker)
                                                checker.frame.origin = .zero
                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                            }
                                        }
                                    } else {
                                        if square.tag == (squareOfChecker.tag + 28) {
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
                                            } else {
                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                   sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                    fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                    twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                    desk.bringSubviewToFront(square)
                                                    square.addSubview(checker)
                                                    checker.frame.origin = .zero
                                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                }
                                            }
                                        } else {
                                            if square.tag == (squareOfChecker.tag + 35) {
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
                                                } else {
                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenTop.first(where: {$0.subviews.isEmpty}) != nil && fourteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil && twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                        desk.bringSubviewToFront(square)
                                                        square.addSubview(checker)
                                                        checker.frame.origin = .zero
                                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                    }
                                                }
                                            } else {
                                                if square.tag == (squareOfChecker.tag + 42) {
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
                                                    } else {
                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                           sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                            thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                            desk.bringSubviewToFront(square)
                                                            square.addSubview(checker)
                                                            checker.frame.origin = .zero
                                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                        }
                                                    }
                                                } else {
                                                    if square.tag == (squareOfChecker.tag + 49) {
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
                                                        } else {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                               sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                fourteenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                twentyOneTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                twentyEightTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                thirtyFiveTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                fortyTwoTop.first(where: {$0.subviews.isEmpty}) != nil {
                                                                desk.bringSubviewToFront(square)
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                            }
                                                        }
                                                        //MARK: - Step white king back
                                                    } else {
                                                        if square.tag == (squareOfChecker.tag - 14) {
                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first?.subviews.first?.tag == 1 || sevenBottom.first?.subviews.first?.tag == 3 {
                                                                sevenBottom.first?.subviews.first?.removeFromSuperview()
                                                                desk.bringSubviewToFront(square)
                                                                beatBlackCheckers += 1
                                                                finishGame()
                                                                square.addSubview(checker)
                                                                checker.frame.origin = .zero
                                                                checkBeatCheckerWhite(recognizer: recognizer)
                                                            } else {
                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                    desk.bringSubviewToFront(square)
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                }
                                                            }
                                                        } else {
                                                            if square.tag == (squareOfChecker.tag - 18) {
                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3 {
                                                                    nineBottom.first?.subviews.first?.removeFromSuperview()
                                                                    desk.bringSubviewToFront(square)
                                                                    beatBlackCheckers += 1
                                                                    finishGame()
                                                                    square.addSubview(checker)
                                                                    checker.frame.origin = .zero
                                                                    checkBeatCheckerWhite(recognizer: recognizer)
                                                                } else {
                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                        desk.bringSubviewToFront(square)
                                                                        square.addSubview(checker)
                                                                        checker.frame.origin = .zero
                                                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                    }
                                                                }
                                                            } else {
                                                                if square.tag == (squareOfChecker.tag - 21) {
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
                                                                    } else {
                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), sevenBottom.first(where: {$0.subviews.isEmpty}) != nil && fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                            desk.bringSubviewToFront(square)
                                                                            square.addSubview(checker)
                                                                            checker.frame.origin = .zero
                                                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                        }
                                                                    }
                                                                } else {
                                                                    if square.tag == (squareOfChecker.tag - 27) {
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
                                                                        } else {
                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                desk.bringSubviewToFront(square)
                                                                                square.addSubview(checker)
                                                                                checker.frame.origin = .zero
                                                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                            }
                                                                        }
                                                                    } else {
                                                                        if square.tag == (squareOfChecker.tag - 36) {
                                                                            if view.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
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
                                                                            } else {
                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                   nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                    desk.bringSubviewToFront(square)
                                                                                    square.addSubview(checker)
                                                                                    checker.frame.origin = .zero
                                                                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                }
                                                                            }
                                                                        } else {
                                                                            if square.tag == (squareOfChecker.tag - 36) {
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
                                                                                } else {
                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                       nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                        desk.bringSubviewToFront(square)
                                                                                        square.addSubview(checker)
                                                                                        checker.frame.origin = .zero
                                                                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                if square.tag == (squareOfChecker.tag - 54) {
                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                       ((nineBottom.first?.subviews.first?.tag == 1 || nineBottom.first?.subviews.first?.tag == 3) && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((eighteenBottom.first?.subviews.first?.tag == 1 || eighteenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((twentySevenBottom.first?.subviews.first?.tag == 1 || twentySevenBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
                                                                                        ((thirtySixBottom.first?.subviews.first?.tag == 1 || thirtySixBottom.first?.subviews.first?.tag == 3) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil && eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil && twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil && thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil && fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil) ||
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
                                                                                    } else {
                                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"), nineBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                            eighteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                            twentySevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                            thirtySixBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                            fortyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                            desk.bringSubviewToFront(square)
                                                                                            square.addSubview(checker)
                                                                                            checker.frame.origin = .zero
                                                                                            nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                        }
                                                                                    }
                                                                                } else {
                                                                                    if square.tag == (squareOfChecker.tag - 28) {
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
                                                                                        } else {
                                                                                            if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                               sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                desk.bringSubviewToFront(square)
                                                                                                square.addSubview(checker)
                                                                                                checker.frame.origin = .zero
                                                                                                nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                            }
                                                                                        }
                                                                                    } else {
                                                                                        if square.tag == (squareOfChecker.tag - 35) {
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
                                                                                            } else {
                                                                                                if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                   sevenTop.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                    fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                    twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                    twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                    desk.bringSubviewToFront(square)
                                                                                                    square.addSubview(checker)
                                                                                                    checker.frame.origin = .zero
                                                                                                    nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                                }
                                                                                            }
                                                                                        } else {
                                                                                            if square.tag == (squareOfChecker.tag - 42) {
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
                                                                                                } else {
                                                                                                    if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                       sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                        thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                        desk.bringSubviewToFront(square)
                                                                                                        square.addSubview(checker)
                                                                                                        checker.frame.origin = .zero
                                                                                                        nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                                                    }
                                                                                                }
                                                                                            } else {
                                                                                                if square.tag == (squareOfChecker.tag - 49) {
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
                                                                                                    } else {
                                                                                                        if square.subviews.isEmpty, square.backgroundColor == UIColor(named: "ColorBlack"),
                                                                                                           sevenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            fourteenBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            twentyOneBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            twentyEightBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            thirtyFiveBottom.first(where: {$0.subviews.isEmpty}) != nil &&
                                                                                                            fortyTwoBottom.first(where: {$0.subviews.isEmpty}) != nil {
                                                                                                            desk.bringSubviewToFront(square)
                                                                                                            square.addSubview(checker)
                                                                                                            checker.frame.origin = .zero
                                                                                                           nextMove(nextMove: .blackPlaying, text: "Black's move")
                                                                            }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}
                
                                                                                                
extension GamerViewController {
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
                if checker.backgroundColor == .blue, square.tag == (squareOfChecker.tag + 28) {
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
                                    ((nineBottom.first?.subviews.first?.tag == checkerCheck || nineBottom.first?.subviews.first?.tag == queenCheck) && eighteenTop.first(where: {$0.subviews.isEmpty}) != nil) ||
                                    ((eighteenBottom.first?.subviews.first?.tag == checkerCheck || eighteenBottom.first?.subviews.first?.tag == queenCheck) && nineBottom.first(where: {$0.subviews.isEmpty}) != nil) {
                                    takeStep = true
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
        }}}}}}}}}}}}}}}}}}}}}}}}}}
        return takeStep ?? false
    }
}
