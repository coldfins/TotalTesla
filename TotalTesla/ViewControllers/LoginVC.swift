//
//  LoginVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/14/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController,UIGestureRecognizerDelegate, UITextFieldDelegate,NVActivityIndicatorViewable {
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utils.addLineToTextfield(textField: txtUserName, color: .lightGray)
        utils.addLineToTextfield(textField: txtPassword, color: .lightGray)
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)
        
        //Dismiss keyboard
        let tapTerm : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        tapTerm.delegate = self
        tapTerm.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapTerm)
    }
    
    //MARK: - KeyBoard Observer Method
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height - 50) * (show ? 1 : 0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClick_login(_ sender: Any) {
        if ValidateTextField(){
            self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
            let url = "\(BaseURL)\(authenticate)"
            let requestURL: URL = URL(string: url)!
            
            let params: [String: Any] = ["email" : txtUserName.text!,
                                         "password" : txtPassword.text!,]
            print(params)
            Alamofire.request(requestURL, method: .post, parameters: params)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let responseData):
                        let stauts = (responseData as! NSDictionary).value(forKey: "status") as! Int
                        let msg = (responseData as! NSDictionary).value(forKey: "message") as! String
                        self.stopAnimating()
                        if stauts == 1{
                            let data = (responseData as! NSDictionary).value(forKey: "data") as! NSArray
                            let userInfo = data.object(at: 0) as! NSDictionary
                            let id = userInfo.object(forKey: "id") as! Int
                            utils.userid = String(id)
                            self.navigationController?.isNavigationBarHidden = true
                            let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.navigationController?.pushViewController(nextPage, animated: true)
                        } else {
                             utils.alertShow(title: kAppName, message: msg, view: self)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
            }
        }
    }
    
    @IBAction func onClick_Signup(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    func ValidateTextField() -> Bool
    {
        utils.addLineToTextfield(textField: txtUserName, color: .lightGray)
        utils.addLineToTextfield(textField: txtPassword, color: .lightGray)
        if txtUserName.text == "" || txtPassword.text == ""{
            utils.addLineToTextfield(textField: txtUserName, color: .red)
            utils.addLineToTextfield(textField: txtPassword, color: .red)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUserName {
            txtPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
