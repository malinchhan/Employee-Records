//
//  EmployeeItem.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import RealmSwift

class EmployeeItem: Object {
    
    @objc dynamic var id : Int = 0
    @objc dynamic var firstName : String?
    @objc dynamic var middleName : String?
    @objc dynamic var lastName : String?
    @objc dynamic var updated_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())
    @objc dynamic var created_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())
    @objc dynamic var jsonString:String = ""

    
    override static func primaryKey() -> String? {
       return "id"
   }
}
