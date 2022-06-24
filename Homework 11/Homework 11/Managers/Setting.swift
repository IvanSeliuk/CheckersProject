//
//  Setting.swift
//  Homework 11
//
//  Created by Иван Селюк on 7.02.22.
//

import UIKit

class Setting: NSObject {
    
    enum UserDefaultsKeys: String {
        case onboadringCompleted
        case namePlayer
        case namePlayerSecond
        case saveGame
        case background
        case timer
        case whiteCheckerCompleted
        case blackCheckerCompleted
        case currentGamer
        case language
        case isSave
        case beatBlackCheckers
        case beatWhiteCheckers
    }
    
    static let shared = Setting()
    let languageCode = ["en", "ru", "de", "fr", "es"]
    
    var onboardingCompleted: Bool {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.onboadringCompleted.rawValue) }
        get { return UserDefaults.standard.bool(forKey: UserDefaultsKeys.onboadringCompleted.rawValue) }
    }
    
    var isSave: Bool {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isSave.rawValue) }
        get { return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isSave.rawValue) }
    }
    
    var namePlayer: String? {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.namePlayer.rawValue) }
        get { return UserDefaults.standard.string(forKey: UserDefaultsKeys.namePlayer.rawValue) }
    }
    
    var namePlayerSecond: String? {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.namePlayerSecond.rawValue) }
        get { return UserDefaults.standard.string(forKey: UserDefaultsKeys.namePlayerSecond.rawValue) }
    }
    
    var background: UIImage? {
        set { if let dataImage = newValue?.jpegData(compressionQuality: 0.96) {
            UserDefaults.standard.set(dataImage, forKey: UserDefaultsKeys.background.rawValue)
        }
        }
        get { if let dataImage = UserDefaults.standard.data(forKey: UserDefaultsKeys.background.rawValue){
            return UIImage(data: dataImage)
        }
            return UIImage(named: "доска 2")
        }
    }
    
    var timer: Int? {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.timer.rawValue) }
        get { return UserDefaults.standard.integer(forKey: UserDefaultsKeys.timer.rawValue) }
    }
    
    var beatWhiteCheckers: Int? {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.beatWhiteCheckers.rawValue) }
        get { return UserDefaults.standard.integer(forKey: UserDefaultsKeys.beatWhiteCheckers.rawValue) }
    }
    
    var beatBlackCheckers: Int? {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.beatBlackCheckers.rawValue) }
        get { return UserDefaults.standard.integer(forKey: UserDefaultsKeys.beatBlackCheckers.rawValue) }
    }
    
    var currentGamer: MovePlayer {
        set { UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.currentGamer.rawValue) }
        get { let intValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentGamer.rawValue)
            return MovePlayer(rawValue: intValue) ?? .whitePlaying
        }
    }
    
    var currentLanguage: String {
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.language.rawValue) }
        get { return UserDefaults.standard.string(forKey: UserDefaultsKeys.language.rawValue) ?? "en" }
    }
}
