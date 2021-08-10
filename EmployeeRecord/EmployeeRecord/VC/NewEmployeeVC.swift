//
//  NewEmployeeVC.swift
//  EmployeeRecord
//
//  Created by Malin Chhan on 7/8/21.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import ObjectMapper

class NewEmployeeVC: BaseVC {
    
    var titles:[String] = ["First name*","Middle Name","Last Name*", "Province / City*","","Gender*","DOB","","Favorite book*"]
    var titleLbl : UILabel!
    var screenHeight:CGFloat = 0
    var allTextFields:[SkyFloatingLabelTextField] = []
    var scrollView : UIScrollView!
    var imagePicker : UIImagePickerController!
    var imageView : UIImageView!
    var datePickerDOB : UIDatePicker!
    var  genderDropDown : DropDown!
    var textViewAddress : UITextView!
    var textViewHobby : UITextView!
    var imageData:Data?
    var employee:Employee?

    let dateFormater = DateFormatter.getDateFormatterWith(format:"dd MMMM yyyy")
    var allowEditing = true
    var deletedButton : UIButton!
    public var onDataUpdatedOrCreated:(()->Void)?

    
    // MARK: - Main functions

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Employee"
        if self.employee != nil {
            self.title = "Employee detail"
        }
        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.modalPresentationStyle = .fullScreen
  
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenBound.width, height: screenBound.height))
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        if self.employee != nil{ //view mode
            allowEditing = false
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.refreshToEdit))

        }else{
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(actionButtonClicked(sender:)))

        }
        self.setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavoriteBook), name: Notification.Name("RefreshBookSelected"), object: nil)


    }
    @objc func refreshFavoriteBook(){
        if let selectedBook = AppManager.shared.selectedBook  {
            //update employee book
            self.employee?.book = selectedBook.title
            self.allTextFields[titles.count - 1].text = selectedBook.title
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        AppManager.shared.selectedBook = nil
    }
    @objc func refreshToEdit(){
        allowEditing = true
        self.refreshToEditOrView()

    }
    @objc func refreshToEditOrView(){
        
        imageView.isUserInteractionEnabled = allowEditing
        allTextFields.forEach { tf in
            tf.isUserInteractionEnabled = allowEditing
        }
        textViewHobby.isEditable = allowEditing
        textViewAddress.isEditable = allowEditing
        if allowEditing == true {
            allTextFields[0].becomeFirstResponder()
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: allowEditing == true ? .save : .edit, target: self, action: #selector(actionButtonClicked(sender:)))

        }else{
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.refreshToEdit))

        }

        self.deletedButton.isHidden = !allowEditing

    }
   
    func setupView(){
        var yView:CGFloat = 20

        imageView = UIImageView(frame: CGRect(x:screenBound.width/2 - 50, y:yView , width: 120, height: 120))
        imageView.image = UIImage(named: "default-user")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageProfileClicked(sender:))))
        imageView.isUserInteractionEnabled = allowEditing
        scrollView.addSubview(imageView)
        yView += 130

        for (i, text) in self.titles.enumerated() {
            let textField = Util.shared.getFloatingTextFieldWith(frame: CGRect(x: 20, y: yView, width: screenBound.width - 40, height: 65), placeholder: text, title: text)
            textField.delegate = self
            textField.tag = i
            textField.isUserInteractionEnabled = allowEditing
            scrollView.addSubview(textField)
            if i == 3 || i == 5 || i == 8{
                let downButton = self.getDownButton()
                textField.rightView =  downButton
                textField.rightViewMode = .always
                if i == 5 { //gender drop down
                    self.updateDropDown(textField: textField)
                    
                }
            }else if i == 6 { //DOB , add date picker
                self.addDatePickerForTextfield(textfield: textField )
            }
            
            allTextFields.append(textField)
            
            if i == 4 || i == 7 { //address and hobby
                textField.isEnabled = false
                
                let titleText = (i == 4) ? "Address":"Hobby"
                let titleLbl = UILabel(frame: CGRect(x: 20, y: yView , width:screenBound.width - 40, height:20))
                titleLbl.text = titleText
                titleLbl.textColor = UIColor.black
                scrollView.addSubview(titleLbl)
                yView += 30


                let textview = self.getTextview(frame: CGRect(x: 20, y: yView , width:screenBound.width - 40, height:90))
                textview.isEditable = allowEditing

                if i == 4 { //address
                    textViewAddress = textview
                }else if  i == 7 { //hobby
                    textViewHobby = textview
                }

                scrollView.addSubview(textview)
                
                yView += textview.frame.size.height + 15

                
            }else{
                yView += 85

            }

        }
        yView += 30

        
        

        if self.employee != nil && self.allowEditing == false {
            deletedButton = UIButton(frame: CGRect(x: 20, y: yView, width: screenBound.width - 40, height: 50))
            deletedButton.addTarget(self, action: #selector(self.deleteClicked(sender:)), for: .touchUpInside)
            scrollView.addSubview(deletedButton)
            //show delete button
            deletedButton.setButtonWith(backgroundColor: UIColor.red, textColor:.white , text: "Delete", fontSize: 18, isRound: true)
            deletedButton.isHidden = true

        }
        
        yView += 80
        screenHeight = yView

        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: yView)
        
        if self.employee != nil{
            //show employee detail info
            
            if let dataProfile = AppManager.shared.getMediaData(pathName: "image" + "\(employee?.id ?? 0)"){
                employee?.imageData = dataProfile
                imageView.image = UIImage(data: dataProfile)
                imageData = dataProfile
            }
            allTextFields[0].text = employee?.firstName
            allTextFields[1].text = employee?.middleName
            allTextFields[2].text = employee?.lastName
            allTextFields[3].text = employee?.provinceOrCity
            allTextFields[5].text = employee?.gender
            allTextFields[8].text = employee?.book
            
            //address and hobby
            textViewAddress.text = employee?.address
            textViewHobby.text = employee?.hobby
            
            if let dob = employee?.dob {
                let dobDate = Util.shared.getDateFromString(dateStr: dob)
                datePickerDOB.date  = dobDate
                allTextFields[6].text = dateFormater.string(from: dobDate)

            }
        }
        
    }
    @objc func imageProfileClicked(sender:UITapGestureRecognizer) {
        
        Util.shared.showPickImageAlert(on: self, cameraAction: {
            //show camera
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }, browsAction: {
            //show gallery
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }) {
            //cancel click
        }
    }
    func getTextview(frame:CGRect)->UITextView{
        let textView = UITextView(frame: frame)
        textView.delegate = self
        textView.isEditable = true
        textView.textColor = .black
//        textView.isScrollEnabled = true
//        textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        textView.layer.cornerRadius = 10
        // to remove left padding
//        textView.textContainerInset = UIEdgeInsets.zero
//        textView.textContainer.lineFragmentPadding = 0
        
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.autocorrectionType = .no
        
        
        //maximum 4 lines
        textView.textContainer.maximumNumberOfLines = 6
//        textView.textContainer.lineBreakMode = .byWordWrapping
        
        return textView
        
    }
    
    func getDownButton()->UIButton{
       let downButton = UIButton(frame:CGRect(x: 0, y: 30, width: 30, height: 50))
       downButton.contentMode  = .scaleAspectFit
       downButton.setImage(UIImage(named: "ic_dropdown")?.withRenderingMode(.alwaysTemplate), for: .normal)
       downButton.imageView?.tintColor = .gray
       downButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 15)
       downButton.addTarget(self, action: #selector(self.showDropDown(sender:)), for: .touchUpInside)
       downButton.backgroundColor = .clear
       
       return downButton
   }
    func updateDropDown(textField:SkyFloatingLabelTextField){
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.selectionBackgroundColor = .lighterGrayColor()
        dropDown.dataSource = ["Male", "Female"]
        genderDropDown = dropDown
        genderDropDown.anchorView = textField
        genderDropDown.bottomOffset = CGPoint(x: 0, y: textField.bounds.height)
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item)  -- index: \(index)")
           
            self.allTextFields[5].text = item
        }
        
        genderDropDown.width = textField.frame.width
        scrollView.addSubview(genderDropDown)
        
    }
    @objc func showDropDown(sender:UIButton){
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.hideAllKeyboards()
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: screenHeight )

    }
    @objc func hideAllKeyboards(){
        self.view.endEditing(true)
        allTextFields.forEach { tf in
            tf.resignFirstResponder()
        }
        textViewAddress.resignFirstResponder()
        textViewHobby.resignFirstResponder()
    }

    @objc func deleteClicked(sender:UIButton){
        self.hideAllKeyboards()
        self.showAlertMessage(title: nil, message: "Delete this employee ?", actionTitle: "Delete") {
            //delete local data
            DataManager.shared.removeEmployee(employee: self.employee!)
            self.navigationController?.popViewController(animated: false)
        }
    }
    @objc func actionButtonClicked(sender:UIButton){
        //    • Profile Image* 
        //    • First Name*  
        //    • Middle Name
        //    • Last Name*
        //    • Province / City*
        //    • Address
        //    • Gender*
        //    • DOB
        //    • Hobby
        //    • Favorite book*
            
            /*
             1. (*)thisfieldismandatory.
             2. Address and Hobby should be multiple line text input with 4-line max.
             3. Province/CityandFavoritebookshouldbesearchableanddisplayasapopover
             over the text field. Please define the list of Province / City by yourself
             
             */
        
        if imageData == nil {
            Util.showError(text: "Profile image is required !")
            return
        }
        for tf in allTextFields {
            if tf.placeholder == "" || tf.tag == 1 || tf.tag == 4 || tf.tag == 6 || tf.tag == 7 {
                continue
            }
            if self.checkTextField(textField: tf) == false {
                return
            }

        }
        
        var jsonData:[String:String] = [
            "firstName":allTextFields[0].text!,
            "middleName":allTextFields[1].text!,
            "lastName":allTextFields[2].text!,
            "provinceOrCity":allTextFields[3].text!,
            "address":textViewAddress.text ?? "",
            "gender":allTextFields[5].text!,
            "hobby":textViewHobby.text ?? "",
            "book":allTextFields[8].text!,
        ]
        if let dob = allTextFields[6].text , dob.count > 0{
            let newDateFormatter = DateFormatter.getDateFormatterWith(format: "yyyy-MM-dd")
            jsonData["dob"] = newDateFormatter.string(from: datePickerDOB.date)
        }
        
//        print("json data: \(jsonData)")

        if let currentEmployee = Mapper<Employee>().map(JSON:jsonData) {
            self.hideAllKeyboards()
            
            if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
                let imageFileName =  DataKey.employeeProfile.rawValue
                if employee == nil { //new employee
                    let count = DataManager.shared.countEmployees()
                    currentEmployee.id = count
                    AppManager.shared.saveMediaData(pathName: imageFileName + "\(count)", data: data)

                }else{
                    AppManager.shared.saveMediaData(pathName: imageFileName + "\(employee!.id)", data: data)

                }
              
            }
            if employee != nil {
                currentEmployee.id = employee!.id
                currentEmployee.created_at = employee?.created_at
            }
            
            DataManager.shared.addEmployee(employee: currentEmployee)
            if employee == nil {
                self.navigationController?.popViewController(animated: false)
            }else{
//                Util.showToast(text: "Employee information updated !")
                self.allowEditing = false
                self.refreshToEditOrView()
                
            }
            self.onDataUpdatedOrCreated!()
        }
                
    }

    func addDatePickerForTextfield(textfield:SkyFloatingLabelTextField, from : Date = Date(), to: Date = Date()){
        
        let datePicker = UIDatePicker(frame:CGRect(x: 0, y:0, width: self.view.frame.size.width, height: 200))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = TimeZone(identifier: "Asia/Phnom Penh")
        datePicker.center = view.center
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 100, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
       
        datePicker.locale = NSLocale(localeIdentifier: "en") as Locale
        let today = Date()
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: today)
        datePicker.maximumDate = today
        datePicker.tag  = textfield.tag
        textfield.inputView = datePicker
        datePickerDOB = datePicker
        
        //add toolbar to textfield keyboard
        textfield.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.doneToolbarClicked(sender:))), onCancel: (target: self, action: #selector(self.hideAllKeyboards)))
   }
    @objc func doneToolbarClicked(sender: UIBarButtonItem) {
        self.hideAllKeyboards()
        allTextFields[6].text = dateFormater.string(from: datePickerDOB.date)
     
    }
   
    @objc func datePickerValueChanged(sender:UIDatePicker){
//        let textField = allTextFields[sender.tag]
            print("date changed: \(dateFormater.string(from: sender.date))")
//        textField.text = dateFormater.string(from: sender.date)
        datePickerDOB.date = sender.date
            
    }
}
extension NewEmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
//        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage //if allow editing = true
        let editedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageData  = editedImage.jpegData(compressionQuality: 0.5)
        if imageData == nil {
            return
        }
        let newImage = UIImage(data: imageData!)
        DispatchQueue.main.async {
            self.imageView.image = newImage

        }
       
    }
   
}
   
