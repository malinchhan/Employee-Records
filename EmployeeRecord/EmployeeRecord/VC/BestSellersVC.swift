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

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissScreen))
        
        self.setupSearchControlller()
        self.tableView.tableHeaderView = searchController.searchBar

        let buttonRight = UIButton(frame: CGRect(x: 0, y: 0, width: 100 , height: 50))
        buttonRight.setTitle("Top 5 Books", for: .normal)
        buttonRight.setTitleColor(.defaultBlueColor(), for: .normal)
        
        buttonRight.addTarget(self, action: #selector(top5BooksClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: buttonRight)
        
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
   
    @objc func top5BooksClicked(){
        if self.searchController != nil {
            self.searchController.isActive = false //avoid crash when search is active
        }
        let vc = Top5BooksVC()
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
   
    func requestData(){
        if self.data.count == 0 {
            Util.showIndicator()
        }
        DispatchQueue.global(qos: .background).async {

            APIService.shared.getBestSellersList { results, error in
                
                DispatchQueue.main.async {
                    Util.hideIndicator()
                    if results != nil {
                        self.data = results!
                        self.tableView.reloadData()
                        return
                    }
                    Util.showError(text: error ?? "Unkwon Error !")
                }
            }
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
        
        var noSearchData = false
        if self.searchText.count > 0 && self.searchData.count == 0 {
            noSearchData = true
        }
        self.refreshScreen(isNoData: noSearchData)
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            if self.searchData.count == 0 {
                return DefaultTableViewCell()
            }
            cell.textLabel?.text = self.searchData[indexPath.row].display_name

        }else{
            cell.textLabel?.text = self.data[indexPath.row].display_name

        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.isActive = false 

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
