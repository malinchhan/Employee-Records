//
//  EmployeesVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class EmployeesVC: UITableViewController {
    var employeeCellID = "employeeCellID"
    var data:[Employee] = []
    

    // MARK: - Main functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employees"
        self.tableView.register(EmployeeCell.self, forCellReuseIdentifier: employeeCellID)
        self.view.backgroundColor = UIColor.white

        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewEmployee))
        
        self.tableView.tableFooterView  = UIView()
    }
    func refreshDataFromLocalDB (){
        //get data from local db
        self.data = DataManager.shared.getAllEmployees()
        self.tableView.reloadData()
        if data.count == 0 {
            self.tableView.backgroundView = UILabel(text: "No Data", font: .systemFont(ofSize: 16), color: .black, textAlignment: .center, numberOfLines: 1)
        }else{
            self.tableView.backgroundView  = UILabel()

        }
    }
    @objc func addNewEmployee(){
        self.navigationController?.pushViewController(NewEmployeeVC(), animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.refreshDataFromLocalDB()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: employeeCellID, for: indexPath) as! EmployeeCell
        cell.employee = self.data[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
