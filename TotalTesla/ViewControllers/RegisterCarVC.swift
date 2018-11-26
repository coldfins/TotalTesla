//
//  RegisterCarVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/13/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog
import AFNetworking

class ImageColletionViewCell:UICollectionViewCell{
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnAddCar: UIButton!
}

class RegisterCarVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate, NVActivityIndicatorViewable  {

    // Step 1
    @IBOutlet weak var txtInteriorColor: UITextField!
    @IBOutlet weak var txtExteriorColor: UITextField!
    @IBOutlet weak var txtRoof: UITextField!
    @IBOutlet weak var txtTrims: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtCarModel: UITextField!
    @IBOutlet weak var txtVIN: UITextField!
    @IBOutlet weak var switchVin: UISwitch!
    @IBOutlet weak var actYear: UIActivityIndicatorView!
    @IBOutlet weak var actTrim: UIActivityIndicatorView!
    @IBOutlet weak var actRoof: UIActivityIndicatorView!
    @IBOutlet weak var actExte: UIActivityIndicatorView!
    @IBOutlet weak var actInte: UIActivityIndicatorView!
    
    // Step 2
    @IBOutlet weak var txtAutoPilot: UITextField!
    @IBOutlet weak var txtCharger: UITextField!
    @IBOutlet weak var txtTrunk: UITextField!
    @IBOutlet weak var txtSuspension: UITextField!
    @IBOutlet weak var txtSuperCharging: UITextField!
    @IBOutlet weak var txtWheels: UITextField!
    @IBOutlet weak var actAuto: UIActivityIndicatorView!
    @IBOutlet weak var actCharger: UIActivityIndicatorView!
    @IBOutlet weak var actTrunck: UIActivityIndicatorView!
    @IBOutlet weak var actSuspension: UIActivityIndicatorView!
    @IBOutlet weak var actWheels: UIActivityIndicatorView!
    @IBOutlet weak var actSuperCharging: UIActivityIndicatorView!
    
    // Step 3
    @IBOutlet weak var tblNoteable: UITableView!
    @IBOutlet weak var actNoteable: UIActivityIndicatorView!
    
    // Step 4
    @IBOutlet weak var tblMarket: UITableView!
    @IBOutlet weak var actMarket: UIActivityIndicatorView!
    
    // Step 5
    @IBOutlet weak var txtCarNickName: UITextField!
    @IBOutlet weak var txtFirmware: UITextField!
    @IBOutlet weak var txtOrderDate: UITextField!
    @IBOutlet weak var txtChangeDate: UITextField!
    @IBOutlet weak var txtDeliveryDate: UITextField!
    @IBOutlet weak var switchOwner: UISwitch!
    
    //Step 6
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAddCar: UIButton!
    var arrImages = NSMutableArray()
    let picker = UIImagePickerController()
    var popOver: UIPopoverController!
    
    // Step 1 Picker
    let carModelKeyboardview = KeyboardPicker()
    let yearKeyboardview = KeyboardPicker()
    let trimsKeyboardview = KeyboardPicker()
    let roofKeyboardview = KeyboardPicker()
    let exteriorColorKeyboardview = KeyboardPicker()
    let interiorColorKeyboardview = KeyboardPicker()
    var vinNumber = String()
    var isVinApproved : String = "true"
  
    // Step 1 Array
    var arrCarModel : NSMutableArray = NSMutableArray()
    var arrCarDataModel : NSMutableArray = NSMutableArray()
    var arrYear : NSMutableArray = NSMutableArray()
    var arrTrims : NSMutableArray = NSMutableArray()
    var arrRoofs : NSMutableArray = NSMutableArray()
    var arrExteriorColor : NSMutableArray = NSMutableArray()
    var arrInteriorColor : NSMutableArray = NSMutableArray()
    
    // Step 2 Picker
    let autoPilotKeyboardview = KeyboardPicker()
    let chargerKeyboardview = KeyboardPicker()
    let trunkKeyboardview = KeyboardPicker()
    let suspensionKeyboardview = KeyboardPicker()
    let superChargingKeyboardview = KeyboardPicker()
    let wheelsKeyboardview = KeyboardPicker()
    
    // Step 2 Array
    var arrAutoPilot : NSMutableArray = NSMutableArray()
    var arrCharger : NSMutableArray = NSMutableArray()
    var arrTrunk : NSMutableArray = NSMutableArray()
    var arrSuspension : NSMutableArray = NSMutableArray()
    var arrSuperCharging : NSMutableArray = NSMutableArray()
    var arrWheels : NSMutableArray = NSMutableArray()
    
    // Step 3 Array
    var arrNoteableOptions : NSMutableArray = NSMutableArray()
    var arrNoteableData = NSMutableArray()
    var switchNoteableData = NSMutableArray()
    
    // Step4 Array
    var arrMarketOptions : NSMutableArray = NSMutableArray()
    var arrMarketData = NSMutableArray()
    var switchMarketData = NSMutableArray()
    
    // Step 5
    var strOrderDate = String()
    var strChangeDate = String()
    var strDeliveryDate = String()
    
    var scrViewTag = 0
    var model_id = 0
    var currentViewTag = 0
    
    var model = CarDetailModel()
    var isForEdit = false
    
    var exteriorColorId : NSMutableArray = NSMutableArray()
    var interiorColorId : NSMutableArray = NSMutableArray()
    var ex_ColorId = ""
    var in_ColorId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        scrViewTag = 13
        self.addLineToTextfield()
        
