//
//  BooksVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 9/8/21.
//

import UIKit

class BooksVC: BaseVC {

    var list_name:String?
    var list_name_encoded:String?

    var data:[Book] = []
    var searchData:[Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = list_name ?? "List detail"

        self.addTableViewAndSearchBar()
        if self.list_name != nil {
            self.data = DataManager.shared.getAllBooksFor(list_name: self.list_name!)
            if self.data.count > 0 {
                self.tableView.reloadData()
            }
        }
        self.requestData()
    }
    
  
    func requestData(){
        if let listName = self.list_name_encoded {
        
            print("list name: \(listName)")
            if self.data.count == 0 {
                Util.showIndicator()
            }
            DispatchQueue.global(qos: .background).async {
                APIService.shared.getDetailBestSellers(list_name_encoded: listName) { results, error in
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
    }
    override func updateSearchResults(for searchController: UISearchController) {
        self.searchData.removeAll()

        if let search = searchController.searchBar.text {
            searchText = search
//            print("search text : \(search)")

            self.searchData = self.data.filter({ (item) -> Bool in
                 return (item.title?.lowercased().contains(searchText.lowercased()))!
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
        return 70
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DefaultTableViewCell(style: .subtitle, reuseIdentifier:cellID)
        var book:Book = self.data[indexPath.row]
        if self.searchText.count > 0 {
            book = self.searchData[indexPath.row]
        }

        cell.textLabel?.text = book.title
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.textColor = .black
        cell.textLabel?.numberOfLines = 2

        cell.detailTextLabel?.text = "Author: \(book.author ?? "")"
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 15)
        cell.detailTextLabel?.numberOfLines = 2
        
        cell.accessoryType = .none
        if let selectedBook = AppManager.shared.selectedBook {
            if selectedBook.title == book.title {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book = self.data[indexPath.row]
        if self.searchText.count > 0 {
            book = self.searchData[indexPath.row]
        }
        AppManager.shared.selectedBook = book
        self.tableView.reloadData()
    }
    
}
