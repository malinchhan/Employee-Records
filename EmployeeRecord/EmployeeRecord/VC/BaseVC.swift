//
//  BaseVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class BaseVC: UIViewController {
    let screenBound = UIScreen.main.bounds
    var tableView:UITableView!
    var cellID = "cellID"
    var searchController : UISearchController!
    var searchText:String = ""

    // MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

    }
    func addTableViewAndSearchBar(){
        self.addTableView(frame: self.screenBound, style: .plain)
        self.tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: cellID)

        self.setupSearchControlller()
        self.tableView.tableHeaderView = searchController.searchBar

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClicked))
    }
    @objc func doneClicked(){
        if AppManager.shared.selectedBook == nil {
            Util.showError(text: "Please select your favorite book ")
            return
        }
        if self.searchController != nil {
            self.searchController.isActive = false //avoid crash when search is active
        }
        if self is BooksVC || self is Top5BooksVC {
            NotificationCenter.default.post(name: Notification.Name("RefreshBookSelected"), object: nil)
        }
        super.dismiss(animated: false, completion: nil)
    }
    func addTableView(frame:CGRect,style:UITableView.Style){
        
        self.tableView = UITableView(frame: frame, style: style)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .singleLine
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        self.view.addSubview(self.tableView)

    }
    func refreshScreen(isNoData:Bool){
        
        self.tableView.backgroundView  = UILabel()

        if self.searchText.count > 0 {
            if isNoData == true {
                self.tableView.backgroundView = UILabel(text: "No data", font: .systemFont(ofSize: 16), color: .black, textAlignment: .center, numberOfLines: 1)
            }
        }
        self.tableView.reloadData()

    }
    func checkTextField(textField:UITextField) -> Bool {
       
        if textField.text?.trimmingCharacters(in: .whitespaces).count == 0 || textField.text == "" || textField.text == nil {

            var text  = textField.placeholder ?? ""
            if text == "" {
                return true 
            }
            text = text.replacingOccurrences(of: "*", with: "")
            Util.showError(text:text + " is required !")
            if text != "Favorite book" && text != "Province / City"{
                textField.becomeFirstResponder()

            }
            return false
        }
        return true
    }
    func setupSearchControlller(){
        
        self.searchController = UISearchController(searchResultsController: nil)
//        definesPresentationContext = true
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
//        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .minimal
        

        //update textfield font
        let textFieldInSearchBar = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInSearchBar?.font = UIFont.systemFont(ofSize: 18)
        textFieldInSearchBar?.textColor = UIColor.black
        textFieldInSearchBar?.backgroundColor = .lighterGrayColor()
        let placeHolder = textFieldInSearchBar?.value(forKey: "placeholderLabel") as? UILabel
        placeHolder?.font  = UIFont.systemFont(ofSize: 15)
        placeHolder?.textColor = UIColor.gray
        placeHolder?.text = "Search"

//        remove search icon
//        textFieldInSearchBar!.leftViewMode = .never

//        //update cursor color
        searchController.searchBar.tintColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.gray
        
    }
    @objc func dismissScreen(){
        self.dismiss(animated: false, completion: nil)
    }
    @objc func popBack(){
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - Table view data source
extension BaseVC:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DefaultTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
    }
}
extension  BaseVC :  UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
//        print("search text: \(searchController.searchBar.text)")

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
//        print("search text: \(searchBar.text)")
        self.searchText = searchBar.text!
        self.searchController.searchBar.endEditing(true)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
//        print("cancel click")
        searchController.searchBar.showsCancelButton = false

        searchBar.endEditing(true)
        self.view.endEditing(true)
        searchBar.text = ""
        self.searchText = ""
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool{
        searchController.searchBar.showsCancelButton = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 400, right: 0)
        self.tableView.reloadData()

        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
//            print("cross clicked")
            searchBar.resignFirstResponder()
        }
//        print("search text changed: \(searchText)")
    }
    
}
