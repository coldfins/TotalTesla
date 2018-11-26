//
//  RegisterUserVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/11/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire

class RegisterUserVC: UIViewController,UIGestureRecognizerDelegate, NVActivityIndicatorViewable, UITextFieldDelegate {
    
    @IBOutlet weak var lblEmailError: UILabel!
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var viewGenderOption: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var swtState: UISwitch!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var swtCity: UISwitch!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var swtCountry: UISwitch!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtreferralCode: UITextField!
    @IBOutlet weak var txtrefPH: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var swtRefPermission: UISwitch!
    @IBOutlet weak var actCountry: UIActivityIndicatorView!
    @IBOutlet weak var actState: UIActivityIndicatorView!
    @IBOutlet weak var actCity: UIActivityIndicatorView!
    
    let ageKeyboardview = KeyboardPicker()
    let countriesKeyboardview = KeyboardPicker()
    let statesKeyboardview = KeyboardPicker()
    let cityKeyboardview = KeyboardPicker()
    
    var gender = "Male"
    var scrViewTag = 0
    var currentViewTag = 0
    
    var arrCountries : NSMutableArray = NSMutableArray()
    var arrCountriesIDs : NSMutableArray = NSMutableArray()
    var cId = ""
    
    var arrStates : NSMutableArray = NSMutableArray()
    var arrStatesIDs : NSMutableArray = NSMutableArray()
    var sId = ""
    
    var arrCity : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        scrViewTag = 13
        self.navigationController?.isNavigationBarHidden = false
        setDesign()
        self.getAllCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getAllCountries() {
        txtCountry.isEnabled = false
        actCountry.startAnimating()

        utils.callAPI(url: COUNTRYURL, method: .get, params: nil, completionHandler: {dic in
            let arrCountries : NSDictionary = dic.value(forKey: "result") as! NSDictionary
            for countries in arrCountries.allKeys {
                self.arrCountries.add(arrCountries[countries]!)
                self.arrCountriesIDs.add(countries)
            }
            self.setCountriesPicker()
        })
    }
    
    func setCountriesPicker() {
        self.countriesKeyboardview.Values = self.arrCountries as! [String]
        self.countriesKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.countriesKeyboardview.onDateSelected = { (Value: String) in
            self.txtCountry.text = Value
        }
        txtCountry.isEnabled = true
        actCountry.stopAnimating()
        self.txtCountry.inputView = self.countriesKeyboardview
        setToolbar(txt: self.txtCountry)
    }
    
    func setStatePicker() {
        self.statesKeyboardview.Values = self.arrStates as! [String]
        self.statesKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.statesKeyboardview.onDateSelected = { (Value: String) in
            self.txtState.text = Value
        }
        txtState.isEnabled = true
        actState.stopAnimating()
        self.txtState.inputView = self.statesKeyboardview
        setToolbar(txt: self.txtState)
    }
    
    func setCityPicker() {
        self.cityKeyboardview.Values = self.arrCity as! [String]
        self.cityKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.cityKeyboardview.onDateSelected = { (Value: String) in
            self.txtCity.text = Value
        }
        txtCity.isEnabled = true
        actCity.stopAnimating()
        self.txtCity.inputView = self.cityKeyboardview
        setToolbar(txt: self.txtCity)
    }
    
    func getAllStates(countryId: String) {
        txtState.isEnabled = false
        actState.startAnimating()
        utils.callAPI(url: "\(STATEURL)\(countryId)", method: .get, params: nil, completionHandler: {dic in
            
            let arrStates : NSDictionary = dic.value(forKey: "result") as! NSDictionary
            print(arrStates)
            for state in arrStates.allKeys {
                self.arrStates.add(arrStates[state]!)
                self.arrStatesIDs.add(state)
            }
            self.setStatePicker()
        })
    }
    
    func getAllCity(countryId: String, stateId: String) {
        txtCity.isEnabled = false
        actState.startAnimating()
        let sID = stateId.replacingOccurrences(of: "\"", with: "")
        print("\(CITYURL)\(countryId)&stateId=\(sID)")
        utils.callAPI(url: "\(CITYURL)\(countryId)&stateId=\(sID)", method: .get, params: nil, completionHandler: {dic in
            let arrCity : AnyObject = dic.value(forKey: "result") as AnyObject
            if(arrCity.count > 0){
                let arrCity1 : NSDictionary = dic.value(forKey: "result") as! NSDictionary
                for city in arrCity1.allKeys {
                    self.arrCity.add(arrCity1[city]!)
                }
            }
            self.setCityPicker()
        })
    }
    
    @objc func doneLocationPicker (sender:UIBarButtonItem)
    {
        print(sender.tag)
        if(sender.tag == 1) {
            let index = self.arrCountries.index(of: self.txtCountry.text!)
            let id = self.arrCountriesIDs.object(at: index) as! String
            self.cId = id
            self.getAllStates(countryId: id)
        } else if (sender.tag == 2){
            let index = self.arrStates.index(of: self.txtState.text!)
            let id = self.arrStatesIDs.object(at: index) as! String
            self.getAllCity(countryId: self.cId, stateId: id)
        }
        self.txtCountry.resignFirstResponder()
        self.txtState.resignFirstResponder()
        self.txtCity.resignFirstResponder()
    }
    
