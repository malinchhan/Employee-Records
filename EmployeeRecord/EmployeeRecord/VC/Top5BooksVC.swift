//
//  Top5BooksVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 11/8/21.
//

import UIKit
import ObjectMapper

class Top5BooksVC: BaseVC {

    var data:[BestSeller] = []
    var searchData:[Book] = []
    var sectionsTitle:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top 5 books"
       
        self.addTableViewAndSearchBar()
        
        self.tableView.register(BookWithCoverCell.self, forCellReuseIdentifier: cellID)
        let localData = AppManager.shared.getJsonArrayData(pathName: DataKey.top5BooksFromBestSellers.rawValue)
        if localData.count > 0 {
            self.data = Mapper<BestSeller>().mapArray(JSONArray: localData)
            self.tableView.reloadData()
        }
        self.requestData()
    }
    
    func requestData(){
        
            if self.data.count == 0 {
                Util.showIndicator()
            }
            DispatchQueue.global(qos: .background).async {
                APIService.shared.getTop5BooksFromBestSellersList(handler: { lists, error in
              
                    DispatchQueue.main.async {
                        Util.hideIndicator()

                        if lists != nil {
                            self.data = lists!
                            self.data.forEach { list in
                                if let name = list.display_name {
                                    let first = name.prefix(1)
                                    self.sectionsTitle.append(String(first))
                                }
                            }
                            self.tableView.reloadData()
                            return
                        }
                        Util.showError(text: error ?? "Unkwon Error !")
                    }
                })
            }
        
    }
    override func updateSearchResults(for searchController: UISearchController) {
        self.searchData.removeAll()

        if let search = searchController.searchBar.text {
            searchText = search
//            print("search text : \(search)")

            self.data.forEach { list in
                var booksData:[Book] = []
                if let books = list.books, books.count > 0 {
                    booksData = books
                  
                }else if let books = list.book_details, books.count > 0 {
                    booksData = books
                }
                booksData.forEach {  book in
                    if let isFound =  (book.title?.lowercased().contains(searchText.lowercased())) , isFound == true {
                        let isExist = self.searchData.contains { b in
                            return b.title == book.title
                        }
                        if isExist == false {
                            self.searchData.append(book)
                        }
                    }
                }
            }
            
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
        return 160
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchText.count > 0 {
            return 1
        }
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.searchText.count > 0 {
            return nil
        }
        let list = self.data[section]
        return list.display_name
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchText.count > 0 {
            return 0
        }
        return 40
    }
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchText.count > 0 {
            return self.searchData.count
        }else{
            let list = self.data[section]
            if let books = list.books, books.count > 0 {
                return books.count
            }else if let books = list.book_details, books.count > 0 {
                return books.count
            }
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellID , for: indexPath)  as! BookWithCoverCell
        var book:Book?
        if self.searchText.count > 0 {
            book = self.searchData[indexPath.row]
        }else{
            let list = self.data[indexPath.section]
            if let books = list.books, books.count > 0 {
                book = books[indexPath.row]
            }else if let books = list.book_details, books.count > 0 {
                book = books[indexPath.row]
            }
        }
        
        if book != nil {
            cell.book = book
            cell.accessoryType = .none
            if let selectedBook = AppManager.shared.selectedBook {
                if selectedBook.title == book!.title {
                    cell.accessoryType = .checkmark
                }
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var book:Book?
        if self.searchText.count > 0 {
            book = self.searchData[indexPath.row]
        }else{
            let list = self.data[indexPath.section]
            if let books = list.books, books.count > 0 {
                book = books[indexPath.row]
            }else if let books = list.book_details, books.count > 0 {
                book = books[indexPath.row]
            }
        }
        if book != nil {
            AppManager.shared.selectedBook = book
            self.tableView.reloadData()
        }
    }

}
