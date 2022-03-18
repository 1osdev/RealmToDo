//
//  UITableViewCellExt.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 18.03.22.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        let currentTasks = tasksList.tasks.filter("isComplite = false")
        let completedTasks = tasksList.tasks.filter("isComplite = true")

        textLabel?.text = tasksList.name

        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 24)
            detailTextLabel?.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        }
    }
}
