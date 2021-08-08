//
//  BaseModel.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import ObjectMapper

class BaseModel: Mappable {
    var id : Int = 0
    var updated_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())
    var created_at : String? = Util.shared.getDefaultDateStringFromDate(date: Date())

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        updated_at <- map["updated_at"]
        created_at <- map["created_at"]

    }
}
