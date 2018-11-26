//
//  LinkEmailVC.swift
//  TotalTesla
//
//  Created by Coldfin on 11/14/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit

class LinkEmailVC: UIViewController,UIGestureRecognizerDelegate,NVActivityIndicatorViewable {

    @IBOutlet weak var viewY: NSLayoutConstraint!
    @IBOutlet weak var txtEmail: UITextField!
    
    var username = ""
    var socialtype = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        utils.addLineToTextfield(textField: txtEmail, color: .lightGray)
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)
        
        //Dismiss keyboard
        let tapTerm : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        tapTerm.delegate = self
        tapTerm.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapTerm)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    //MARK: - KeyBoard Observer Method
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let adjustmentHeight = (keyboardFrame.height - 70) * (show ? 1 : 0)
        viewY.constant = -adjustmentHeight
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
    
    
    @IBAction func onClick_link(_ sender: Any) {
        if ValidateTextField(){
            self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
            let params: [String: Any] = ["email" : txtEmail.text!,
                                         "socialtype": socialtype,
                                         "username": username ]
            utils.callAPI(url: "\(BaseURL)\(checkSocialEmail)", method: .post, params: params, completionHandler: {dic in
                let status = dic.value(forKey: "status") as! Int
                if status != 1{
                    let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
                    nextPage.email = self.txtEmail.text!
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }else{
                    let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }
                self.stopAnimating()
            })
        }
    }
    
    //MARK: - Validation
    func ValidateTextField() -> Bool
    {
        utils.addLineToTextfield(textField: txtEmail, color: .lightGray)
        if txtEmail.text == "" {
            utils.addLineToTextfield(textField: txtEmail, color: .red)
            return false
        }
        return true
    }
}
