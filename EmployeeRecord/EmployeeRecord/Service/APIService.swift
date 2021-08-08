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
    
    func getBestSellersList(handler:@escaping ([BestSellerList]?,String?)->Void){
        
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
                AppManager.shared.saveJsonDataArray(pathName: "bestSellers", jsonArray: dataJson)

                let dataArray = Mapper<BestSellerList>().mapArray(JSONArray: dataJson)
                handler(dataArray,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    func getTop5BooksFromBestSellersList(handler:@escaping ([BestSellerList]?,String?)->Void){
        
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

                let dataArray = Mapper<BestSellerList>().mapArray(JSONArray: listsJson)
                handler(dataArray,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    func getDetailBestSellers(list_name_encoded:String , handler:@escaping ([BestSellerList]?,String?)->Void){
        
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
            

                let dataArray = Mapper<BestSellerList>().mapArray(JSONArray: dataJson)
                handler(dataArray,nil)
                
            case .failure(let error):
                handler(nil,error.errorDescription)

            }
        }
    }
    
}
