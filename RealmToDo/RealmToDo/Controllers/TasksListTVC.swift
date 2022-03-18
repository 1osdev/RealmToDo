//
//  TasksListTVC.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 14.03.22.
//

import UIKit
import RealmSwift
import SwiftUI

class TasksListTVC: UITableViewController {

    var tasksLists: Results<TasksList>!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        //StorageManager.deleteAll()

        tasksLists = realm.objects(TasksList.self)//.sorted(byKeyPath: "name")

        addTasksListsobserve()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    @IBAction func sortingSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
        //cell.textLabel?.text = tasksList.name
        //cell.detailTextLabel?.text = String(tasksList.tasks.count)
        cell.configure(with: tasksList)
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt IndexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let currentList = tasksLists[IndexPath.row]

        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteList(currentList)
            tableView.deleteRows(at: [IndexPath], with: .automatic)
        }

        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdatesListTasks(currentList) {
                tableView.reloadRows(at: [IndexPath], with: .automatic)
            }
        }
        let doneContextItem = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            StorageManager.makeAllDone(currentList){
                tableView.reloadRows(at: [IndexPath], with: .automatic)
            }
        }

        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksTVC
            tasksVC.currentTasksList = tasksList
        }
    }
    
    /*
    @objc private func alertForAddAndUpdatesListTask() {
        // Names
        let title = "New List"
        let message = "Please insert list name"
        let doneBtnName = "Save"
        
        // AlertController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // TextField
        var alertTextField: UITextField!
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        // Actions
        let saveAction = UIAlertAction(title: doneBtnName, style: .default) { _ in
          guard let newListName = alertTextField.text, !newListName.isEmpty else { return }
          let tasksList = TasksList()
            tasksList.name = newListName
            
            StorageManager.saveTasksList(tasksList: tasksList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .fade)
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
        
           present(alert, animated: true)
    }
     */
    // Универсальная функция
    @objc private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks {
            print("ListTasks")
        }
    }

    private func alertForAddAndUpdatesListTasks(_ tasksList: TasksList? = nil,
        completion: @escaping () -> Void) {
        let title = tasksList == nil ? "New List" : "Edit List"
        let message = "Please insert list name"
        let doneButtonName = tasksList == nil ? "Save" : "Update"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        var alertTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in
            guard let newListName = alertTextField.text, !newListName.isEmpty else { return }

            if let tasksList = tasksList {
                StorageManager.editList(tasksList, newListName: newListName, completion: completion)
            } else {
                let tasksList = TasksList()
                tasksList.name = newListName

                StorageManager.saveTasksList(tasksList: tasksList)
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .fade)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            alertTextField = textField

            if let listName = tasksList {
                alertTextField.text = listName.name
            }
            alertTextField.placeholder = "List Name"
        }
        present(alert, animated: true)
    }

    private func addTasksListsobserve() {

        notificationToken = tasksLists.observe { change in
            switch change {
            case .initial:
                print("initial element")
            case .update(_, let deletions, let insertions, let modifications):
                print("deletions: \(deletions)")
                print("insertions: \(insertions)")
                print("modification: \(modifications)")

                if !modifications.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in modifications {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.reloadRows(at: indexPathArray, with: .automatic)
                }
                if !deletions.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in deletions {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.deleteRows(at: indexPathArray, with: .automatic)
                }
                if !insertions.isEmpty {
                    var indexPathArray = [IndexPath]()
                    for row in insertions {
                        indexPathArray.append(IndexPath(row: row, section: 0))
                    }
                    self.tableView.insertRows(at: indexPathArray, with: .automatic)
                }
            case .error(let error):
                print("error \(error)")
            }
        }
    }
}
