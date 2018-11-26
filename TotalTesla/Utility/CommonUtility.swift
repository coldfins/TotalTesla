//
//  CommonUtility.swift
//  TotalTesla
//
//  Created by Coldfin on 9/14/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire

class CommonUtility: NSObject {
    
    var userid = ""

    func addLineToTextfield(textField:UITextField,color:UIColor){
        let border = CALayer()
        let height = CGFloat(2.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.height-1, width:  textField.frame.size.width, height: 1)
        
        border.borderWidth = height
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    func callAPI(url: String, method:HTTPMethod, params:[String: Any]? = nil,completionHandler:@escaping   (NSDictionary) -> ()) {
       
        let requestURL: URL = URL(string: url)!
        
        Alamofire.request(requestURL, method: method, parameters: params)
            .validate(statusCode: 200..<600)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    completionHandler(data as! NSDictionary)
                case .failure(let error):
                     print(error)
                     let window = UIApplication.shared.keyWindow
                     utils.alertShow(title: "Error", message: "\(error.localizedDescription)\nTry agian later.", view: (window?.rootViewController)!)
                }
        }
    }

    func alertShow(title: String, message: String, view: UIViewController){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(ok)
        view.present(alertView, animated: true, completion: nil);
    }
    
    //MARK: Check Vin Validation
    func checkVINNumber(vin:String,completionHandler:@escaping   (Bool,String) -> ()) {
    
        if vin[0] == "5" && vin[1] == "Y" && vin[2] == "J" {
            if vin[3] == "S" || vin[3] == "X" || vin[3] == "3" {
                
                let calculatedCharacters = self.getCalculatedCharacter(vinValue: vin, vinlength: vin.count)
                if calculatedCharacters == "\(vin[8])" {
                    utils.callAPI(url: "\(BaseURL)checkVin/\(vin)", method: .get, params: nil, completionHandler: { data in
                        let stauts = data.value(forKey: "status") as! Int
                        let msg = data.value(forKey: "message") as! String
                        if stauts == 1{
                           completionHandler(false,msg)
                        }else{
                           completionHandler(true,msg)
                        }
                    })
                }else{
                    completionHandler(false,"Invalid VIN number")
                }
            }else{
                completionHandler(false,"Invalid VIN number")
            }
        }else{
            completionHandler(false,"Invalid VIN number")
        }
    }
    
    func getCalculatedCharacter(vinValue:String,vinlength:Int) -> String {
        var finalProductNumber = 0
        
        for i in 0...vinlength-1 {
            if (i == 8) {
                //Do nothing
            }else {
                let value = self.replaceToValue(c: "\(vinValue[i])");
                let weight = self.replaceToWeight(index: i);
                if (value == "V") {
                    return "V";
                }
                if (weight == "W") {
                    return "W";
                }
                let product = self.replaceToProduct(value: Int(value)!, weight: Int(weight)!);
                finalProductNumber = finalProductNumber + product;
            }
        }
        let returnNumber = finalProductNumber % 11;
        if (returnNumber == 10) {
            return "X";
        } else {
            let strReturnNumber = "\(returnNumber)"[0]
            return "\(strReturnNumber)";
        }
    }
    func replaceToProduct(value:Int,weight:Int) -> Int {
        let p = value * weight
        return p
    }
    
    func replaceToValue(c:String) -> String {
        switch (c) {
        case "A":
            return "1";
            
        case "B":
            return "2";
            
        case "C":
            return "3";
            
        case "D":
            return "4";
            
        case "E":
            return "5";
            
        case "F":
            return "6";
            
        case "G":
            return "7";
            
        case "H":
            return "8";
            
        case "J":
            return "1";
            
        case "K":
            return "2";
            
        case "L":
            return "3";
            
        case "M":
            return "4";
            
        case "N":
            return "5";
            
        case "P":
            return "7";
            
        case "R":
            return "9";
            
        case "S":
            return "2";
            
        case "T":
            return "3";
            
        case "U":
            return "4";
            
        case "V":
            return "5";
            
        case "W":
            return "6";
            
        case "X":
            return "7";
            
        case "Y":
            return "8";
            
        case "Z":
            return "9";
            
        case "0":
            return "0";
            
        case "1":
            return "1";
            
        case "2":
            return "2";
            
        case "3":
            return "3";
            
        case "4":
            return "4";
            
        case "5":
            return "5";
            
        case "6":
            return "6";
            
        case "7":
            return "7";
            
        case "8":
            return "8";
            
        case "9":
            return "9";
            
        default:
            return "V";
        }
    }
    func replaceToWeight(index:Int) -> String{
        switch (index) {
        case 0:
            return "8";
        case 1:
            return "7";
        case 2:
            return "6";
        case 3:
            return "5";
        case 4:
            return "4";
        case 5:
            return "3";
        case 6:
            return "2";
        case 7:
            return "10";
        case 9:
            return "9";
        case 10:
            return "8";
        case 11:
            return "7";
        case 12:
            return "6";
        case 13:
            return "5";
        case 14:
            return "4";
        case 15:
            return "3";
        case 16:
            return "2";
        default:
            return "W";
        }
    }
    
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