    @objc func donePicker (sender:UIBarButtonItem){
         self.txtAge.resignFirstResponder()
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem){
        self.txtCountry.resignFirstResponder()
        self.txtAge.resignFirstResponder()
        self.txtState.resignFirstResponder()
        self.txtCity.resignFirstResponder()
    }
    
    func setToolbar(txt: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterUserVC.doneLocationPicker))
        if(txt == txtCountry) {
            doneButton.tag = 1
        } else if (txt == txtState) {
            doneButton.tag = 2
        } else {
            doneButton.tag = 0
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterUserVC.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txt.inputAccessoryView = toolBar
    }
    
    func setDesign()  {
        
        utils.addLineToTextfield(textField: txtUserName, color: .lightGray)
        utils.addLineToTextfield(textField: txtEmail, color: .lightGray)
        utils.addLineToTextfield(textField: txtPassword, color: .lightGray)
        utils.addLineToTextfield(textField: txtAge, color: .lightGray)
        utils.addLineToTextfield(textField: txtCity, color: .lightGray)
        utils.addLineToTextfield(textField: txtState, color: .lightGray)
        utils.addLineToTextfield(textField: txtCountry, color: .lightGray)
        utils.addLineToTextfield(textField: txtreferralCode, color: .lightGray)
        utils.addLineToTextfield(textField: txtrefPH, color: .lightGray)
        
        swtCity.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtState.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtCountry.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtRefPermission.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)
        
        //Dismiss keyboard
        let tapTerm : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        tapTerm.delegate = self
        tapTerm.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapTerm)
        let arrAge = NSMutableArray()
        for i in 18...99{
            arrAge.add(String(i))
        }
        self.ageKeyboardview.Values = arrAge as! [String]
        self.ageKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.ageKeyboardview.onDateSelected = { (Value: String) in
            self.txtAge.text = Value
        }
        self.txtAge.inputView = self.ageKeyboardview
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterUserVC.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterUserVC.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.txtAge.inputAccessoryView = toolBar
    }
    
    //MARK: - KeyBoard Observer Method
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : 0)
  
        if let scrView = self.view.viewWithTag(scrViewTag) as? UIScrollView {
            scrView.contentInset.bottom = adjustmentHeight
            scrView.scrollIndicatorInsets.bottom = adjustmentHeight
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    @objc func tapView(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func swipeback() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:

                if (self.currentViewTag == 6 || self.currentViewTag == 0) {
                    self.navigationController?.popViewController(animated: true)
                } else if let view = self.view.viewWithTag(self.currentViewTag-6){
                    self.currentViewTag = self.currentViewTag-1
                    self.view.bringSubview(toFront: view)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func onClick_Next(_ sender: UIButton) {
        self.currentViewTag = sender.tag
        if ValidateTextField(tag: sender.tag){
            if sender.tag == 12{
                self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
                let url = "\(BaseURL)\(register)"
                let requestURL: URL = URL(string: url)!
                
                let params: [String: Any] = ["email" : txtEmail.text!,
                                             "password" : txtPassword.text!,
                                             "username" : txtUserName.text!,
                                             "gender" : gender,
                                             "country" : txtCountry.text!,
                                             "state" : txtState.text!,
                                             "city" : txtCity.text!,
                                             "age" : txtAge.text!,
                                             "referrelCodePermission" : swtRefPermission.isOn,
                                             "showCountry" : swtCountry.isOn,
                                             "showState" : swtState.isOn,
                                             "showCity": swtCity.isOn,
                                             "referralCode":txtreferralCode.text!,
                                             "isfb": "",
                                             "fbusername": "",
                                             "isGoogle": "",
                                             "googleusername": "",
                                             "isInsta": "",
                                             "instausername": "",
                                             "isTwitter": "",
                                             "twitterusername": "",
                ]
                
                print(params)
                Alamofire.request(requestURL, method: .post, parameters: params)
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let data):
                            print(data)
                            let stauts = (data as! NSDictionary).value(forKey: "status") as! Int
                            self.stopAnimating()
                            if stauts == 1{
                                self.navigationController?.isNavigationBarHidden = true
                                let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                self.navigationController?.pushViewController(nextPage, animated: true)
                            }else{
                                self.scrViewTag = sender.tag + 7
                                if let view = self.view.viewWithTag(1){
                                    self.swipeback()
                                    self.view.bringSubview(toFront: view)
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                            self.stopAnimating()
                        }
                }
            } else if sender.tag == 7 {
                checkUserName(sender, type: "username")
            } else if sender.tag == 8 {
                checkUserName(sender, type: "email")
            } else {
                self.scrViewTag = sender.tag + 7
                if let view = self.view.viewWithTag(sender.tag-5){
                    self.swipeback()
                    self.view.bringSubview(toFront: view)
                }
            }
        }
    }
    
    func checkUserName(_ sender: UIButton, type: String) {
        self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
        let url = "\(BaseURL)\(addUsername)"
        let requestURL: URL = URL(string: url)!
        
        let params: [String: Any] = ["username": type == "username" ? txtUserName.text! : txtEmail.text!, "type": type]
        print(params)
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    self.stopAnimating()
                    let stauts = (data as! NSDictionary).value(forKey: "status") as! Int
                    let msg = (data as! NSDictionary).value(forKey: "message") as! String
                    if stauts == 1{
                        self.scrViewTag = sender.tag + 7
                        if let view = self.view.viewWithTag(sender.tag-5){
                            self.swipeback()
                            self.view.bringSubview(toFront: view)
                        }
                    }else{
                        if(type == "username") {
                            self.lblUserError.text = msg
                        } else {
                            self.lblEmailError.text = msg
                        }
                    }
                case .failure(let error):
                    self.stopAnimating()
                    print(error)
                }
        }
    }

    @IBAction func onClick_GenderOptions(_ sender: UIButton) {
        for view in viewGenderOption.subviews{
            if let btn = view as? UIButton{
                btn.setImage(#imageLiteral(resourceName: "ic_radio_fill"), for: .normal)
            }
        }
        sender.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
        gender = (sender.titleLabel?.text)!
        gender = gender.trimmingCharacters(in: .whitespaces)
        print(gender)
    }
    
    
    func ValidateTextField(tag:Int) -> Bool
    {
        utils.addLineToTextfield(textField: txtUserName, color: .lightGray)
        utils.addLineToTextfield(textField: txtEmail, color: .lightGray)
        utils.addLineToTextfield(textField: txtPassword, color: .lightGray)
        utils.addLineToTextfield(textField: txtAge, color: .lightGray)
        utils.addLineToTextfield(textField: txtCity, color: .lightGray)
        utils.addLineToTextfield(textField: txtState, color: .lightGray)
        utils.addLineToTextfield(textField: txtCountry, color: .lightGray)
        utils.addLineToTextfield(textField: txtreferralCode, color: .lightGray)
        utils.addLineToTextfield(textField: txtrefPH, color: .lightGray)
        
        if tag == 7{
            if txtUserName.text == "" {
                utils.addLineToTextfield(textField: txtUserName, color: .red)
                return false
            }
            let username = txtUserName.text?.uppercased()
            if (username!.contains("TSLA")) || (username!.contains("TESLA")){
                utils.addLineToTextfield(textField: txtEmail, color: .red)
                let alert = UIAlertController(title: "Error", message: "Username containing \"TSLA\" or \"Tesla\" is not allowed.", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.dismiss(animated: false, completion: nil)
                }
                alert.addAction(OkAction)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        if tag == 8 {
            if txtEmail.text == ""{
                utils.addLineToTextfield(textField: txtEmail, color: .red)
                return false
            }
            if txtPassword.text == ""{
                utils.addLineToTextfield(textField: txtPassword, color: .red)
                return false
            }
            
            if(txtEmail.text!.count > 0)
            {
                if !(txtEmail.text?.isValidEmail())!{
                    utils.addLineToTextfield(textField: txtEmail, color: .red)
                    let alert = UIAlertController(title: "Error", message: "Invalid email id.", preferredStyle: .alert)
                    let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    alert.addAction(OkAction)
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }
            if (txtPassword.text!.utf16).count < 6{
                utils.addLineToTextfield(textField: txtPassword, color: .red)
                let alert = UIAlertController(title: "Error", message: "Password must be at least 6 characters long.", preferredStyle: .alert)
                let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alert.addAction(OkAction)
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        if tag == 9 {
            if txtCity.text == ""{
                utils.addLineToTextfield(textField: txtCity, color: .red)
                return false
            }
            if txtState.text == ""{
                utils.addLineToTextfield(textField: txtState, color: .red)
                return false
            }
            if txtCountry.text == ""{
                utils.addLineToTextfield(textField: txtCountry, color: .red)
                return false
            }
        }
        if tag == 10 && txtAge.text == ""{
            utils.addLineToTextfield(textField: txtAge, color: .red)
            return false
        }
        if tag == 12 && txtreferralCode.text == ""{
            utils.addLineToTextfield(textField: txtreferralCode, color: .red)
            utils.addLineToTextfield(textField: txtrefPH, color: .red)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtUserName{
            txtUserName.resignFirstResponder()
        }else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtPassword.resignFirstResponder()
        } else if textField == txtCountry {
            txtState.becomeFirstResponder()
        } else if textField == txtState {
            txtCity.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnBack_Click(_ sender: UIButton) {
        if (self.currentViewTag == 6 || self.currentViewTag == 0) {
            self.navigationController?.popViewController(animated: true)
        } else if let view = self.view.viewWithTag(self.currentViewTag-6){
            self.currentViewTag = self.currentViewTag-1
            self.view.bringSubview(toFront: view)
        }
    }
}
