//
//  ViewController.swift
//  TotalTesla
//
//  Created by Coldfin on 9/11/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func onClick_Register(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterCarVC") as! RegisterCarVC
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    @IBAction func btnBack_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClick_Browser(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "BrowseCarVC") as! BrowseCarVC
        self.navigationController?.pushViewController(nextPage, animated: true)
    }

    @IBAction func onClick_Statistics(_ sender: Any) {
        let carimagesURL = NSMutableArray()
        carimagesURL.add("https://s3.us-east-2.amazonaws.com/teslaweb-images/1542884193168car25.jpg")
        var dictCarImages = ""
        do
        {
            var marketParameters = Data()
            marketParameters = try JSONSerialization.data(withJSONObject: carimagesURL, options: JSONSerialization.WritingOptions(rawValue: 0))
            dictCarImages = String(data: marketParameters, encoding: .utf8)!
        } catch {}
        print(dictCarImages)
        
        let params : [String: Any] = ["removecarImages":dictCarImages,
                                      "car_id":"53",
                                      "user_id":"16"]
        print(dictCarImages)
        utils.callAPI(url: "http://18.223.241.133:8012/api/bkcardelete", method: .post, params: params, completionHandler: { dic in
            print(dic)
        })
    }
}

