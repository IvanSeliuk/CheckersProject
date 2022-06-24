//
//  CoreDataManager.swift
//  Homework 11
//
//  Created by Иван Селюк on 19.06.22.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CheckerDataBase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveScoreInDB(checkers: [Checkers]) {
        let checkersDB =  CheckerDB(context: context)
        checkersDB.setValues(checkers: checkers)
        self.context.insert(checkersDB)
        saveContext()
    }
    
    func getFromDB() -> [Checkers] {
        let request = CheckerDB.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        guard let paremeters = try? context.fetch(request) else { return [] }
        return paremeters.map { $0.getMapped() }
    }
    
    func saveContext () {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clearDataBase() {
        let checkers = CheckerDB.fetchRequest()
        do {
            let checkersDB = try context.fetch(checkers)
            checkersDB.forEach {
                context.delete($0)
            }
            saveContext()
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
}
