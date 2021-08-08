//
//  Util.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit
import  SkyFloatingLabelTextField
import FTIndicator
import TSMessages

class Util: NSObject {
    public static let shared = Util()

   
    func updateTintColor(textField:SkyFloatingLabelTextField){
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.titleFont = UIFont.systemFont(ofSize: 15)
        
        textField.tintColor = UIColor.defaultBlueColor()
        textField.textColor = .black
        textField.lineColor = UIColor.lightGray
        textField.selectedTitleColor = UIColor.defaultBlueColor()
        textField.selectedLineColor = UIColor.defaultBlueColor()
        
        textField.lineHeight = 0.5 // bottom line height in points
        textField.selectedLineHeight = 1.0
    }
    func getFloatingTextFieldWith(frame:CGRect,placeholder:String,title:String)->SkyFloatingLabelTextField{
        
        let textField = SkyFloatingLabelTextField(frame: frame)
        textField.placeholder = placeholder
        textField.title = title
        textField.rightViewMode = .always
        self.updateTintColor(textField: textField)
        return textField
    }
    public static func colorHexString (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.range(of: "#") != nil){
            cString.remove(at: cString.firstIndex(of: "#")!)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func getDefaultDateStringFromDate(date: Date) -> String {
        let dateFormater = self.getDateFormatter()
        return dateFormater.string(from: date)
        
    }
    func getDateFormatter(no_time:Bool? = false)-> DateFormatter{
        let dateFormater = DateFormatter()
        if no_time == false {
            dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            dateFormater.dateFormat = "yyyy-MM-dd"
        }
        dateFormater.timeZone = NSTimeZone.init(name: "Asia/Phnom_Penh") as TimeZone?
        dateFormater.locale = NSLocale(localeIdentifier: "en") as Locale
//        dateFormater.locale = NSLocale(localeIdentifier: "km") as Locale //khmer locale

        return dateFormater
    }
    func getDateFromString(dateStr: String) -> Date {
        var noTime = false
        if dateStr.count == 10 {
            noTime = true
        }
        let dateFormater = self.getDateFormatter(no_time: noTime)
        if let date = dateFormater.date(from: dateStr) {
            return date
        }
        
        return Date()
        
    }
   
    func showPickImageAlert(on: UIViewController, cameraAction:@escaping ()->(), browsAction:@escaping ()->(), cancelAction:@escaping ()->()){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            cancelAction()
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in
            cameraAction()
        }
        let browse = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in
            browsAction()
        }
        alertController.addAction(camera)
        alertController.addAction(browse)
        alertController.addAction(cancel)
        
        camera.setValue(UIColor.defaultBlueColor(), forKey: "titleTextColor")
        browse.setValue(UIColor.defaultBlueColor(), forKey: "titleTextColor")
        on.present(alertController, animated: false, completion: nil)
        
    }
    
      public  static func showIndicator(text:String = ""){
          DispatchQueue.main.async {
               FTIndicator.showProgress(withMessage:text, userInteractionEnable: false)
          }
          
      }
    public static func hideIndicator(){
        DispatchQueue.main.async {
            FTIndicator.dismissProgress()
        }
    }
      public  static func showToast(text:String = ""){
          DispatchQueue.main.async {
              FTIndicator.showToastMessage(text)
          }
          
      }
      public  static func showError(text:String = ""){
          DispatchQueue.main.async {
//              FTIndicator.showError(withMessage:text)
              TSMessage.showNotification(in: UIApplication.topViewController(), title: text, subtitle: "", type: .error)
          }
          
      }
   
}

class VerticalStackView: UIStackView {

    init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
        super.init(frame: .zero)
        arrangedSubviews.forEach{addArrangedSubview($0)}
        self.spacing = spacing
        self.axis = .vertical
    }
    func addBackground(color: UIColor, radius: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.layer.cornerRadius = radius
        subView.clipsToBounds = true
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
