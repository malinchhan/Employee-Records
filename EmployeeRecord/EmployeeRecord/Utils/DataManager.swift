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
                let object = Mapper<Employee>().map(JSONString:json )
                
                //check profile image of each employee
                if let dataProfile = AppManager.shared.getMediaData(pathName: DataKey.employeeProfile.rawValue + "\(object?.id ?? 0)"){
                    object?.imageData = dataProfile
                }
                array.append(object!)
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
            let items = realm.objects(EmployeeItem.self).filter("id == %i",employee.id )

            print("remove local employee")
            try! realm.write {
               realm.delete(items)
           }
        }catch let error as NSError{
             print("realm error: \(error)")
        }
        
    }
    func addBestSeller(bestSeller:BestSeller){
        do {
            let realm = try Realm()
            let item = BestSellerItem()
            let jsonData = bestSeller.toJSON()
            jsonData.forEach { (key, value) in
                if key == "display_name" || key == "list_name_encoded" {
                    item.setValue(value, forKey: key)
                }
            }
            
            let jsonString = bestSeller.toJSONString()
            item.jsonString = jsonString!
            try! realm.write {
                realm.add(item, update: .all)
            }
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    func getAllBestSellers()->[BestSeller]{
        var array:[BestSeller] = []

        do {
            let realm = try Realm()
            let items = realm.objects(BestSellerItem.self).reversed()

            if items.count == 0 {
               return []
           }
            for item in items {
                let json = item.jsonString
                let object = Mapper<BestSeller>().map(JSONString:json )
                array.append(object!)
            }
        
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return array
    }
    func addBook(book:Book){
        do {
            let realm = try Realm()
            let item = BookItem()
            let jsonData = book.toJSON()
            print("book json: \(jsonData)")
            jsonData.forEach { (key, value) in
                if key == "title" || key == "author" || key == "display_name" || key == "list_name_encoded"  {
                    item.setValue(value, forKey: key)
                }
            }
            
            let jsonString = book.toJSONString()
            item.jsonString = jsonString!
            try! realm.write {
                realm.add(item, update: .all)
            }
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    func getAllBooksFor(list_name: String)->[Book]{
        var array:[Book] = []

        do {
            let realm = try Realm()
            let items = realm.objects(BookItem.self)
            if items.count == 0 {
               return []
            }
            for item in items {
                let json = item.jsonString
                let object = Mapper<Book>().map(JSONString:json )
                if object?.list_name == list_name {
                    array.append(object!)
                }
            }
        
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return array
    }
    func getBookFor(title: String)->Book?{

        do {
            let realm = try Realm()
            let items = realm.objects(BookItem.self).filter("title == %@", title)
            if items.count == 0 {
               return nil
            }
            if let json = items.first?.jsonString {
                let object = Mapper<Book>().map(JSONString:json )
                return object
            }
            return nil

        
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return nil
    }
}
