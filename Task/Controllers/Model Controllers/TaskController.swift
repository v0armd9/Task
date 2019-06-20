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
    
    var tasks: [Task] = []
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        do {
//            let taskData = (try CoreDataStack.context.fetch(request))
//            return taskData
//        } catch {
//            print(error)
//        }
//        return []
//    }
    init() {
        tasks = fetchTasks()
    }
    
    func add(taskWithName name: String, notes: String, due: Date?) {
        guard let due = due else {return}
        Task(name: name, notes: notes, due: due)
        saveToPersistentStore()
        tasks = fetchTasks()
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistentStore()
        tasks = fetchTasks()
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        saveToPersistentStore()
        tasks = fetchTasks()
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
    
    private func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        return (try? CoreDataStack.context.fetch(request)) ?? []
    }
}
