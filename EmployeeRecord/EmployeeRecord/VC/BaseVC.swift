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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

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
