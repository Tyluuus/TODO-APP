//
//  UserDefaultsManager.swift
//  TODO APP
//
//  Created by Piotr Tyl on 06/05/2022.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func getTasksList() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: "tasksList") {
            do {
                let decoder = JSONDecoder()
                
                let tasks = try decoder.decode([Task].self, from: data)
                
               // print(tasks)
                return tasks
            }
            catch {
                print("Unable to decode task list")
            }
        }
        
        return []
    }
    
    func saveTasksList(tasks: [Task]) -> Bool {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasksList")
            return true
        }
        return false
    }
    
    func isTaskListEmpty() -> Bool {
        
        if let data = UserDefaults.standard.data(forKey: "tasksList") {
            do {
                let decoder = JSONDecoder()
                let taskList = try decoder.decode([Task].self, from: data)
                if taskList.count == 0 {
                    return true
                }
                return false
            }
            catch {
                print("Unable to decode task list")
            }
        }
        return true
    }
    
    func addNewTask(task: Task) -> Bool {
        var tasks = getTasksList()
        tasks.append(task)
        clearTaskList()
        let sucess = saveTasksList(tasks: tasks)
        return sucess
    }
    
    func clearTaskList() {
        UserDefaults.standard.removeObject(forKey: "taskList")
    }
    
    func deleteTask(taskID: Int) -> Bool{
        var tasks = getTasksList()
        tasks.remove(at: taskID)
        let sucess = saveTasksList(tasks: tasks)
        return sucess
    }
}
