//
//  BookWithCoverCell.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 11/8/21.
//

import UIKit
import SDWebImage

class BookWithCoverCell: DefaultTableViewCell {

    let coverImageView = UIImageView(cornerRadius: 0, image: #imageLiteral(resourceName: "default-user"))
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 16),numberOfLines: 2)
    let authorLabel = UILabel(text: "", font: .systemFont(ofSize: 15),numberOfLines: 2)
    let desLabel = UILabel(text: "", font: .systemFont(ofSize: 14),numberOfLines: 10)
    
    var book:Book?{
        didSet{
            if let image = book?.book_image {
                self.coverImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "default-book"), options: .continueInBackground, completed: nil)
            }
            
            self.titleLabel.text = book!.title
            self.authorLabel.text = "Author: \(book?.author ?? "")"
            
            if  let des = book?.description, des.count > 0 , des != ""{
                self.desLabel.text = "Description:  \(des)"
            }else{
                self.desLabel.text = ""
            }
           
        }
    }
    
    override func setupContents() {
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.constrainWidth(100)
        coverImageView.constrainHeight(130)
        
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        
        authorLabel.textColor = .darkGray
        authorLabel.font = .systemFont(ofSize: 15)
        
        desLabel.textColor = .gray
        desLabel.font = .systemFont(ofSize: 14)
        
        
        let verticalStack = VerticalStackView(arrangedSubviews: [
            titleLabel,
            authorLabel,
            desLabel
                ])
//        verticalStack.distribution = .fillProportionally
        verticalStack.spacing = 5


        let stack = UIStackView(arrangedSubviews: [coverImageView,verticalStack])
        stack.spacing = 10
        addSubview(stack)
        stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 20))
        
    }

}
