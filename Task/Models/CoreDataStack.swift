//
//  CoreDataStack.swift
//  Task
//
//  Created by Darin Marcus Armstrong on 6/19/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    static let container: NSPersistentContainer = {
        
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext { return container.viewContext }
}
