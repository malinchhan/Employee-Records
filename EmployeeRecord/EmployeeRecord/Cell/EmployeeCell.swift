//
//  EmployeeCell.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit

class EmployeeCell: DefaultTableViewCell {

    let profileImageView = UIImageView(cornerRadius: 40, image: #imageLiteral(resourceName: "default-user"))
    let nameLbl = UILabel(text: "Name", font: .systemFont(ofSize: 16),numberOfLines: 2)
    let genderLbl = UILabel(text: "Female", font: .systemFont(ofSize: 14))

    let dateLbl = UILabel(text: "Date", font: .systemFont(ofSize: 14))
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
            genderLbl.text = employee?.gender
            
            let date = Util.shared.getDateFromString(dateStr: employee?.updated_at ?? "")
            dateLbl.text = dateFormater.string(from: date)
        }
    }

    override func setupContents() {
        self.textLabel?.textColor = UIColor.black
        backgroundColor = .white
        self.profileImageView.frame = CGRect(x: 20, y: 10, width: 80, height: 80)
        self.addSubview(profileImageView)
        
        self.nameLbl.frame = CGRect(x: 110, y: 10, width: screenBound.width - 120, height: 25)
        self.addSubview(nameLbl)

        self.genderLbl.frame = CGRect(x: 110, y: 35, width: screenBound.width - 120, height: 25)
        self.addSubview(genderLbl)

        self.dateLbl.frame = CGRect(x: 110, y: 60, width: screenBound.width - 120, height: 30)
        self.addSubview(dateLbl)
        
//        profileImageView.constrainWidth(80)
//        profileImageView.constrainHeight(80)
        profileImageView.contentMode = .scaleAspectFill

        nameLbl.textColor =  UIColor.black
        dateLbl.textColor = .darkGray
//        dateLbl.constrainHeight(20)
        dateLbl.textAlignment = .right
//
//        let verticalStack = VerticalStackView(arrangedSubviews: [
//                    nameLbl,
//                    genderLbl,
//                    dateLbl
//                ])
//        verticalStack.distribution = .fillEqually
//        verticalStack.spacing = 10
//
//
//        let stack = UIStackView(arrangedSubviews: [profileImageView,verticalStack])
//        stack.spacing = 10
//        addSubview(stack)
//        stack.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
        
      


    }

}
