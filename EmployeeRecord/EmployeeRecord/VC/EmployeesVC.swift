//
//  EmployeesVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class EmployeesVC: BaseVC {
    var employeeCellID = "employeeCellID"
    var data:[Employee] = []


    // MARK: - Main functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = .defaultBlueColor()
        
        self.title = "Employees"
        self.addTableView(frame: screenBound, style: .plain)
        self.tableView.register(EmployeeCell.self, forCellReuseIdentifier: employeeCellID)
        
        self.tableView.tableFooterView  = UIView()

        //add plus button
        let plusBtn = UIButton(frame: CGRect(x: screenBound.width - 90, y: screenBound.height - 120, width: 60, height: 60))
        plusBtn.setButtonWith(backgroundColor: .systemBlue, textColor: .white, text: "+", fontSize: 50)
        plusBtn.clipsToBounds = true
        plusBtn.layer.cornerRadius = plusBtn.frame.width/2
        plusBtn.addTarget(self, action: #selector(self.addNewEmployee), for: .touchUpInside)
        self.view.addSubview(plusBtn)
        
//        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewEmployee))
        self.refreshDataFromLocalDB()

    }
    func refreshDataFromLocalDB (){
        //get data from local db
        self.data = DataManager.shared.getAllEmployees()
    
        self.tableView.reloadData()
        if data.count == 0 {
            self.tableView.backgroundView = UILabel(text: "No Employee", font: .systemFont(ofSize: 16), color: .black, textAlignment: .center, numberOfLines: 1)
        }else{
            self.tableView.backgroundView  = UILabel()

        }
    }
    @objc func addNewEmployee(){
        let vc  = NewEmployeeVC()
        vc.onDataUpdatedOrCreated = {
            self.refreshDataFromLocalDB()
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellID, for: indexPath) as! EmployeeCell
        cell.employee = self.data[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NewEmployeeVC()
        detailVC.onDataUpdatedOrCreated = {
            self.refreshDataFromLocalDB()
        }
        detailVC.employee = self.data[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: false)
    }

   
}
