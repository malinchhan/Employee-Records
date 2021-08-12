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
    let titleLabel = UILabel(text: "", font: .systemFont(ofSize: 16),numberOfLines: 0)
    let authorLabel = UILabel(text: "", font: .systemFont(ofSize: 15),numberOfLines: 0)
    let desLabel = UILabel(text: "", font: .systemFont(ofSize: 14),numberOfLines: 0)
    
    var book:Book?{
        didSet{
            if let image = book?.book_image {
                self.coverImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "default-book"), options: .continueInBackground, completed: nil)
            }
            
            if  let title = book?.title, title.count > 0 , title != ""{
                var heightTitle:CGFloat = Util.shared.getHeightForString(string: title, font: desLabel.font, width: screenBound.width - 150)
                if heightTitle < 20 {
                    heightTitle = 20
                }else if heightTitle > 60 {
                    heightTitle = 60
                }

                self.titleLabel.text = title
                self.titleLabel.frame = CGRect(x: 120, y: 10, width: screenBound.width - 150, height: heightTitle)

            }
            if  let author = book?.author, author.count > 0 , author != ""{
                let heightAuthor:CGFloat = Util.shared.getHeightForString(string: author, font: authorLabel.font, width: screenBound.width - 150)
                authorLabel.frame = CGRect(x: 120, y: self.titleLabel.frame.height + 15, width: screenBound.width - 130, height: heightAuthor)

                self.authorLabel.text = "Author: \(author)"
            }else{
                self.authorLabel.text = "Author: "

            }
           
            
            if  let des = book?.description, des.count > 0 , des != ""{
                self.desLabel.text = "Description:  \(des)"
                
                var heightDes:CGFloat = Util.shared.getHeightForString(string: des, font: desLabel.font, width: screenBound.width - 150)
                if heightDes < 20 {
                    heightDes = 20
                }else if heightDes > 160 - self.titleLabel.frame.size.height - self.authorLabel.frame.size.height - 25 {
                    heightDes = 160 - self.titleLabel.frame.size.height - self.authorLabel.frame.size.height - 25
                }
                desLabel.frame = CGRect(x: 120, y:self.authorLabel.frame.origin.y + self.authorLabel.frame.height + 10 , width: screenBound.width - 150, height: heightDes)
            }else{
                self.desLabel.text = ""
            }
           
        }
    }
    
    override func setupContents() {
        var y:CGFloat = 10

//        coverImageView.contentMode = .scaleAspectFit
//        coverImageView.constrainWidth(100)
//        coverImageView.constrainHeight(130)

        coverImageView.frame = CGRect(x: 10, y: 15, width: 100, height: 130)

        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: 120, y: y, width: screenBound.width - 130, height: 20)
        y += 35
        
        authorLabel.textColor = .darkGray
        authorLabel.font = .systemFont(ofSize: 15)
        authorLabel.frame = CGRect(x: 120, y: y, width: screenBound.width - 130, height: 20)
        y += 20

        desLabel.textColor = .gray  
        desLabel.font = .systemFont(ofSize: 14)
        desLabel.frame = CGRect(x: 120, y: y, width: screenBound.width - 150, height: 20)

        self.addSubview(coverImageView)
        self.addSubview(titleLabel)
        self.addSubview(authorLabel)
        self.addSubview(desLabel)
        
//        let verticalStack = VerticalStackView(arrangedSubviews: [
//            titleLabel,
//            authorLabel,
//            desLabel
//                ])
//        verticalStack.distribution = .fillProportionally
//        verticalStack.spacing = 5
//
//
//        let stack = UIStackView(arrangedSubviews: [coverImageView,verticalStack])
//        stack.spacing = 10
//        addSubview(stack)
//        stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 30))


    }

}
