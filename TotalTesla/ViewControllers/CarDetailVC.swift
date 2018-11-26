//
//  CarDetailVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/13/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AVFoundation
import ImageSlideshow
import AFNetworking

class CarDetailVC: UIViewController, NVActivityIndicatorViewable, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var lblInteriorColor: UILabel!
    @IBOutlet weak var lblExteriorColor: UILabel!
    @IBOutlet weak var lblCarModel: UILabel!
    @IBOutlet weak var lblCarName: UILabel!
    @IBOutlet weak var lblMotor: UILabel!
    @IBOutlet weak var lblDrive: UILabel!
    @IBOutlet weak var lblRoof: UILabel!
    @IBOutlet weak var lblVIN: UILabel!
    @IBOutlet weak var lblFirmware: UILabel!
    @IBOutlet weak var lblUSername: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var tblNoteable: UICollectionView!
    @IBOutlet weak var tblMarket: UICollectionView!
    @IBOutlet weak var btnExteriorColor: UIButton!
    @IBOutlet weak var btnIneriorColor: UIButton!
    @IBOutlet weak var lblNoOfLikes: UILabel!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var viewDetails: UIView!
    
    var carName: NSString = ""
    var arrNoteable : NSMutableArray = NSMutableArray()
    var arrMarket : NSMutableArray = NSMutableArray()
    let model = CarDetailModel()
    var totalLike: Int = 0
    var afNetworkingSource = [AFURLSource(urlString: CAR_DEFAULT_URL)!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCarDetails()
    }

    override func viewDidDisappear(_ animated: Bool) {
        slideshow.removeFromSuperview()
    }
    
    func slideshowForCarGallery() {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = .scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0/255, green: 159/255, blue: 243/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(afNetworkingSource)
        print(afNetworkingSource)
        
        self.model.carimages.removeAllObjects()
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        var count = 0
        for image in slideshow.images {
            let imageView = UIImageView()
            image.load(to: imageView) { img in
                self.model.carimages.add(img as? UIImage)
                if(self.model.carimages.count-1 == count){
//                    self.stopAnimating()
//                    return
                }
            }
            count += 1
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    func setCarData(){
        self.lblCarName.text = model.carNickname
        self.lblCarModel.text = NSString(format: "%d Tesla %@ %@", model.year, model.modelname, model.battery) as String
        self.lblExteriorColor.text = model.exterior_color_name
        self.btnExteriorColor.backgroundColor = UIColor(hexString: model.exterior_html_color)
        self.lblInteriorColor.text =  model.interior_color_name
        self.btnIneriorColor.backgroundColor = UIColor(hexString: model.interior_html_color)
        self.lblRoof.text = model.roof
        self.lblMotor.text = "\(model.motors)"
        self.lblDrive.text = model.drive
        if(model.isMask == "true") {
            let v = (model.vin as NSString).replacingCharacters(
                in: NSMakeRange(0,11), with: "XXXXXXXXXXX")
            
            self.lblVIN.text = v
        } else {
            self.lblVIN.text = model.vin
        }
        self.lblFirmware.text = model.frimwareVersion
        self.lblUSername.text = model.username
        self.lblNoOfLikes.text = "\(model.total_likes)"
        self.lblLocation.text = model.location
        if model.carUserId == utils.userid{
            editBarButton.isEnabled = true
            editBarButton.title = "Edit"
        }
    }
    
    func getCarDetails() {
        self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
        let url = "\(BaseURL)\(getcardetail)"
        let requestURL: URL = URL(string: url)!
        
        let params: [String: Any] = ["slug" : carName ]
        
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success(let data):
                    print(data)
                    let arrCar : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    let stauts = (data as! NSDictionary).value(forKey: "status") as! Int
                    self.stopAnimating()
                    self.viewDetails.isHidden = false

                    if stauts == 0 {
                        
                        for car in arrCar {
                            if let userID = (car as AnyObject).object(forKey: "user_id") as? Int {
                                self.model.carUserId = String(userID)
                            }
                            if let name = (car as AnyObject).object(forKey: "carNickname") as? String {
                                self.model.carNickname = name
                            }
                            
                            if let year = (car as AnyObject).object(forKey: "year") as? Int{
                                self.model.year = year
                            }
                            if let name = (car as AnyObject).object(forKey: "modelname") as? String {
                                self.model.modelname = name
                            }
                            if let modelId = (car as AnyObject).object(forKey: "model") as? String {
                                self.model.modelId = modelId
                            }
                            if let battery = (car as AnyObject).object(forKey: "battery") as? String{
                                self.model.battery = battery
                            }
                            if let orderDate = (car as AnyObject).object(forKey: "orderDate") as? String{
                                self.model.orderDate = orderDate
                            }
                            if let changeDate = (car as AnyObject).object(forKey: "changeDate") as? String {
                                self.model.changeDate = changeDate
                            }
                            if let deliverDate = (car as AnyObject).object(forKey: "deliverDate") as? String {
                                self.model.deliveryDate = deliverDate
                            }
                            if let isFirstOwner = (car as AnyObject).object(forKey: "isFirstOwner") as? String {
                                self.model.isFirstOwner = isFirstOwner
                            }
                            if let viewExteriorColor = (car as AnyObject).object(forKey: "exterior_html_color") as? String {
                                self.model.exterior_html_color = viewExteriorColor
                            }
                            if let exteriorColor = (car as AnyObject).object(forKey: "exterior_color") as? String {
                                self.model.exterior_color_name = exteriorColor
                            }
                            if let exteriorColorID = (car as AnyObject).object(forKey: "exteriorColor") as? String {
                                self.model.exterior_color_id = exteriorColorID
                            }
                            
                            if let interiorColor = (car as AnyObject).object(forKey: "interior_color_name") as? String {
                                self.model.interior_color_name = interiorColor
                            }
                            
                            if let viewInteriorColor = (car as AnyObject).object(forKey: "interior_html_color") as? String {
                                self.model.interior_html_color = viewInteriorColor
                            }
                            
                            if let interiorColorID = (car as AnyObject).object(forKey: "interiorColor") as? String {
                                self.model.interior_color_id = interiorColorID
                            }
                            
                            if let roof = (car as AnyObject).object(forKey: "roof") as? String {
                                self.model.roof = roof
                            }
                            
                            if let motors = (car as AnyObject).object(forKey: "motors") as? Int {
                                self.model.motors = motors
                            }
                            
                            if let drive = (car as AnyObject).object(forKey: "drive") as? String {
                                self.model.drive = drive
                            }
                            
                            if let vin = (car as AnyObject).object(forKey: "vin") as? String {
                                self.model.vin = vin
                            }
                            if let isMask = (car as AnyObject).object(forKey: "isMask") as? String {
                                self.model.isMask = isMask
                            }
                            
                            if let frimwareVersion = (car as AnyObject).object(forKey: "frimwareVersion") as? String {
                                self.model.frimwareVersion = frimwareVersion
                            }
                            
                            if let username = (car as AnyObject).object(forKey: "username") as? String {
                                self.model.username = username
                            }
                            
                            if let likes = (car as AnyObject).object(forKey: "total_likes") as? Int {
                                self.totalLike = likes
                                self.model.total_likes = likes
                            }
                            
                            if let location = (car as AnyObject).object(forKey: "location") as? String {
                                self.model.location = location
                            }
                            
                            if let autopilot = (car as AnyObject).object(forKey: "autopilot") as? String {
                                self.model.autopilot = autopilot
                            }
                            
                            if let charger = (car as AnyObject).object(forKey: "charger") as? String {
                                self.model.charger = charger
                            }
                            
                            if let liftgateOrTrunk = (car as AnyObject).object(forKey: "liftgateOrTrunk") as? String {
                                self.model.liftgateOrTrunk = liftgateOrTrunk
                            }
                            
                            if let suspension = (car as AnyObject).object(forKey: "suspension") as? String {
                                self.model.suspension = suspension
                            }
                            
                            if let superCharging = (car as AnyObject).object(forKey: "superCharging") as? String {
                                self.model.superCharging = superCharging
                            }
                            
                            if let wheels = (car as AnyObject).object(forKey: "wheels") as? String {
                                self.model.wheels = wheels
                            }
                            
                            if let carId = (car as AnyObject).object(forKey: "carId") as? Int {
                                self.model.carId = "\(carId)"
                            }
                            
                            if let arrNoteable = (car as AnyObject).object(forKey: "optiondata") as? NSArray {
                                print(arrNoteable)
                                self.model.optiondata = arrNoteable
                                self.arrNoteable = NSMutableArray(array: arrNoteable)
                            }
                            
                            if let arrMarket = (car as AnyObject).object(forKey: "aftermarketOptions") as? NSArray {
                                self.model.aftermarketOptions = arrMarket
                                self.arrMarket = NSMutableArray(array: arrMarket)
                            }
                            
                            if let arrImages = (car as AnyObject).object(forKey: "carimages") as? NSArray {
                                self.afNetworkingSource.removeAll()
                                for data in arrImages {
                                    let d = data as! NSDictionary
                                    if let a = d.object(forKey: "image") as? String {
                                        self.model.carimagesURL.add(a)
                                        self.afNetworkingSource.append(AFURLSource(urlString: a)!)
                                    }
                                }
                            }
                        }
                        self.setCarData()
                        self.tblNoteable.reloadData()
                        self.tblMarket.reloadData()
                        self.slideshowForCarGallery()
                    }
                    
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 1) {
            return self.arrNoteable.count
        } else {
            return self.arrMarket.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag == 1) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteableCarCell", for: indexPath) as! NoteableCarCell
            cell.lblTitle.text = (self.arrNoteable[indexPath.row] as AnyObject).value(forKey: "name") as? String
            let img = (self.arrNoteable[indexPath.row] as AnyObject).value(forKey: "slug") as? String
            cell.imgCar.image = UIImage(named: NSString(format: "%@.png", img!) as String)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCarCell", for: indexPath) as! MarketCarCell
            cell.lblTitle.text = (self.arrMarket[indexPath.row] as AnyObject).value(forKey: "name") as? String
            let img = (self.arrMarket[indexPath.row] as AnyObject).value(forKey: "slug") as? String
            cell.imgCar.image = UIImage(named: NSString(format: "%@.png", img!) as String)
            return cell
        }
    }

    @IBAction func btnEdit_Click(_ sender: Any) {
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterCarVC") as! RegisterCarVC
        nextPage.model = model
        nextPage.isForEdit = true
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLike_Click(_ sender: Any) {
        self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
        let url = "\(BaseURL)\(addCarLike)"
        let requestURL: URL = URL(string: url)!
        
        print(utils.userid)
        
        let params: [String: Any] = ["user_id" : utils.userid,
                                     "car_id" : self.model.carId]
        print(params)
        Alamofire.request(requestURL, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let responseData):
                    let stauts = (responseData as! NSDictionary).value(forKey: "status") as! Int
                    let msg = (responseData as! NSDictionary).value(forKey: "message") as! String
                    self.stopAnimating()
                    if stauts == 1 && ((responseData as! NSDictionary).value(forKey: "data") != nil) {
                        let data = (responseData as! NSDictionary).value(forKey: "data") as AnyObject
                        let affectedRows = data.value(forKey: "affectedRows") as! Int
                        let total_likes = affectedRows + self.totalLike
                        self.totalLike = total_likes
                        self.lblNoOfLikes.text = NSString(format: "%d", total_likes) as String
                    } else if stauts == 1 && ((responseData as! NSDictionary).value(forKey: "data") == nil) {
                        let total_likes = self.totalLike - 1
                        self.lblNoOfLikes.text = NSString(format: "%d", total_likes) as String
                        self.totalLike = total_likes
                    } else {
                        utils.alertShow(title: kAppName, message: msg, view: self)
                    }
                    
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
}

class NoteableCarCell:UICollectionViewCell{
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_shadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_bg.layer.cornerRadius = 2
        view_bg.layer.masksToBounds = true
        
        view_shadow.layer.shadowOpacity = 0.3
        view_shadow.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        view_shadow.layer.shadowRadius = 2.0
        view_shadow.layer.shadowColor = UIColor.black.cgColor
    }
}

class MarketCarCell:UICollectionViewCell{
    @IBOutlet weak var imgCar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_shadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_bg.layer.cornerRadius = 2
        view_bg.layer.masksToBounds = true
        
        view_shadow.layer.shadowOpacity = 0.3
        view_shadow.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        view_shadow.layer.shadowRadius = 2.0
        view_shadow.layer.shadowColor = UIColor.black.cgColor
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
