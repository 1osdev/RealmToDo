//
//  TasksList.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 14.03.22.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
