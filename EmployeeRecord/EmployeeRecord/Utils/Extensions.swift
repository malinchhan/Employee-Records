//
//  Extensions.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 8/8/21.
//
import UIKit
import Foundation


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
    static func defaultBlueColor() -> UIColor {
        return Util.colorHexString(hex: "007AFF")
    }
    
}
extension UIButton {
    func setButtonWith(backgroundColor:UIColor, textColor:UIColor,text:String,fontSize:CGFloat, isRound:Bool? = false){
        self.backgroundColor = backgroundColor
        self.setTitleColor(textColor, for: .normal)
        self.setTitleColor(textColor, for: .selected)
        self.setTitle(text, for: .normal)
        self.setTitle(text, for: .selected)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
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
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
extension UILabel {

    convenience init(text: String, font: UIFont? = UIFont.systemFont(ofSize: 15), color: UIColor? = .black, textAlignment: NSTextAlignment? = .left, numberOfLines: Int? = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = textAlignment!
        self.numberOfLines = numberOfLines!
    }

}
extension UIImageView {
    convenience init(cornerRadius: CGFloat, image: UIImage?) {
        self.init(image: nil)
        self.image = image
        self.tintColor = .black
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
}
extension DateFormatter {
   
    static func getDateFormatterWith(format:String)-> DateFormatter{
          let dateFormater = DateFormatter()
          dateFormater.dateFormat = format
          dateFormater.locale =  NSLocale(localeIdentifier: "en") as Locale //NSLocale(localeIdentifier: "km") as Locale
          return dateFormater
    }
}
extension UIView {
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
    func centerInSuperview(sizeMultiplier width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if let superviewWidthAnchor = superview?.widthAnchor {
            widthAnchor.constraint(equalTo: superviewWidthAnchor, multiplier: width).isActive = true
        }
        
        if let superviewHeightAnchor = superview?.heightAnchor {
            heightAnchor.constraint(equalTo: superviewHeightAnchor, multiplier: height).isActive = true
        }
    }
    
    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    
    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
    
    func constrainWidth(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constrainHeight(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
  
    convenience init(_ backgroundColor: UIColor){
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    convenience init(_ backgroundColor: UIColor, w: CGFloat){
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.constrainWidth(w)
        
    }
    convenience init(_ backgroundColor: UIColor, w: CGFloat, h: CGFloat){
          self.init(frame: .zero)
          self.backgroundColor = backgroundColor
          self.constrainHeight(h)
          self.constrainWidth(w)
          
      }
    convenience init(_ backgroundColor: UIColor, h: CGFloat){
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.constrainHeight(h)
        
    }
    
    convenience init(width: CGFloat?){
        self.init(frame: .zero)
        if let w = width {
            self.constrainWidth(w)
        }
    }
    
    convenience init(height: CGFloat?){
        self.init(frame: .zero)
        if let h = height {
            self.constrainHeight(h)
        }
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...){
        views.forEach{addArrangedSubview($0)}
    }
}
extension UIViewController {
    func showAlertMessage(title:String?, message: String? , actionTitle:String?, handler:@escaping ()->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: (actionTitle != nil) ? actionTitle:"OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            handler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
