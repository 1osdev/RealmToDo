//
//  Task.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 14.03.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplite = false
}
