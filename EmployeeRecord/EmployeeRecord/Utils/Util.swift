//
//  Util.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit
import  SkyFloatingLabelTextField

class Util: NSObject {
    public static let shared = Util()

   
    func updateTintColor(textField:SkyFloatingLabelTextField){
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.titleFont = UIFont.systemFont(ofSize: 15)
        
        textField.tintColor = UIColor.navColor()
        textField.textColor = .black
        textField.lineColor = UIColor.lightGray
        textField.selectedTitleColor = UIColor.navColor()
        textField.selectedLineColor = UIColor.navColor()
        
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

}

extension UIColor {
    static func navColor() -> UIColor {
        return UIColor.systemBlue
    }
    static func lighterGrayColor() -> UIColor {
        return Util.colorHexString(hex: "#FAFAFA")
    }
    static func lightGrayColor() -> UIColor {
        return Util.colorHexString(hex: "#F0F0F0")
    }
}
extension UIButton {
    func setButtonWith(backgroundColor:UIColor, textColor:UIColor,text:String,fontSize:CGFloat, isRound:Bool? = false){
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(textColor, for: .selected)
        self.setTitle(text, for: .normal)
        self.setTitle(text, for: .selected)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        if isRound == true{
            self.layer.cornerRadius = 5
            self.clipsToBounds = true
        }
    }
}
extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: onDone.target, action: onDone.action)
        doneBtn.tag = self.tag
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action:onCancel.action)
        cancelBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.navColor()], for: .normal)
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.navColor()], for: .normal)
        
        toolbar.items = [
            cancelBtn,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneBtn
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: onDone.target, action: onDone.action)
        doneBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.navColor()], for: .normal)
        
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneBtn
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
    
}
