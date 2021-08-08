//
//  AppManager.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class AppManager: NSObject {
    static let shared = AppManager()

    func getDocumentsDirectory() -> URL {
        
        let documentDirectoryURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL
 
    }
    func getMediaData(pathName:String) -> Data? {
         let fullPath = getDocumentsDirectory().appendingPathComponent(pathName)
         
         do {
             if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: fullPath)) as? Data{
                 return data
             }
         }catch {
             return nil
         }
         return nil
     }
    
     func saveMediaData(pathName:String,data:Data){
        let fullPath = getDocumentsDirectory().appendingPathComponent(pathName)
        
        do {
            if #available(iOS 11.0, *) {
                let dataToSave = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                try dataToSave.write(to: fullPath)
            } else {
                // Fallback on earlier versions
                
                let dataToSave = try NSKeyedArchiver.archivedData(withRootObject: data)
                try dataToSave.write(to: fullPath)
            }

        }catch {
            print("error to get media data")
        }
    }
    func getJsonData(pathName:String) ->  [String:Any]?{
        let directory = getDocumentsDirectory()
        if directory == nil {
            return nil
        }
        let fullPath = directory.appendingPathComponent(pathName)
        
        do {
            if let json = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: fullPath)) as? [String:Any]{
                return json
            }
            
        }catch {
            return nil
        }
        return nil
    }
    func saveJsonData(pathName:String,json:[String:Any]){
        let fullPath = getDocumentsDirectory().appendingPathComponent(pathName)
        do {
            if #available(iOS 11.0, *) {
                let data = try NSKeyedArchiver.archivedData(withRootObject: json, requiringSecureCoding: false)
                try data.write(to: fullPath)
            } else {
                // Fallback on earlier versions
                
                let data = try NSKeyedArchiver.archivedData(withRootObject: json)
                try data.write(to: fullPath)
            }
            
        }catch {
            print("error to get data")
        }
    }
    
    
}
