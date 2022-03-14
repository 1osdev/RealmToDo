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

    override func viewDidLoad() {
        super.viewDidLoad()

        //StorageManager.deleteAll()
        
        tasksLists = realm.objects(TasksList.self).sorted(byKeyPath: "name")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(alertForAddAndUpdatesListTask))
        self.navigationItem.setRightBarButtonItems([add, editButtonItem], animated: true)
    }

    @IBAction func sortingSegmentedControl(_ sender: UISegmentedControl) {
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = String(tasksList.tasks.count)
        return cell
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
}