extension NewEmployeeVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 5 ||  textField.tag == allTextFields[titles.count - 1].tag || textField.tag == 3 {
            self.hideAllKeyboards()
            textFieldDidBeginEditing(textField)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 { //show provinces/city list
            self.hideAllKeyboards()

            let provincesVC =  ProvincesVC()
            provincesVC.onProvinceSelected = { provinceSelected  in
                self.allTextFields[3].text = provinceSelected
            }
            let nav = UINavigationController(rootViewController: provincesVC)
            self.present(nav, animated: false, completion: nil)
            
        }
        if textField.tag == 5 || textField.tag == 6 {
            if textField.tag == 5 {
                self.hideAllKeyboards()
                genderDropDown.show()
            }
            self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: screenHeight )

            return
        }
        if textField.tag == allTextFields[titles.count - 1].tag { //go to book lists screen
            self.hideAllKeyboards()
            
            if self.employee != nil{
                AppManager.shared.selectedBook = DataManager.shared.getBookFor(title: self.employee?.book ?? "")
            }
            let nav = UINavigationController(rootViewController: BestSellersVC())
            self.present(nav, animated: false, completion: nil)
            return
        }
      
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: screenHeight + 320)

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.allTextFields {
            textField.resignFirstResponder()
        }
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: screenHeight )
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
           
           return true
    }
}
extension NewEmployeeVC:UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: screenHeight + 320)

    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        true
    }
}
