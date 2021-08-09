//
//  APIService.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import Foundation
import Moya
import ObjectMapper

class APIService: NSObject {

    static let shared = APIService()
    let provider = MoyaProvider<APITarget>()
    
    var errorString = "Request Error !"
    
    func getBestSellersList(handler:@escaping ([BestSeller]?,String?)->Void){
        
        self.provider.request(.getBookBestSellers) { [self] result in
            switch result {
            case .success(let response):
                if response.statusCode != 200 {
                    handler(nil, self.errorString)
                }
                let responseJson = try? (response.mapJSON() as! [String:Any])
                guard let dataJson = responseJson!["results"] as? [[String:Any]] else{
                    handler(nil, self.errorString)
                    return
                }

                AppManager.shared.saveJsonDataArray(pathName: DataKey.bestSellers.rawValue, jsonArray: dataJson)
                let dataArray = Mapper<BestSeller>().mapArray(JSONArray: dataJson)
                dataArray.forEach { list in
                    DataManager.shared.addBestSeller(bestSeller: list)
                }
                handler(dataArray,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    func getTop5BooksFromBestSellersList(handler:@escaping ([BestSeller]?,String?)->Void){
        
        self.provider.request(.getTop5BooksFromBestSellers) { [self] result in
            switch result {
            case .success(let response):
                if response.statusCode != 200 {
                    handler(nil, self.errorString)
                }
                let responseJson = try? (response.mapJSON() as! [String:Any])
                guard let dataJson = responseJson!["results"] as? [String:Any] else{
                    handler(nil, self.errorString)
                    return
                }
                
                guard let listsJson = dataJson["lists"] as? [[String:Any]] else{
                    handler(nil, self.errorString)
                    return
                }

                let dataArray = Mapper<BestSeller>().mapArray(JSONArray: listsJson)
                _ = self.getBooksFromBestSellersList(lists: dataArray, list_name_encoded: "")
                handler(dataArray,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    func getDetailBestSellers(list_name_encoded:String , handler:@escaping ([Book]?,String?)->Void){
        
        self.provider.request(.getListDetail(listName: list_name_encoded)) { [self] result in
            switch result {
            case .success(let response):
                if response.statusCode != 200 {
                    handler(nil, self.errorString)
                }
                let responseJson = try? (response.mapJSON() as! [String:Any])
                guard let dataJson = responseJson!["results"] as? [[String:Any]] else{
                    handler(nil, self.errorString)
                    return
                }
                
                let dataArray = Mapper<BestSeller>().mapArray(JSONArray: dataJson)
                let books:[Book] = self.getBooksFromBestSellersList(lists: dataArray, list_name_encoded: list_name_encoded)
                handler(books,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    func getBooksFromBestSellersList(lists:[BestSeller],list_name_encoded:String)->[Book]{
        var books:[Book] = []
        lists.forEach { list in
            DataManager.shared.addBestSeller(bestSeller: list)
            if let data = list.book_details {
                data.forEach { b in
                    b.list_name = list.list_name ?? ""
                    b.list_name_encoded = list_name_encoded
                    DataManager.shared.addBook(book: b)
                    books.append(b)
                }
            }
            if let data = list.books {
                data.forEach { b in
                    b.list_name = list.list_name ?? ""
                    b.list_name_encoded =  list_name_encoded
                    DataManager.shared.addBook(book: b)
                    books.append(b)
                }
            }
        }
        return books
    }
    
}
