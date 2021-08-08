//
//  EmployeeCell.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class EmployeeCell: DefaultTableViewCell {

    let profileImageView = UIImageView(cornerRadius: 40, image: #imageLiteral(resourceName: "default-user"))
    let nameLbl = UILabel(text: "Name", font: .systemFont(ofSize: 14))
    let dateLbl = UILabel(text: "Date", font: .systemFont(ofSize: 12))
    let dateFormater = DateFormatter.getDateFormatterWith(format:"dd MMM yyyy hh:mm a")
    
    var employee:Employee?{
        didSet{
            let middleName = ((employee?.middleName.count)! > 0) ? (employee!.middleName + " ") : ""
            self.nameLbl.text = (employee?.firstName)! + " " +  middleName + employee!.lastName
            
            if employee!.imageData.count > 0 {
                profileImageView.image = UIImage(data: employee!.imageData)
            }else{
                if let dataProfile = AppManager.shared.getMediaData(pathName: "image" + "\(employee?.id ?? 0)"){
                    employee?.imageData = dataProfile
                    profileImageView.image = UIImage(data: dataProfile)
                }
            }
            let date = Util.shared.getDateFromString(dateStr: employee?.updated_at ?? "")
            dateLbl.text = dateFormater.string(from: date)
        }
    }

    override func setupContents() {
        self.textLabel?.textColor = UIColor.black
        backgroundColor = .white
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.contentMode = .scaleAspectFill
        
        nameLbl.textColor =  UIColor.black
        dateLbl.textColor = .darkGray
        dateLbl.constrainHeight(20)
        dateLbl.textAlignment = .right
        
        let verticalStack = VerticalStackView(arrangedSubviews: [
                    UIView(height: 10),
                    nameLbl,
                    dateLbl
                ])
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 10

    
        let stack = UIStackView(arrangedSubviews: [profileImageView,verticalStack])
        stack.spacing = 10
        addSubview(stack)
        stack.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
    }

}