        //KeyBoard Observer
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(_:)),name: Notification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(_:)),name: Notification.Name.UIKeyboardWillHide,object: nil)

        let tapTerm : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        tapTerm.delegate = self
        tapTerm.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapTerm)

        // Step 1 Pickers
        setCarModelPicker()
        setYearPicker()
        setTrimsPicker()
        setRoofPicker()
        setExteriorColorPicker()
        setInteriorColorPicker()
        
        // Step 2 Pickers
        setAutoPilotPicker()
        setChargerPicker()
        setTrunkPicker()
        setAirSuspensionPicker()
        setSuperChargingPicker()
        setWheelsPicker()
        
        self.getCarModel()
        self.getExteriorColor()
        
        self.setDatepicker(dateTextField: self.txtOrderDate)
        self.setDatepicker(dateTextField: self.txtChangeDate)
        self.setDatepicker(dateTextField: self.txtDeliveryDate)
        self.setToolbar(txt: txtVIN)
        
        if isForEdit {
            setData()
        }
    }
    
    //MARK: Set date for Edit
    func setData() {
        txtVIN.text = model.vin
        txtVIN.isEnabled = false
        switchVin.isOn = false
        vinNumber = model.vin
        if(model.isMask == "true") {
            let v = (model.vin as NSString).replacingCharacters(
                in: NSMakeRange(0,11), with: "XXXXXXXXXXX")
            self.txtVIN.text = v
            self.switchVin.isOn = true
        }
        txtCarModel.text = model.modelname
        txtYear.text = "\(model.year)"
        txtTrims.text = model.battery
        txtRoof.text = model.roof
        txtExteriorColor.text = model.exterior_color_name
        txtInteriorColor.text = model.interior_color_name
        txtAutoPilot.text = model.autopilot
        txtCharger.text = model.charger
        txtTrunk.text = model.liftgateOrTrunk
        txtSuspension.text = model.suspension
        txtSuperCharging.text = model.superCharging
        txtWheels.text = model.wheels
        self.model_id = Int(model.modelId)!
        txtCarNickName.text = model.carNickname
        txtFirmware.text = model.frimwareVersion
        
        self.ex_ColorId = model.exterior_color_id
        self.in_ColorId = model.interior_color_id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let orderDate = d.date(from:  model.orderDate)
        let changeDate = d.date(from: model.changeDate)
        let deliveryDate = d.date(from: model.deliveryDate)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.strOrderDate = df.string(from: orderDate!)
        self.strChangeDate = df.string(from:  changeDate!)
        self.strDeliveryDate = df.string(from: deliveryDate!)
        print(self.strOrderDate,
            self.strChangeDate,
            self.strDeliveryDate)
            
        self.txtOrderDate.text = dateFormatter.string(from: orderDate!)
        self.txtChangeDate.text = dateFormatter.string(from: changeDate!)
        self.txtDeliveryDate.text = dateFormatter.string(from: deliveryDate!)
    
        if model.isFirstOwner == "true" {
            switchOwner.isOn = true
        }
        
        if model.carimages.count != 0 {
            self.arrImages = model.carimages
            self.btnAddCar.isHidden = true
            self.collectionView.reloadData()
        }
        
        self.getProductionYear()
        self.getTrimsOption()
        self.getRoofOption()
        self.getInteriorColor()
    
    }
    
    //MARK: TextField bottom line
    func addLineToTextfield() {
        // Step 1 Textbox
        utils.addLineToTextfield(textField: txtInteriorColor, color: .lightGray)
        utils.addLineToTextfield(textField: txtExteriorColor, color: .lightGray)
        utils.addLineToTextfield(textField: txtRoof, color: .lightGray)
        utils.addLineToTextfield(textField: txtTrims, color: .lightGray)
        utils.addLineToTextfield(textField: txtYear, color: .lightGray)
        utils.addLineToTextfield(textField: txtCarModel, color: .lightGray)
        utils.addLineToTextfield(textField: txtVIN, color: .lightGray)
        
        switchVin.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchOwner.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        // Step 2 Textbox
        utils.addLineToTextfield(textField: txtAutoPilot, color: .lightGray)
        utils.addLineToTextfield(textField: txtCharger, color: .lightGray)
        utils.addLineToTextfield(textField: txtTrunk, color: .lightGray)
        utils.addLineToTextfield(textField: txtSuspension, color: .lightGray)
        utils.addLineToTextfield(textField: txtSuperCharging, color: .lightGray)
        utils.addLineToTextfield(textField: txtWheels, color: .lightGray)
        
        // Step 5 Textbox
        utils.addLineToTextfield(textField: txtCarNickName, color: .lightGray)
        utils.addLineToTextfield(textField: txtFirmware, color: .lightGray)
        utils.addLineToTextfield(textField: txtOrderDate, color: .lightGray)
        utils.addLineToTextfield(textField: txtDeliveryDate, color: .lightGray)
        utils.addLineToTextfield(textField: txtChangeDate, color: .lightGray)
    }
    
    //MARK: Date picker
    func setDatepicker(dateTextField: UITextField){
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePickerView
        if(dateTextField == self.txtOrderDate) {
             datePickerView.tag = 51
        } else if(dateTextField == self.txtChangeDate) {
             datePickerView.tag = 52
        } else {
             datePickerView.tag = 53
        }
       
        datePickerView.addTarget(self, action: #selector(RegisterCarVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
        setToolbar(txt: dateTextField)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"

        if(sender.tag == 51) {
            self.txtOrderDate.text = dateFormatter.string(from: sender.date)
            self.strOrderDate = d.string(from: sender.date)
        } else if(sender.tag == 52) {
            self.txtChangeDate.text = dateFormatter.string(from: sender.date)
            self.strChangeDate = d.string(from: sender.date)
        } else {
            self.strDeliveryDate = d.string(from: sender.date)
            self.txtDeliveryDate.text = dateFormatter.string(from: sender.date)
        }
    }
    
    func resignKeybaord() {
        self.txtRoof.resignFirstResponder()
        self.txtTrims.resignFirstResponder()
        self.txtYear.resignFirstResponder()
        self.txtCarModel.resignFirstResponder()
        self.txtVIN.resignFirstResponder()
        self.txtInteriorColor.resignFirstResponder()
        self.txtExteriorColor.resignFirstResponder()
        
        self.txtAutoPilot.resignFirstResponder()
        self.txtCharger.resignFirstResponder()
        self.txtTrunk.resignFirstResponder()
        self.txtSuspension.resignFirstResponder()
        self.txtSuperCharging.resignFirstResponder()
        self.txtWheels.resignFirstResponder()
        
        self.txtChangeDate.resignFirstResponder()
        self.txtDeliveryDate.resignFirstResponder()
        self.txtOrderDate.resignFirstResponder()
    }
    
    @objc func donePicker (sender:UIBarButtonItem) {
        print(sender.tag)
        self.resignKeybaord()
    }
    
    @objc func cancelPicker (sender:UIBarButtonItem) {
        self.resignKeybaord()
    }
    
    func setToolbar(txt: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterCarVC.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterCarVC.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txt.inputAccessoryView = toolBar
    }

    //MARK: Get values of fields
    func getCarModel() {
        let url = "\(BaseURL)\(getCarModels)"
        let requestURL: URL = URL(string: url)!
        
        Alamofire.request(requestURL, method: .get, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrCar : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    for car in arrCar {
                        if let name = (car as AnyObject).object(forKey: "name") as? String {
                            self.arrCarModel.add(name)
                        }
                        if let model = (car as AnyObject).object(forKey: "model_id") as? Int {
                            self.arrCarDataModel.add(model)
                        }
                    }
                    self.setCarModelPicker()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getProductionYear() {
        let url = "\(BaseURL)\(getProductionYear)"
        let requestURL: URL = URL(string: url)!
        
        let params: [String: Any] = ["model_id" : self.model_id ]
        txtYear.isEnabled = false
        actYear.startAnimating()
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrYears : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrYear.removeAllObjects()
                    for year in arrYears {
                        let yearData = year as! NSDictionary
                        if let y = yearData.object(forKey: "year") {
                            self.arrYear.add((y as AnyObject).stringValue)
                        }
                    }
                    self.setYearPicker()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getTrimsOption() {
        let url = "\(BaseURL)\(getTrimsOption)"
        let requestURL: URL = URL(string: url)!
        let params: [String: Any] = ["model_id" : self.model_id ]
        
        txtTrims.isEnabled = false
        actTrim.startAnimating()
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrTrim : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrTrims.removeAllObjects()
                    for trim in arrTrim {
                        let trimData = trim as! NSDictionary
                        if let t = trimData.object(forKey: "battery") as? String {
                            self.arrTrims.add(t)
                        }
                    }
                    self.setTrimsPicker()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getRoofOption() {
        let url = "\(BaseURL)\(getRoofOption)"
        let requestURL: URL = URL(string: url)!
        let params: [String: Any] = ["model_id" : self.model_id ]
        
        txtRoof.isEnabled = false
        actRoof.startAnimating()
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrRoof : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrRoofs.removeAllObjects()
                    for roof in arrRoof {
                        let roofData = roof as! NSDictionary
                        if let r = roofData.object(forKey: "name") as? String {
                            self.arrRoofs.add(r)
                        }
                    }
                    self.setRoofPicker()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getInteriorColor() {
        let url = "\(BaseURL)\(getInteriorColor)"
        let requestURL: URL = URL(string: url)!
        let params: [String: Any] = ["model_id" : self.model_id ]
        txtInteriorColor.isEnabled = false
        actInte.startAnimating()
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrInterior : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrInteriorColor.removeAllObjects()
                    self.interiorColorId.removeAllObjects()
                    for Interior in arrInterior {
                        print(Interior)
                        let InteriorData = Interior as! NSDictionary
                        if let e = InteriorData.object(forKey: "name") as? String {
                            self.arrInteriorColor.add(e)
                        }
                        if let id = InteriorData.object(forKey: "interiorcolor_id") as? Int {
                            self.interiorColorId.add(id)
                        }
                    }
                    self.setInteriorColorPicker()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getExteriorColor() {
        let url = "\(BaseURL)\(getExteriorColor)"
        let requestURL: URL = URL(string: url)!
        txtExteriorColor.isEnabled = false
        actExte.startAnimating()
        Alamofire.request(requestURL, method: .get, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arrExterior : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrExteriorColor.removeAllObjects()
                    self.exteriorColorId.removeAllObjects()
                    for exterior in arrExterior {
                        print(exterior)
                        let exteriorData = exterior as! NSDictionary
                        if let e = exteriorData.object(forKey: "name") as? String {
                            self.arrExteriorColor.add(e)
                        }
                        if let id = exteriorData.object(forKey: "exteriorcolor_id") as? Int {
                            self.exteriorColorId.add(id)
                        }
                    }
                    self.setExteriorColorPicker()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getAllNoteableOptions() {
        let url = "\(BaseURL)\(getSingleNotebleOption)"
        let requestURL: URL = URL(string: url)!
        let params: [String: Any] = ["model_id" : self.model_id, "is_single" : 1]
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                     self.switchNoteableData.removeAllObjects()
                    self.arrNoteableOptions.removeAllObjects()
                    let arrOptions : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    for op in arrOptions {
                        let optionData = op as! NSDictionary
                        self.arrNoteableOptions.add(optionData)
                        
                        let slug = optionData.value(forKey: "slug") as? String
                        var isNoteable = false
                        if self.isForEdit{
                            for i in self.model.optiondata{
                                let editSlug = (i as! NSDictionary).object(forKey: "slug") as? String
                                if slug == editSlug {
                                    isNoteable =  true
                                }
                            }
                            self.switchNoteableData.add(isNoteable)
                        }else{
                            self.switchNoteableData.add(false)
                        }
                    }
                    self.tblNoteable.reloadData()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getAfterMarketOption() {
        let url = "\(BaseURL)\(getAfterMarketOption)"
        let requestURL: URL = URL(string: url)!
        
        Alamofire.request(requestURL, method: .get, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    self.arrMarketOptions.removeAllObjects()
                    let arrOptions : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    for op in arrOptions {
                        let optionData = op as! NSDictionary
                        self.arrMarketOptions.add(optionData)
                        let slug = optionData.value(forKey: "slug") as? String
                        var isMarket = false
                        if self.isForEdit{
                            for i in self.model.aftermarketOptions{
                                let editSlug = (i as! NSDictionary).object(forKey: "slug") as? String
                                if slug == editSlug {
                                    isMarket =  true
                                }
                            }
                            self.switchMarketData.add(isMarket)
                        }else{
                            self.switchMarketData.add(false)
                        }
                    }
                    self.tblMarket.reloadData()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func getWheels() {
        let url = "\(BaseURL)\(getWheels)"
        let requestURL: URL = URL(string: url)!
        var params = [String: Any]()
        params = ["model_id" : self.model_id]
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arr : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrWheels.removeAllObjects()
                    
                    for data in arr {
                        let d = data as! NSDictionary
                        if let a = d.object(forKey: "size") as? String {
                            self.arrWheels.add(a)
                        }
                    }
                    self.setWheelsPicker()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    // Apis for picker
    func getNoteableOptions(category: String) {
        let url = "\(BaseURL)\(getCategoryResult)"
        let requestURL: URL = URL(string: url)!
        var params = [String: Any]()
        
        params = ["model_id" : self.model_id, "category" : category]
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let arr : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    
                    if(category == "AutoPilot") {
                        self.arrAutoPilot.removeAllObjects()
                    } else if(category == "Charger") {
                        self.arrCharger.removeAllObjects()
                    } else if(category == "Liftgate/Trunk") {
                        self.arrTrunk.removeAllObjects()
                    } else if(category == "Suspension") {
                        self.arrSuspension.removeAllObjects()
                    } else if(category == "Supercharging") {
                        self.arrSuperCharging.removeAllObjects()
                    }
                    
                    for data in arr {
                        let d = data as! NSDictionary
                        if let a = d.object(forKey: "choice") as? String {
                            if(category == "AutoPilot") {
                                self.arrAutoPilot.add(a)
                            } else if(category == "Charger") {
                                self.arrCharger.add(a)
                            } else if(category == "Liftgate/Trunk") {
                                self.arrTrunk.add(a)
                            } else if(category == "Suspension") {
                                self.arrSuspension.add(a)
                            } else if(category == "Supercharging") {
                                self.arrSuperCharging.add(a)
                            }
                        }
                    }
                    
                    if(category == "AutoPilot") {
                        self.setAutoPilotPicker()
                    } else if(category == "Charger") {
                        self.setChargerPicker()
                    } else if(category == "Liftgate/Trunk") {
                        self.setTrunkPicker()
                    } else if(category == "Suspension") {
                        self.setAirSuspensionPicker()
                    } else if(category == "Supercharging") {
                        self.setSuperChargingPicker()
                    }
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }

    //MARK: Set values for pickers
    func setCarModelPicker() {
        self.carModelKeyboardview.Values = self.arrCarModel as! [String]
        self.carModelKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.carModelKeyboardview.onDateSelected = { (Value: String) in
            self.txtCarModel.text = Value
            let index = self.arrCarModel.index(of: Value)
            self.model_id = self.arrCarDataModel.object(at: index) as! Int
            self.txtYear.text = ""
            self.txtTrims.text = ""
            self.txtRoof.text = ""
            self.txtInteriorColor.text = ""
            self.txtExteriorColor.text = ""

            self.getProductionYear()
            self.getTrimsOption()
            self.getRoofOption()
            self.getInteriorColor()
        }
        self.txtCarModel.inputView = self.carModelKeyboardview
        setToolbar(txt: self.txtCarModel)
    }
    
    func setYearPicker() {
        txtYear.isEnabled = true
        actYear.stopAnimating()
        self.yearKeyboardview.Values = self.arrYear as! [String]
        self.yearKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.yearKeyboardview.onDateSelected = { (Value: String) in
            self.txtYear.text = Value
        }
        self.txtYear.inputView = self.yearKeyboardview
        setToolbar(txt: self.txtYear)
        
        if(self.arrYear.count == 1) {
            self.txtYear.text = self.arrYear.object(at: 0) as? String
        }
    }
    
    func setTrimsPicker() {
        self.trimsKeyboardview.Values = self.arrTrims as! [String]
        self.trimsKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.trimsKeyboardview.onDateSelected = { (Value: String) in
            self.txtTrims.text = Value
        }
        txtTrims.isEnabled = true
        actTrim.stopAnimating()
        self.txtTrims.inputView = self.trimsKeyboardview
        setToolbar(txt: self.txtTrims)
        
        if(self.arrTrims.count == 1) {
            self.txtTrims.text = self.arrTrims.object(at: 0) as? String
        }
    }
    
    func setRoofPicker() {
        self.roofKeyboardview.Values = arrRoofs as! [String]
        self.roofKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.roofKeyboardview.onDateSelected = { (Value: String) in
            self.txtRoof.text = Value
        }
        txtRoof.isEnabled = true
        actRoof.stopAnimating()
        self.txtRoof.inputView = self.roofKeyboardview
        setToolbar(txt: self.txtRoof)
        
        if(self.arrRoofs.count == 1) {
            self.txtRoof.text = self.arrRoofs.object(at: 0) as? String
        }
    }
    
    func setExteriorColorPicker() {
        self.exteriorColorKeyboardview.Values = self.arrExteriorColor as! [String]
        self.exteriorColorKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.exteriorColorKeyboardview.onDateSelected = { (Value: String) in
            self.txtExteriorColor.text = Value
        }
        txtExteriorColor.isEnabled = true
        actExte.stopAnimating()
        self.txtExteriorColor.inputView = self.exteriorColorKeyboardview
        setToolbar(txt: self.txtExteriorColor)
        
        if(self.arrExteriorColor.count == 1) {
            self.txtExteriorColor.text = self.arrExteriorColor.object(at: 0) as? String
        }
    }
    
    func setInteriorColorPicker() {
        self.interiorColorKeyboardview.Values = self.arrInteriorColor as! [String]
        self.interiorColorKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.interiorColorKeyboardview.onDateSelected = { (Value: String) in
            self.txtInteriorColor.text = Value
        }
        txtInteriorColor.isEnabled = true
        actInte.stopAnimating()
        self.txtInteriorColor.inputView = self.interiorColorKeyboardview
        setToolbar(txt: self.txtInteriorColor)
        
        if(self.arrInteriorColor.count == 1) {
            self.txtInteriorColor.text = self.arrInteriorColor.object(at: 0) as? String
        }
    }
    
    // Set Picker for Step 2
    func setAutoPilotPicker() {
        self.autoPilotKeyboardview.Values = self.arrAutoPilot as! [String]
        self.autoPilotKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.autoPilotKeyboardview.onDateSelected = { (Value: String) in
            self.txtAutoPilot.text = Value
        }
        self.txtAutoPilot.inputView = self.autoPilotKeyboardview
        setToolbar(txt: self.txtAutoPilot)
        
        if(self.arrAutoPilot.count == 1) {
            self.txtAutoPilot.text = self.arrAutoPilot.object(at: 0) as? String
        }
    }
    
    func setChargerPicker() {
        self.chargerKeyboardview.Values = self.arrCharger as! [String]
        self.chargerKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.chargerKeyboardview.onDateSelected = { (Value: String) in
            self.txtCharger.text = Value
        }
        self.txtCharger.inputView = self.chargerKeyboardview
        setToolbar(txt: self.txtCharger)
        
        if(self.arrCharger.count == 1) {
            self.txtCharger.text = self.arrCharger.object(at: 0) as? String
        }
    }
    
    func setTrunkPicker() {
        self.trunkKeyboardview.Values = self.arrTrunk as! [String]
        self.trunkKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.trunkKeyboardview.onDateSelected = { (Value: String) in
            self.txtTrunk.text = Value
        }
        self.txtTrunk.inputView = self.trunkKeyboardview
        setToolbar(txt: self.txtTrunk)
        
        if(self.arrTrunk.count == 1) {
            self.txtTrunk.text = self.arrTrunk.object(at: 0) as? String
        }
    }
    
    func setAirSuspensionPicker() {
        self.suspensionKeyboardview.Values = self.arrSuspension as! [String]
        self.suspensionKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.suspensionKeyboardview.onDateSelected = { (Value: String) in
            self.txtSuspension.text = Value
        }
        self.txtSuspension.inputView = self.suspensionKeyboardview
        setToolbar(txt: self.txtSuspension)
        
        if(self.arrSuspension.count == 1) {
            self.txtSuspension.text = self.arrSuspension.object(at: 0) as? String
        }
    }
    
    func setSuperChargingPicker() {
        self.superChargingKeyboardview.Values = self.arrSuperCharging as! [String]
        self.superChargingKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.superChargingKeyboardview.onDateSelected = { (Value: String) in
            self.txtSuperCharging.text = Value
        }
        self.txtSuperCharging.inputView = self.superChargingKeyboardview
        setToolbar(txt: self.txtSuperCharging)
        
        if(self.arrSuperCharging.count == 1) {
            self.txtSuperCharging.text = self.arrSuperCharging.object(at: 0) as? String
        }
    }
    
    func setWheelsPicker() {
        self.wheelsKeyboardview.Values = self.arrWheels as! [String]
        self.wheelsKeyboardview.Font = UIFont(name: "SourceSansPro-Regular", size: 20)
        self.wheelsKeyboardview.onDateSelected = { (Value: String) in
            self.txtWheels.text = Value
        }
        self.txtWheels.inputView = self.wheelsKeyboardview
        setToolbar(txt: self.txtWheels)
        
        if(self.arrWheels.count == 1) {
            self.txtWheels.text = self.arrWheels.object(at: 0) as? String
        }
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
    //MARK: Validation
    func ValidateTextField(tag:Int) -> Bool
    {
        if tag == 7{
            if txtVIN.text == "" {
                utils.addLineToTextfield(textField: txtVIN, color: .red)
                return false
            }
            if txtCarModel.text == "" {
                utils.addLineToTextfield(textField: txtCarModel, color: .red)
                return false
            }
            if txtYear.text == "" {
                utils.addLineToTextfield(textField: txtYear, color: .red)
                return false
            }
            if txtTrims.text == "" {
                utils.addLineToTextfield(textField: txtTrims, color: .red)
                return false
            }
            if txtRoof.text == "" {
                utils.addLineToTextfield(textField: txtRoof, color: .red)
                return false
            }
            if txtExteriorColor.text == "" {
                utils.addLineToTextfield(textField: txtExteriorColor, color: .red)
                return false
            }
            if txtInteriorColor.text == "" {
                utils.addLineToTextfield(textField: txtInteriorColor, color: .red)
                return false
            }
        }
        if tag == 8 {
            if txtAutoPilot.text == "" {
                utils.addLineToTextfield(textField: txtAutoPilot, color: .red)
                return false
            }
            if txtCharger.text == "" {
                utils.addLineToTextfield(textField: txtCharger, color: .red)
                return false
            }
            if txtTrunk.text == "" {
                utils.addLineToTextfield(textField: txtTrunk, color: .red)
                return false
            }
            if txtSuspension.text == "" {
                utils.addLineToTextfield(textField: txtSuspension, color: .red)
                return false
            }
            if txtSuperCharging.text == "" {
                utils.addLineToTextfield(textField: txtSuperCharging, color: .red)
                return false
            }
            if txtWheels.text == "" {
                utils.addLineToTextfield(textField: txtWheels, color: .red)
                return false
            }
        }
        if tag == 9 {
            if arrNoteableOptions.count == 0 {
                return false
            }
        }
        if tag == 10 {
            if arrMarketOptions.count == 0 {
                return false
            }
        }
        if tag == 12 {
            if self.arrImages.count == 0{
                utils.alertShow(title: kAppName, message: "Atleast 1 car image is required", view: self)
                return false
            }
        }
        return true
    }

    //MARK: TableView delegate and datasources methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 40) {
            return arrNoteableOptions.count
        } else {
            return arrMarketOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView.tag == 40) {
            var cell: NoteableCell! = tableView.dequeueReusableCell(withIdentifier: "NoteableCell") as? NoteableCell
            if cell == nil {
                tableView.register(UINib(nibName: "NoteableCell", bundle: nil), forCellReuseIdentifier: "NoteableCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "NoteableCell") as? NoteableCell
            }
            
            cell.lblNoteable.text = (self.arrNoteableOptions[indexPath.row] as AnyObject).value(forKey: "choice") as? String
            cell.switchNoteable.addTarget(self, action: #selector(self.switchNoteableChanged(_:)), for: .valueChanged)
            cell.switchNoteable.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.switchNoteable.tag = indexPath.row + 12356980
            let isOn = switchNoteableData.object(at: indexPath.row) as! Bool
            cell.switchNoteable.isOn = isOn
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        } else {
            var cell: MarketCell! = tableView.dequeueReusableCell(withIdentifier: "MarketCell") as?MarketCell
            if cell == nil {
                tableView.register(UINib(nibName: "MarketCell", bundle: nil), forCellReuseIdentifier: "MarketCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell") as? MarketCell
            }
            
            cell.lblMarket.text = (self.arrMarketOptions[indexPath.row] as AnyObject).value(forKey: "name") as? String
            cell.switchMarket.addTarget(self, action: #selector(self.switchMarketChanged(_:)), for: .valueChanged)
            cell.switchMarket.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            cell.switchMarket.tag = indexPath.row + 236598745
            cell.switchMarket.isOn = switchMarketData.object(at: indexPath.row) as! Bool
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: TableView's button actions
    @objc func switchNoteableChanged(_ sender : UISwitch!){
        // Noteable Switch
        let tag = sender.tag - 12356980
        switchNoteableData.removeObject(at: tag)
        switchNoteableData.insert(sender.isOn, at: sender.tag)
    }
    
    @objc func switchMarketChanged(_ sender : UISwitch!){
        // Market Switch
        let tag = sender.tag - 236598745
        switchMarketData.removeObject(at: tag)
        switchMarketData.insert(sender.isOn, at: sender.tag)
    }
  
    //MARK: Add and edit api call
    func addEditCar() {
        self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
        var url = "\(BaseURL)\(addcar)"
        if isForEdit {
            url = "\(BaseURL)\(editcar)"
        }
        let requestURL: URL = URL(string: url)!
        var dictNoteable = ""
        var dictMarket = ""
        var dictCarImages = ""
        do
        {
            var dataParameters = Data()
            dataParameters = try JSONSerialization.data(withJSONObject: self.arrNoteableData, options: JSONSerialization.WritingOptions(rawValue: 0))
            dictNoteable = String(data: dataParameters, encoding: .utf8)!
        } catch {}
        
        do
        {
            var marketParameters = Data()
            marketParameters = try JSONSerialization.data(withJSONObject: self.arrMarketData, options: JSONSerialization.WritingOptions(rawValue: 0))
            dictMarket = String(data: marketParameters, encoding: .utf8)!
        } catch {}
        
        do
        {
            var marketParameters = Data()
            marketParameters = try JSONSerialization.data(withJSONObject: self.model.carimagesURL, options: JSONSerialization.WritingOptions(rawValue: 0))
            print(marketParameters)
            dictCarImages = String(data: marketParameters, encoding: .utf8)!
        } catch {}
        
        var params:Parameters = [
            "year": self.txtYear.text!,
            "vin": vinNumber,
            "model": String(self.model_id),
            "battery": self.txtTrims.text!,
            "roof": self.txtRoof.text!,
            "exteriorColor": self.ex_ColorId,
            "interiorColor": self.in_ColorId,
            "charger": self.txtCharger.text!,
            "wheels": self.txtWheels.text!,
            "suspension": self.txtSuspension.text!,
            "liftgateOrTrunk": self.txtTrunk.text!,
            "superCharging": self.txtSuperCharging.text!,
            "autopilot": self.txtAutoPilot.text!,
            "carNickname": self.txtCarNickName.text!,
            "frimwareVersion": self.txtFirmware.text!,
            "orderDate": self.strOrderDate,
            "changeDate": self.strChangeDate,
            "deliverDate": self.strDeliveryDate,
            "isFirstOwner": self.switchOwner.isOn ? "true" : "false",
            "optiondata": dictNoteable,
            "aftermarketOptions": dictMarket,
            "user_id" : utils.userid,
            "motor": "",
            "drive": "",
            "onVin": self.switchVin.isOn ? "true" : "false",
            "removecarImages":dictCarImages
        ]
        
        if isForEdit {
            params["car_id"] = self.model.carId
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for img in self.arrImages {
                multipartFormData.append(UIImageJPEGRepresentation(img as! UIImage, 1)!, withName: "carImage", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
        }, to:requestURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload
                    .validate()
                    .responseJSON { response in
                        self.stopAnimating()
                        print(response)
                        switch response.result {
                        case .success(let value):
                            print("responseObject: \(value)")
                            let stauts = (response.result.value as! NSDictionary).value(forKey: "status") as! Int
                            let msg = (response.result.value as! NSDictionary).value(forKey: "message") as! String
                            
                            if stauts == 1{
                                let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                self.navigationController?.pushViewController(nextPage, animated: true)
                            } else {
                                utils.alertShow(title: kAppName, message: msg, view: self)
                            }
                        case .failure(let responseError):
                            utils.alertShow(title: kAppName, message: "The request timed out", view: self)
                            print("responseError: \(responseError)")
                        }
                }
            case .failure(let encodingError):
                self.stopAnimating()
                print(encodingError)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtVIN {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: Get products based on entered vin
    func vinRelatedProcedureAfterValidation(tag:Int){
        self.scrViewTag = tag + 7
        if let view = self.view.viewWithTag(tag-5)  {
            self.swipeback()
            self.view.bringSubview(toFront: view)
        }
        
        self.getNoteableOptions(category: "AutoPilot")
        self.getNoteableOptions(category: "Charger")
        self.getNoteableOptions(category: "Liftgate/Trunk")
        self.getNoteableOptions(category: "Supercharging")
        self.getNoteableOptions(category: "Suspension")
        self.getWheels()
    }

    //MARK: IBActions
    @IBAction func onClick_Next(_ sender: UIButton) {
        self.currentViewTag = sender.tag
        
        if !switchVin.isOn {
            vinNumber = txtVIN.text!
        }
        
        if ValidateTextField(tag: sender.tag){
            if (sender.tag == 12) {
                addEditCar()
            } else if (sender.tag == 7) {
                if isForEdit {
                    vinRelatedProcedureAfterValidation(tag: sender.tag)
                }else{
                    self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
                    utils.checkVINNumber(vin: vinNumber) { (isValid, message) in
                        if isValid {
                            self.vinRelatedProcedureAfterValidation(tag: sender.tag)
                        }else{
                            self.isVinApproved = "false"
                            utils.alertShow(title: kAppName, message: message, view: self)
                            utils.addLineToTextfield(textField: self.txtVIN, color: .red)
                        }
                        self.stopAnimating()
                    }
                }
            } else if (sender.tag == 8) {
                self.getAllNoteableOptions()
                scrViewTag = sender.tag + 7
                if let view = self.view.viewWithTag(sender.tag-5){
                    self.swipeback()
                    self.view.bringSubview(toFront: view)
                }
            } else if (sender.tag == 9) {
                
                for i in 0...arrNoteableOptions.count-1 {
                    let cell = tblNoteable.cellForRow(at: IndexPath(row: i, section: 0)) as! NoteableCell
                    
                    let slug = (self.arrNoteableOptions[i] as AnyObject).value(forKey: "slug") as? String
                    let name = (self.arrNoteableOptions[i] as AnyObject).value(forKey: "category") as? String
                    if cell.switchNoteable.isOn {
                        let dictNoteableData = NSMutableDictionary()
                        dictNoteableData.setValue(slug!, forKeyPath: "slug")
                        dictNoteableData.setValue(name!, forKeyPath: "name")
                        arrNoteableData.add(dictNoteableData)
                    }
                }

                self.getAfterMarketOption()
                scrViewTag = sender.tag + 7
                if let view = self.view.viewWithTag(sender.tag-5){
                    self.swipeback()
                    self.view.bringSubview(toFront: view)
                }
            }else if (sender.tag == 10) {
                for i in 0...arrMarketOptions.count-1 {
                    if let cell = tblMarket.cellForRow(at: IndexPath(row: i, section: 0)) as? MarketCell {
                        
                        let slug = (self.arrMarketOptions[i] as AnyObject).value(forKey: "slug") as? String
                        let name = (self.arrMarketOptions[i] as AnyObject).value(forKey: "name") as? String
                        if cell.switchMarket.isOn {
                            let dictNoteableData = NSMutableDictionary()
                            dictNoteableData.setValue(slug!, forKeyPath: "slug")
                            dictNoteableData.setValue(name!, forKeyPath: "name")
                            arrMarketData.add(dictNoteableData)
                        }
                    }
                }
                scrViewTag = sender.tag + 7
                if let view = self.view.viewWithTag(sender.tag-5){
                    self.swipeback()
                    self.view.bringSubview(toFront: view)
                }
            } else {
                scrViewTag = sender.tag + 7
                if let view = self.view.viewWithTag(sender.tag-5){
                    self.swipeback()
                    self.view.bringSubview(toFront: view)
                }
            }
        }
    }
    
   
    @IBAction func btnInfoClicked(_ sender: Any) {
        // Prepare the popup assets
        let title = "Just enter the numbers as show in the example \n\n 2018.26 \n\n 2018.24.1 \n"
        let message = "Please leave off trailing 7 numbers and digit string"
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil)
        
        // This button will not the dismiss the dialog
        let ok = DefaultButton(title: "Got it!", dismissOnTap: false) {
            self.dismiss(animated: true, completion: nil)
        }
        
        popup.addButtons([ok])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func btnBack_Click(_ sender: UIButton) {
        if (self.currentViewTag == 6 || self.currentViewTag == 0) {
            self.navigationController?.popViewController(animated: true)
        } else if let view = self.view.viewWithTag(self.currentViewTag-6) {
            self.currentViewTag = self.currentViewTag-1
            self.view.bringSubview(toFront: view)
        }
    }

    @IBAction func add_image(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Upload Profile picture", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let pickfromgallery = UIAlertAction(title: "Pick from Gallery", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.modalPresentationStyle = .popover
                if UIDevice.current.userInterfaceIdiom == .pad {
                    let popover = UIPopoverController(contentViewController: self.picker)
                    popover.present(from: self.view.bounds, in: self.view, permittedArrowDirections: .any, animated: true)
                    self.popOver = popover
                }
                else {
                    self.present(self.picker, animated: true, completion: nil)
                }
                self.picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
            }
        })
        let takeaphoto = UIAlertAction(title: "Take a Photo", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            }else {
                self.noCamera()
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        alertController.addAction(pickfromgallery)
        alertController.addAction(takeaphoto)
        alertController.addAction(cancel)
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = (sender as AnyObject).bounds
        }
        present(alertController, animated: false, completion: nil)
    }

    @IBAction func onChanged_VINSwitch(_ sender: Any) {
        if !switchVin.isOn{
            txtVIN.text = vinNumber
        }else{
            vinNumber = txtVIN.text!
            var Password = ""
            for i in 0..<vinNumber.count {
                if i < 11{
                    Password += "X"
                }else{
                    let strIndex = vinNumber[i]
                    Password += String(strIndex)
                }
            }
            txtVIN.text = Password
        }
    }

    //MARK: Textfield delegate method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtVIN && switchVin.isOn{
            if textField == txtVIN {
                var hashPassword = String()
                let newChar = string.first
                let offsetToUpdate = vinNumber.index(vinNumber.startIndex, offsetBy: range.location)
                
                if string == "" {
                    vinNumber.remove(at: offsetToUpdate)
                    return true
                }
                else {
                    if vinNumber.count < 17 {
                        vinNumber.insert(newChar!, at: offsetToUpdate)
                    }
                }
                
                if (textField.text?.count)! < 11{
                    for _ in 0..<vinNumber.count {  hashPassword += "X" }
                    textField.text = hashPassword
                }else if (textField.text?.count)! > 16{
                    return false
                }else
                {
                    textField.text!.insert(newChar!, at: offsetToUpdate)
                }
                return false
            }
            return vinTextfieldShouldChange(textfield:textField, range:range, string:string)
        } else {
            if(textField == txtVIN) {
                let newLength = textField.text!.count + string.count - range.length
                let isReturn = (newLength < 18)
                if !isReturn{
                    txtCarModel.becomeFirstResponder()
                }
                vinNumber = textField.text!
                return isReturn
            }
            return true
        }
    }

    //MARK: Vin character limitation
    func vinTextfieldShouldChange(textfield: UITextField, range: NSRange, string: String)-> Bool{
        if textfield.text != "" && textfield == txtVIN {
            let newLength = textfield.text!.count + string.count - range.length
            let isReturn = (newLength <= 17)
            if !isReturn{
                txtCarModel.becomeFirstResponder()
            }
            return isReturn
        }
        return true
    }

    //MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if  let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            btnAddCar.isHidden = true
            self.arrImages.add(chosenImage)
            self.collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
            utils.alertShow(title: kAppName, message: "Invalid media type selected", view: self)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func noCamera(){
        utils.alertShow(title: kAppName, message: "Sorry, this device has no camera", view: self)
    }
}

extension RegisterCarVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(arrImages.count>2){
            return arrImages.count
        }else{
            return arrImages.count + 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageColletionViewCell
        if(indexPath.row == arrImages.count){
            cell.imgCar.image = #imageLiteral(resourceName: "plus")
            cell.btnAddCar.addTarget(self, action: #selector(add_image(_:)), for: .touchUpInside)
            cell.btnClose.isHidden = true
        }else{
            let image = arrImages.object(at: indexPath.row) as! UIImage
            cell.imgCar.image = image
            cell.btnClose.tag = indexPath.row + 100000
            cell.btnClose.addTarget(self, action: #selector(removeCarImage(_:)), for: .touchUpInside)
            cell.btnClose.isHidden = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-5, height: (collectionView.frame.height/2)-5)
    }
    
    @objc func removeCarImage(_ sender:UIButton){
        let tag = sender.tag - 100000
        arrImages.removeObject(at: tag)
        collectionView.reloadData()
        if arrImages.count == 0{
            btnAddCar.isHidden = false
        }
    }
}
