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
    
    var tasks: [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let taskData = (try CoreDataStack.context.fetch(request))
            return taskData
        } catch {
            print(error)
        }
        return []
    }
    
    
    func add(taskWithName name: String, notes: String?, due: Date?) {
        
    }
    
    func update(task: Task, name: String, notes: String?, due: Date?) {
        
    }
    
    func remove(task: Task) {
        
    }
    
    func toggleIsCompleteFor(task: Task) {
        task.isComplete = !task.isComplete
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        
    }
}
