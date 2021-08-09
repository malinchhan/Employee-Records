//
//  BestSellerList.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import ObjectMapper

class BestSeller: Mappable {

//                "list_name": "Combined Print and E-Book Fiction",
//                "display_name": "Combined Print & E-Book Fiction",
//                "list_name_encoded": "combined-print-and-e-book-fiction",
//                "oldest_published_date": "2011-02-13",
//                "newest_published_date": "2021-08-15",
//                "updated": "WEEKLY"
//                 "list_id": 704,
//                    "rank": 2,
//                    "rank_last_week": 2,
//                    "weeks_on_list": 4,
               
    var list_id:Int?
    var list_name:String?
    var display_name:String?
    var list_name_encoded:String?
    var oldest_published_date:String?
    var newest_published_date:String?
    var updated:String?
    var rank:Int?
    var rank_last_week:Int?
    var weeks_on_list:Int?
    var books:[Book]?
    var book_details:[Book]?
    

    required init?(map: Map) {}

    func mapping(map: Map) {
        list_id <- map["list_id"]
        list_name <- map["list_name"]
        display_name <- map["display_name"]
        list_name_encoded <- map["list_name_encoded"]
        oldest_published_date <- map["oldest_published_date"]
        newest_published_date <- map["newest_published_date"]
        updated <- map["updated"]
        rank <- map["rank"]
        rank_last_week <- map["rank_last_week"]
        weeks_on_list <- map["weeks_on_list"]
        books <- map["books"]
        book_details <- map["book_details"]

    }
}
