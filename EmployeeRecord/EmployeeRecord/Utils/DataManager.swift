//
//  DataManager.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import RealmSwift
import ObjectMapper


class DataManager: NSObject {
    static let shared = DataManager()
    
    func addEmployee(employee:Employee){
        do {
            let realm = try Realm()
            let item = EmployeeItem()
            let jsonData = employee.toJSON()
            jsonData.forEach { (key, value) in
                if key == "id" || key == "firstName" || key == "middleName" ||  key == "lastName" ||  key == "updated_at" || key == "created_at"{
                    item.setValue(value, forKey: key)
                }
            }
            
            let jsonString = employee.toJSONString()
            item.jsonString = jsonString!
            print(" employee item: \(item)")
            try! realm.write {
                realm.add(item, update: .all)
            }
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    func getAllEmployees()->[Employee]{
        var array:[Employee] = []

        do {
            let realm = try Realm()
            let items = realm.objects(EmployeeItem.self).reversed()

            if items.count == 0 {
               return []
           }
            for item in items {
                let json = item.jsonString
                let supplier = Mapper<Employee>().map(JSONString:json )
                array.append(supplier!)
            }
        
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return array
    }
    func countEmployees()->Int{
    
        do {
            let realm = try Realm()
            let totalCount = realm.objects(EmployeeItem.self).count
            return totalCount
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return 0
    }
    func removeEmployee(employee:Employee){
        do {
            let realm = try Realm()
            let items = realm.objects(EmployeeItem.self).filter("id == %i",employee.id ?? 0)

            print("remove local employee")
            try! realm.write {
               realm.delete(items)
           }
        }catch let error as NSError{
             print("realm error: \(error)")
        }
        
    }
}
