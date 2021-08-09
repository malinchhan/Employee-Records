//
//  BookItem.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 9/8/21.
//

import UIKit
import RealmSwift

class BookItem: Object {

    @objc dynamic var title : String = ""
    @objc dynamic var author : String?
    @objc dynamic var list_display_name : String?
    @objc dynamic var list_name_encoded : String?

    @objc dynamic var jsonString:String = ""

    override static func primaryKey() -> String? {
       return "title"
   }
}
