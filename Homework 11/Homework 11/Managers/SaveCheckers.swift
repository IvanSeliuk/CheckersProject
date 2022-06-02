//
//  SaveCheckers.swift
//  Homework 11
//
//  Created by Иван Селюк on 10.02.22.
//

import UIKit

class SaveCheckers: NSObject, NSCoding, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    var number: Int
    var checkerName: ColorChecker
    
    init(number:Int, checkerName: ColorChecker) {
        self.number = number
        self.checkerName = checkerName
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(number, forKey: "number")
        coder.encode(checkerName.rawValue, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        self.number = coder.decodeInteger(forKey: "number")
        let imageString = coder.decodeObject(forKey: "image") as? String
        self.checkerName = ColorChecker(rawValue: imageString ?? "") ?? .white
    }
}
