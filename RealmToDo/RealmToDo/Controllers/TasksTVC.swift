//
//  TasksTVC.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 14.03.22.
//

import UIKit
import RealmSwift

class TasksTVC: UITableViewController {
// MARK: Internal
    var currentTasksList: TasksList!
    
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTasksList.name
        filteringTasks()
    
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //alertForAddAndUpdateList()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedTasks.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not Completed Tasks" : "Completed Tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]

        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }

        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(task)
        }

        let doneText = task.isComplite ? "Not done" : "Done"
        let doneContextItem = UIContextualAction(style: .destructive, title: doneText) { _, _, _ in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }

        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])

        return swipeActions
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
// MARK: Private
    
    private func filteringTasks() {
        notCompletedTasks = currentTasksList.tasks.filter("isComplite = false")
        completedTasks = currentTasksList.tasks.filter("isComplite = true")
        tableView.reloadData()
    }
}

extension TasksTVC {
    
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdateList()
    }
    
    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        let title = "Task value"
        let message = (taskName == nil) ? "Please insert new task value" : "Please edit your task"
        let doneButton = (taskName == nil) ? "Save" : "Update"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in

            guard let newNameTask = taskTextField.text, !newNameTask.isEmpty else { return }

            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newNameTask: newNameTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newNameTask: newNameTask, newNote: "")
                }
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newNameTask
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"

            if let taskName = taskName {
                taskTextField.text = taskName.name
            }
        }

        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"

            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
        }

        present(alert, animated: true)
    }
}

