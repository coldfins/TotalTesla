//
//  ProfileInfoVC.swift
//  TotalTesla
//
//  Created by Coldfin on 11/14/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire

class ProfileInfoVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate,NVActivityIndicatorViewable{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtRefferalCode: UITextField!
    @IBOutlet weak var txtRefPH: UITextField!
    @IBOutlet weak var swtCountry: UISwitch!
    @IBOutlet weak var swtState: UISwitch!
    @IBOutlet weak var swtCity: UISwitch!
    @IBOutlet weak var swtCode: UISwitch!
    @IBOutlet weak var actCountry: UIActivityIndicatorView!
    @IBOutlet weak var actState: UIActivityIndicatorView!
    @IBOutlet weak var actCity: UIActivityIndicatorView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var scrView: UIScrollView!
    let ageKeyboardview = KeyboardPicker()
    let genderKeyboardview = KeyboardPicker()
    let countriesKeyboardview = KeyboardPicker()
    let statesKeyboardview = KeyboardPicker()
    let cityKeyboardview = KeyboardPicker()
    var email = ""
    var isFB = 0
    var fbusername = ""
    var isGoogle = 0
    var googleusername = ""
    var isInsta = 0
    var instausername = ""
    var isTwitter = 0
    var twitterusername = ""
    var username = ""
    var arrCountries : NSMutableArray = NSMutableArray()
    var arrCountriesIDs : NSMutableArray = NSMutableArray()
    var cId = ""
    var arrStates : NSMutableArray = NSMutableArray()
    var arrStatesIDs : NSMutableArray = NSMutableArray()
    var sId = ""
    var arrCity : NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.text = email
        addLineToTextfield()
        setDesign()
        self.getAllCountries()
        
