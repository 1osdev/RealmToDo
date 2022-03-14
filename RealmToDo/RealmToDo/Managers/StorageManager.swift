//
//  StorageManager.swift
//  RealmToDo
//
//  Created by Дмитрий Смирнов on 14.03.22.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class  StorageManager {
    
    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error")
        }
    }
    
    static func saveTasksList(tasksList: TasksList) {
        try! realm.write({
            realm.add(tasksList)
            // Print URL default.realm
            print("Realm is located at:", realm.configuration.fileURL!)
        })
    }
}
