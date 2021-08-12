//
//  ProvincesVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 10/8/21.
//

import UIKit

class ProvincesVC: BaseVC {

    public var onProvinceSelected:((String)->Void)?
    var provinceSelected:String = ""
    var data:[String] = AppManager.shared.provincesAndCity.sorted()
    var searchData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Province / City"

        self.addTableViewAndSearchBar()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissScreen))
        
    }
    
    @objc override func doneClicked(){
        if provinceSelected == "" {
            Util.showError(text: "Please select province / city")
            return
        }
        self.searchController.isActive = false //avoid crash when search is active 
        self.onProvinceSelected!(provinceSelected)
        self.dismiss(animated: false, completion: nil)
    }
    
  
    override func updateSearchResults(for searchController: UISearchController) {
        self.searchData.removeAll()

        if let search = searchController.searchBar.text {
            searchText = search
//            print("search text : \(search)")

            self.searchData = self.data.filter({ (item) -> Bool in
                return (item.lowercased().contains(searchText.lowercased()))
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchText.count > 0 {
            return self.searchData.count
        }
        return self.data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellID , for: indexPath)  as! DefaultTableViewCell
        var province = self.data[indexPath.row]
        if self.searchText.count > 0 {
            province = self.searchData[indexPath.row]
        }

        cell.textLabel?.text = province
        cell.textLabel?.textColor = .black

        cell.accessoryType = .none
        if provinceSelected == province {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var province = self.data[indexPath.row]
        if self.searchText.count > 0 {
            province = self.searchData[indexPath.row]
        }
        self.tableView.reloadData()
        provinceSelected = province
    }
}
