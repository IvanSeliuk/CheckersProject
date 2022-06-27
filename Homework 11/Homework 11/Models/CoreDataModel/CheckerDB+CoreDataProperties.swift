//
//  CheckerDB+CoreDataProperties.swift
//  
//
//  Created by Иван Селюк on 20.06.22.
//
//

import Foundation
import CoreData


extension CheckerDB {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckerDB> {
        return NSFetchRequest<CheckerDB>(entityName: "CheckerDB")
    }
    
    @NSManaged public var namePlayer: String?
    @NSManaged public var namePlayerSecond: String?
    @NSManaged public var winner: String?
    @NSManaged public var timer: String?
    @NSManaged public var date: String?
    
    func getMapped() -> Checkers {
        return Checkers(namePlayer: namePlayer,
                        namePlayerSecond: namePlayerSecond,
                        winner: winner,
                        timer: timer,
                        date: date)
    }
    
    func setValues(checkers: [Checkers]) {
        self.namePlayer = checkers.first?.namePlayer
        self.namePlayerSecond = checkers.first?.namePlayerSecond
        self.winner = checkers.first?.winner
        self.timer = checkers.first?.timer
        self.date = checkers.first?.date
    }
    
}
