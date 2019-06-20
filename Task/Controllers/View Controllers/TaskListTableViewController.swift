//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Darin Marcus Armstrong on 6/20/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate {
    
    func ButtonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else {return}
        let task = TaskController.sharedInstance.fetchedResultsController.object(at: indexPath)
        TaskController.sharedInstance.toggleIsCompleteFor(task: task)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 1
        }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = TaskController.sharedInstance.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return  sections[section].objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell,
            let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return UITableViewCell()}
        cell.update(withTask: task)
        cell.delegate = self
        
        
        
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if TaskController.sharedInstance.fetchedResultsController.sections?[section].name == "0" {
            return "Incompleted"
        } else {
            return "Completed"
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let task = TaskController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else {return}
            TaskController.sharedInstance.remove(task: task)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
