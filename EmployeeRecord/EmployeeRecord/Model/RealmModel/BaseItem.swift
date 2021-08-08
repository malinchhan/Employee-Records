//
//  BaseItem.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import RealmSwift


class BaseItem: Object {

    @objc dynamic var id : Int = 0
    @objc dynamic var updated_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())
    @objc dynamic var created_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())
    @objc dynamic var jsonString:String = ""

    override static func primaryKey() -> String? {
       return "id"
   }
}
