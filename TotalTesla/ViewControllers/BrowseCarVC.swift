//
//  BrowseCarVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/13/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import AFNetworking

class BrosweCarCell:UICollectionViewCell{
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

class BrowseCarVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrAllCars : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllCars()
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAllCars() {
        self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
        let url = "\(BaseURL)\(getallcar)"
        let requestURL: URL = URL(string: url)!
        
        Alamofire.request(requestURL, method: .post, parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                self.stopAnimating()
                switch response.result {
                case .success(let data):
                    let arrCar : NSArray = (data as! NSDictionary).value(forKey: "data") as! NSArray
                    self.arrAllCars = NSMutableArray(array: arrCar)
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrAllCars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrosweCarCell", for: indexPath) as! BrosweCarCell
        
        cell.lblTitle.text = (self.arrAllCars[indexPath.row] as AnyObject).value(forKey: "carNickname") as? String
        
        let arrImg = (self.arrAllCars[indexPath.row] as AnyObject).value(forKey: "carimages") as? NSArray
        if arrImg?.count != 0{
        let strImageURL = (arrImg![0] as AnyObject).value(forKey: "image") as! String
        let imageUrl = NSURL(string: strImageURL)
        
        if(imageUrl !== nil) {
            let imageRequest = NSURLRequest(url: imageUrl! as URL, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 600)
            cell.imgCar.setImageWith((imageRequest as URLRequest?)!, placeholderImage: nil, success: nil, failure: nil)
        }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: collectionView.frame.width/4 - 5, height: collectionView.frame.width/4-20);
        } else {
            return CGSize(width: collectionView.frame.width/2 - 5, height: collectionView.frame.width/2-20);
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slug = (self.arrAllCars[indexPath.row] as AnyObject).value(forKey: "slug") as! NSString
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "CarDetailVC") as! CarDetailVC
        nextPage.carName = slug as! NSString
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
}
