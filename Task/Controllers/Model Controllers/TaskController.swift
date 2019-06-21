//
//  TaskController.swift
//  Task
//
//  Created by Darin Marcus Armstrong on 6/19/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    static let sharedInstance = TaskController()
    
    let fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: false), NSSortDescriptor(key: "due", ascending: false)]
        
        let resultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func add(taskWithName name: String, notes: String, due: Date?) {
        guard let due = due else {return}
        Task(name: name, notes: notes, due: due)
        saveToPersistentStore()
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        saveToPersistentStore()
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch {
            print("Error saving to persistence: \(error.localizedDescription)")
        }
    }
}