        if isInsta == 1 || isTwitter == 1 {
            self.txtEmail.isEnabled = true
            self.txtEmail.textColor = .black
        }else {
            self.txtEmail.isEnabled = false
            self.txtEmail.textColor = .gray
        }
    }
    
    func getAllCountries() {
        self.txtCountry.isEnabled = false
        self.actCountry.startAnimating()
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
        self.txtCountry.isEnabled = true
        self.actCountry.stopAnimating()
        self.txtCountry.inputView = self.countriesKeyboardview
        setToolbar(txt: self.txtCountry)
    }
    
    func setStatePicker() {
        self.statesKeyboardview.Values = self.arrStates as! [String]
        self.statesKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.statesKeyboardview.onDateSelected = { (Value: String) in
            self.txtState.text = Value
        }
        self.txtState.isEnabled = true
        self.actState.stopAnimating()
        self.txtState.inputView = self.statesKeyboardview
        setToolbar(txt: self.txtState)
    }
    
    func setCityPicker() {
        self.cityKeyboardview.Values = self.arrCity as! [String]
        self.cityKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.cityKeyboardview.onDateSelected = { (Value: String) in
            self.txtCity.text = Value
        }
        self.txtCity.isEnabled = true
        self.actCity.stopAnimating()
        self.txtCity.inputView = self.cityKeyboardview
        setToolbar(txt: self.txtCity)
    }
    
    func getAllStates(countryId: String) {
        self.txtState.isEnabled = false
        self.actState.startAnimating()
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
        self.txtCity.isEnabled = false
        self.actCity.startAnimating()
        let sID = stateId.replacingOccurrences(of: "\"", with: "")

        utils.callAPI(url: "\(CITYURL)\(countryId)&stateId=\(sID)", method: .get, params: nil, completionHandler: {dic in
            print(dic)
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
    
    func setToolbar(txt: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileInfoVC.doneLocationPicker))
        if(txt == txtCountry) {
            doneButton.tag = 1
        } else if (txt == txtState) {
            doneButton.tag = 2
        } else {
            doneButton.tag = 0
        }
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileInfoVC.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txt.inputAccessoryView = toolBar
    }

    func setDesign()  {
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)
        
        //Dismiss keyboard
        let tapTerm : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        tapTerm.delegate = self
        tapTerm.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapTerm)
        
        swtCity.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtState.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtCountry.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        swtCode.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
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
        
        let arrGender = ["Male","Female","Transgender","Genderqueer","Prefer not to say","Other"]
        self.genderKeyboardview.Values = arrGender
        self.genderKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.genderKeyboardview.onDateSelected = { (Value: String) in
            self.txtGender.text = Value
        }
        self.txtAge.inputView = self.ageKeyboardview
        self.txtGender.inputView = self.genderKeyboardview
        
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
        self.txtGender.inputAccessoryView = toolBar
    }
    @objc func donePicker (sender:UIBarButtonItem){
        self.txtAge.resignFirstResponder()
        self.txtGender.resignFirstResponder()
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem){
        self.txtAge.resignFirstResponder()
        self.txtGender.resignFirstResponder()
        self.txtCountry.resignFirstResponder()
        self.txtState.resignFirstResponder()
        self.txtCity.resignFirstResponder()
    }
    
    //MARK: - Add Line
    func addLineToTextfield() {
        // Step 1 Textbox
        utils.addLineToTextfield(textField: txtEmail, color: .lightGray)
        utils.addLineToTextfield(textField: txtCountry, color: .lightGray)
        utils.addLineToTextfield(textField: txtState, color: .lightGray)
        utils.addLineToTextfield(textField: txtCity, color: .lightGray)
        utils.addLineToTextfield(textField: txtAge, color: .lightGray)
        utils.addLineToTextfield(textField: txtGender, color: .lightGray)
        utils.addLineToTextfield(textField: txtRefferalCode, color: .lightGray)
        utils.addLineToTextfield(textField: txtRefPH, color: .lightGray)
    }
    
    //MARK: - KeyBoard Observer Method
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height) * (show ? 1 : 0)
        scrView.contentInset.bottom = adjustmentHeight
        scrView.scrollIndicatorInsets.bottom = adjustmentHeight
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
    
    
    @IBAction func onClick_done(_ sender: Any) {
              
        if ValidateTextField(){
            let params: [String: Any] = ["email" : txtEmail.text!,
                                         "gender" : txtGender.text!,
                                         "country" : txtCountry.text!,
                                         "state" : txtState.text!,
                                         "city" : txtCity.text!,
                                         "age" : txtAge.text!,
                                         "showCountry" : swtCountry.isOn,
                                         "showState" : swtState.isOn,
                                         "showCity": swtCity.isOn,
                                         "referralCode":txtRefferalCode.text!,
                                         "referrelCodePermission" : swtCode.isOn,
                                         "username": self.username,
                                         "socialType": "",
                                         "isfb": self.isFB,
                                         "fbusername": self.fbusername,
                                         "isGoogle": self.isGoogle,
                                         "googleusername": self.googleusername,
                                         "isInsta": self.isInsta,
                                         "instausername": self.instausername,
                                         "isTwitter": self.isTwitter,
                                         "twitterusername": self.twitterusername,
                                         "password": "",
            ]
            
            self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
          
            utils.callAPI(url: "\(BaseURL)\(register)", method: .post, params: params, completionHandler: {dic in
                let status = dic.value(forKey: "status") as! Int
                let msg = dic.value(forKey: "message") as! String

                if status == 1{
                    let data = dic.value(forKey: "data") as! NSArray
                    let userInfo = data.object(at: 0) as! NSDictionary
                    let id = userInfo.object(forKey: "id") as! Int
                    utils.userid = String(id)
                    
                    self.navigationController?.isNavigationBarHidden = true
                    let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }else{
                   let alert = UIAlertController(title: "", message:msg, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    let when = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: when){
                        alert.dismiss(animated: true, completion: nil)
                    }
                }
                 self.stopAnimating()
            })
        }
    }
   
    func ValidateTextField() -> Bool
    {
        addLineToTextfield()
        
        if txtEmail.text == ""{
            utils.addLineToTextfield(textField: txtEmail, color: .red)
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
        if txtAge.text == ""{
            utils.addLineToTextfield(textField: txtAge, color: .red)
            return false
        }
        if txtGender.text == ""{
            utils.addLineToTextfield(textField: txtAge, color: .red)
            return false
        }
        if txtAge.text == ""{
            utils.addLineToTextfield(textField: txtRefferalCode, color: .red)
            utils.addLineToTextfield(textField: txtRefPH, color: .red)
            return false
        }
      
        return true
    }
}
