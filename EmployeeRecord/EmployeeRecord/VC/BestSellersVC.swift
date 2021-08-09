//
//  BestSellersVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//

import UIKit
import ObjectMapper

class BestSellersVC: BaseVC {

    var data:[BestSeller] = []
    var searchData:[BestSeller] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTableView(frame: self.screenBound, style: .plain)
        self.tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: cellID)
        self.title = "Best Sellers"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        
        self.setupSearchControlller()
        self.tableView.tableHeaderView = searchController.searchBar

        //when get data from Realm, no key to sort same as data from server
//        self.data = DataManager.shared.getAllBestSellers()
        
        //So we get data we save in FileManager
        let localData = AppManager.shared.getJsonArrayData(pathName: DataKey.bestSellers.rawValue)
        if localData.count > 0 {
            self.data = Mapper<BestSeller>().mapArray(JSONArray: localData)
            self.tableView.reloadData()
        }
        
        self.requestData()
    }
    
    @objc func goBack(){
        self.dismiss(animated: false, completion: nil)
    }
    func requestData(){
        Util.showIndicator()
        APIService.shared.getBestSellersList { results, error in
            Util.hideIndicator()
            
            if results != nil {
                self.data = results!
                self.tableView.reloadData()
                return
            }
            Util.showError(text: error ?? "Unkwon Error !")
        }
    }
    override func updateSearchResults(for searchController: UISearchController) {
        self.searchData.removeAll()

        if let search = searchController.searchBar.text {
            searchText = search
//            print("search text : \(search)")

            self.searchData = self.data.filter({ (item) -> Bool in
                 return (item.display_name?.lowercased().contains(searchText.lowercased()))!
            })
            
        }else{
            self.searchText = ""
        }
        
        self.tableView.reloadData()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchText.count > 0 {
            return self.searchData.count
        }
        return self.data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellID , for: indexPath)  as! DefaultTableViewCell
        if self.searchText.count > 0 {
            cell.textLabel?.text = self.searchData[indexPath.row].display_name

        }else{
            cell.textLabel?.text = self.data[indexPath.row].display_name

        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var list = self.data[indexPath.row]
        if self.searchText.count > 0 {
            list = self.searchData[indexPath.row]
        }
        
        let detailVC = BooksVC()
        detailVC.list_name_encoded = list.list_name_encoded ?? ""
        detailVC.list_name = list.list_name
        self.navigationController?.pushViewController(detailVC, animated: false)
    }

    
}
