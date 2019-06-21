//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Darin Marcus Armstrong on 6/20/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate {
    
    func ButtonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        TaskController.sharedInstance.toggleIsCompleteFor(task: task)
        sender.update(withTask: task)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
            return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 1
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = TaskController.sharedInstance.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return  sections[section].objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else {return UITableViewCell()}

            let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.update(withTask: task)
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if TaskController.sharedInstance.fetchedResultsController.sections?[section].name == "0" {
            return "Incomplete"
        } else {
            return "Completed"
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            TaskController.sharedInstance.remove(task: task)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TaskDetailTableViewController
            else {return}
            let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row]
            destinationVC.taskLandingPad = task
        }
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch(type) {
        case .insert:
            self.tableView?.insertSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView?.deleteSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
