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
        
        self.addTableView(frame: self.screenBound, style: .plain)
        self.tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: cellID)
        self.title = "Select favorite book"

        self.setupSearchControlller()
        self.tableView.tableHeaderView = searchController.searchBar

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))

        if self.list_name != nil {
            self.data = DataManager.shared.getAllBooksFor(list_name: self.list_name!)
            if self.data.count > 0 {
                self.tableView.reloadData()
            }
        }
        self.requestData()
    }
    @objc func doneClicked(){
        NotificationCenter.default.post(name: Notification.Name("RefreshBookSelected"), object: nil)
        super.dismiss(animated: false, completion: nil)
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: false)
    }
    func requestData(){
        if let listName = self.list_name_encoded {
        
            print("list name: \(listName)")
            Util.showIndicator()
            APIService.shared.getDetailBestSellers(list_name_encoded: listName) { results, error in
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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

        cell.detailTextLabel?.text = "Author: \(book.author ?? "")"
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 15)

        cell.accessoryType = .none
        if let selectedBook = DataManager.shared.selectedBook {
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
        DataManager.shared.selectedBook = book
        self.tableView.reloadData()
    }
    
}
