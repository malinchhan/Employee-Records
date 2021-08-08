//
//  Employee.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import ObjectMapper

class Employee: BaseModel {
    
    //    • Profile Image* 
    //    • First Name*  
    //    • Middle Name
    //    • Last Name*
    //    • Province / City*
    //    • Address
    //    • Gender*
    //    • DOB
    //    • Hobby
    //    • Favorite book*
    
    var imageData:Data = Data()
    var firstName:String = ""
    var middleName:String = ""
    var lastName:String = ""
    var provinceOrCity:String = ""
    var address:String?
    var gender:String = ""
    var dob:String?
    var hobby:String?
    var book:String?
    
 
    override func mapping(map: Map) {
        id <- map["id"]
        imageData <- map["image"]
        firstName <- map["firstName"]
        middleName <- map["middleName"]
        lastName <- map["lastName"]
        provinceOrCity <- map["provinceOrCity"]
        address <- map["address"]
        gender <- map["gender"]
        dob <- map["dob"]
        hobby <- map["hobby"]
        book <- map["book"]

        updated_at <- map["updated_at"]
        created_at <- map["created_at"]

    }
}
