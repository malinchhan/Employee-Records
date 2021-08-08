//
//  Book.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import ObjectMapper

class Book: Mappable {
    
    var author:String?
    var book_image:String?
    var contributor:String?
    var created_date:String?
    var description:String?
    var rank:Int?
    var rank_last_week:Int?
    var title:String?
    var updated_date:String?
    var weeks_on_list:Int?
    var publisher:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        author <- map["author"]
        book_image <- map["book_image"]
        contributor <- map["contributor"]
        created_date <- map["created_date"]
        description <- map["description"]
        rank <- map["rank"]
        rank_last_week <- map["rank_last_week"]
        title <- map["title"]
        updated_date <- map["updated_date"]
        weeks_on_list <- map["weeks_on_list"]
        publisher <- map["publisher"]

    }
    

//   "amazon_product_url": "http://www.amazon.com/Harry-Potter-And-Order-Phoenix/dp/0439358078?tag=NYTBSREV-20",
//   "article_chapter_link": "",
//   "author": "J.K. Rowling",
//   "book_image": "https://storage.googleapis.com/du-prd/books/images/9780590353427.jpg",
//   "book_image_width": 328,
//   "book_image_height": 495,
//   "book_review_link": "",
//   "contributor": "by J.K. Rowling",
//   "contributor_note": "",
//   "created_date": "2021-08-04 22:19:20",
//   "description": "A wizard hones his conjuring skills in the service of fighting evil.",
//   "first_chapter_link": "",
//   "price": "0.00",
//   "primary_isbn10": "059035342X",
//   "primary_isbn13": "9780590353427",
//   "book_uri": "nyt://book/17005581-f735-545e-acaf-79dcfdd25a1f",
//   "publisher": "Scholastic",
//   "rank": 1,
//   "rank_last_week": 1,
//   "sunday_review_link": "",
//   "title": "HARRY POTTER",
//   "updated_date": "2021-08-04 22:23:27",
//   "weeks_on_list": 645,
    
    
}
