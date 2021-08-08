//
//  APITarget.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import Foundation
import Moya
import UIKit


enum APITarget {
    case getBookBestSellers
    case getTop5BooksFromBestSellers
    case getListDetail(listName:String)
    
}
extension APITarget : TargetType {

    var baseURL: URL {
        return URL(string: "https://api.nytimes.com/svc/books/v3/")!
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return [:]
        
    }
    
    var path: String {
        switch self {
        case  .getBookBestSellers:
            return "lists/names.json"
        case .getTop5BooksFromBestSellers:
            return "lists/overview.json"
        case .getListDetail(_):
            return "/lists.json"
//        default:
//            return ""
        }
    }
    var task: Task{
        let API_KEY = "tNlHYfVAEULPcz5SUQr1aFYKjkHW7V1p"

        switch self {
          
            case .getListDetail(let listName):
                return  .requestParameters(parameters: ["api-key":API_KEY , "list":listName], encoding: URLEncoding.queryString)

            default :
                return  .requestParameters(parameters: ["api-key":API_KEY], encoding: URLEncoding.queryString)
        }
    }
}
