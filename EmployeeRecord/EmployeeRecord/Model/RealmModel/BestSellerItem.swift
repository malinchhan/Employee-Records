//
//  BestSellerItem.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 9/8/21.
//

import UIKit
import RealmSwift

class BestSellerItem: Object {

    @objc dynamic var display_name : String = ""
    @objc dynamic var list_name_encoded : String?
    @objc dynamic var jsonString:String = ""

    override static func primaryKey() -> String? {
       return "display_name"
   }
}
