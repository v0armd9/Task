//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Darin Marcus Armstrong on 6/19/19.
//  Copyright © 2019 Darin Marcus Armstrong. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    var taskLandingPad: Task?
    var dueDateValue: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        dueDateTextField.inputView = dueDatePicker
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let task = taskLandingPad {
            let due = taskLandingPad?.due
            guard let name = nameTextField.text else {return}
            TaskController.sharedInstance.update(task: task, name: name, notes: notesTextView?.text, due: due)
        } else {
            let due = dueDatePicker.date
            guard let name = nameTextField.text,
            let notes = notesTextView.text
            else {return}
            TaskController.sharedInstance.add(taskWithName: name, notes: notes, due: due)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateTextField.text = dueDatePicker.date.stringValue()
    }
    
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        dueDateTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
    }
    
    func updateViews() {
        guard let task = taskLandingPad,
            let due = taskLandingPad?.due,
            isViewLoaded
            else {return}
        nameTextField.text = task.name
        notesTextView.text = task.notes
        dueDateTextField.text = due.stringValue()
    }
}

