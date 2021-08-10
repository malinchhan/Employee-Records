//
//  AppManager.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

public enum DataKey: String{
    case employeeProfile = "employeeProfile"
    case bestSellers = "bestSellers"
    case bestSellersBooks = "bestSellersBooks"
    case top5BooksFromBestSellers = "top5BooksFromBestSellers"

}

class AppManager: NSObject {
    static let shared = AppManager()
    var selectedBook:Book?
    let provincesAndCity:[String] = [
            "Phnom Penh",
            "Takeo",
            "Sihanoukville",
            "Battambang",
            "Siem Reap",
            "Paoy Paet",
            "Kampong Chhnang",
            "Kampong Cham",
            "Pursat",
            "Ta Khmau",
            "Phumi Veal Sre",
            "Kampong Speu",
            "Koh Kong",
            "Prey Veng",
            "Suong",
            "Smach Mean Chey",
            "Stung Treng",
            "Tbeng Meanchey",
            "Svay Rieng",
            "Sisophon",
            "Kampot",
            "Kratie",
            "Kampong Thom",
            "Lumphat",
            "Samraong",
            "Pailin",
            "Banlung",
            "Krong Kep",
            "Sen Monorom"
]

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
  
    func getJsonArrayData(pathName:String) -> [[String:Any]]{
        let fullPath = getDocumentsDirectory().appendingPathComponent(pathName)
        
        do {
            if let jsonArr = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: fullPath)) as? [[String:Any]]{
                return jsonArr
            }
        }catch {
            return []
        }
        return []
    }
   
    func saveJsonDataArray(pathName:String,jsonArray:[[String:Any]]){
       let fullPath = getDocumentsDirectory().appendingPathComponent(pathName)
       
       do {
           if #available(iOS 11.0, *) {
               let data = try NSKeyedArchiver.archivedData(withRootObject: jsonArray, requiringSecureCoding: false)
               try data.write(to: fullPath)
           } else {
               // Fallback on earlier versions
               
               let data = try NSKeyedArchiver.archivedData(withRootObject: jsonArray)
               try data.write(to: fullPath)
           }
           
       }catch {
           print("error to get data")
       }
   }
    
}
