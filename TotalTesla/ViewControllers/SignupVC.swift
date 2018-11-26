//
//  SignupVC.swift
//  TotalTesla
//
//  Created by Coldfin on 9/13/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import Alamofire

class SignupVC: UIViewController,NVActivityIndicatorViewable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let signIn = GIDSignIn.sharedInstance()!
        signIn.scopes = ["profile"]
        signIn.uiDelegate = self
        signIn.delegate = self
        signIn.clientID = GOOGLE_CLIENT_ID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onCLick_Google(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onClick_Twitter(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
                let twitterClient = TWTRAPIClient(userID: session?.userID)
                twitterClient.loadUser(withID: (session?.userID)!) { (user, error) in
                    let params: [String: Any] = ["username" : (session?.userName)!,
                                                 "socialtype": "twitter"]
                    utils.callAPI(url: "\(BaseURL)\(checkSocialUsername)", method: .post, params: params, completionHandler: {dic in
                        let status = dic.value(forKey: "status") as! Int
                        if status == 1{
                            let data = dic.value(forKey: "data") as! NSArray
                            let userInfo = data.object(at: 0) as! NSDictionary
                            let id = userInfo.object(forKey: "id") as! Int
                            utils.userid = String(id)
                            self.redirectToHome(data: dic)
                        }else{
                            let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
                            nextPage.isTwitter = 1
                            nextPage.twitterusername = (session?.userName)!
                            nextPage.username = (session?.userName)!
                            self.navigationController?.pushViewController(nextPage, animated: true)
                        }
                        self.stopAnimating()
                    })
                }
            }else
            {

            }
        })
    }
    
    @IBAction func onClick_Instagram(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InstagramLoginVC") as! InstagramLoginVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClick_facebook(_ sender: Any) {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        let permission: [AnyObject] = ["public_profile" as AnyObject, "email" as AnyObject]
        login.logOut()
        login.logIn(withReadPermissions: permission, from: self, handler: { (result, error) -> Void in
            if error != nil {
                NSLog("error in login")
                NSLog("Error: %@ \(error as Any)")
            }
            else if (result?.isCancelled)! {
                NSLog("Press Cancel Button")
            }
            else {
                if((FBSDKAccessToken.current()) != nil) {
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, interested_in, birthday, hometown, location"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil)
                        {
                            let accessToken = FBSDKAccessToken.current().tokenString
                            NSLog("accessToken: %@ \((result as! NSDictionary))")
                            if (accessToken != nil) {
                
                                var name:String = ""
                                if let userData = (result as! NSDictionary).value(forKey: "name") as? String
                                {
                                    name = userData
                                }
                                
                                var email:String = ""
                                if let userData = (result as! NSDictionary).value(forKey: "email") as? String
                                {
                                    email = userData
                                }
                                self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
                                let params: [String: Any] = ["email" : email,
                                                             "socialtype": "facebook",
                                                             "username":name,
                                                             ]
                                utils.callAPI(url: "\(BaseURL)\(checkSocialEmail)", method: .post, params: params, completionHandler: {dic in
                                    let status = dic.value(forKey: "status") as! Int
                                    if status == 1{
                                        let data = dic.value(forKey: "data") as! NSArray
                                        let userInfo = data.object(at: 0) as! NSDictionary
                                        let id = userInfo.object(forKey: "id") as! Int
                                        utils.userid = String(id)
                                        print(id)
                                        self.redirectToHome(data: dic)
                                    }else{
                                        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
                                        nextPage.email = email
                                        nextPage.isFB = 1
                                        nextPage.fbusername = name
                                        nextPage.username = name
                                        self.navigationController?.pushViewController(nextPage, animated: true)
                                    }
                                    self.stopAnimating()
                                })
                            }
                        }
                        else{
                            NSLog("Error: %@\(error!)")
                        }
                    })
                }else{
                    NSLog("current access token is nil ")
                }
            }
        })
    }
    @IBAction func onClick_SignIn(_ sender: Any) {}
    
    func redirectToHome(data: NSDictionary) {
        self.navigationController?.isNavigationBarHidden = true
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    func redirectToLinkPage(data: NSDictionary, username: String, socialType: String) {
        self.navigationController?.isNavigationBarHidden = true
        let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "LinkEmailVC") as! LinkEmailVC
        nextPage.username = username
        nextPage.socialtype = socialType
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
}

extension SignupVC:InstaLogindelegate{
    func doneLogin(token: String) {
        let url = "\(INSTAGRAM_ACCESSTOKEN)\(token)"
        let requestURL: URL = URL(string: url)!
        
        Alamofire.request(requestURL, method: .get, parameters: nil)
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let dicData = (data as! NSDictionary).value(forKey: "data")
                    let username = (dicData as! NSDictionary).value(forKey: "username")
                    self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)
                    let params: [String: Any] = ["username" : username!,
                                                 "socialtype": "instagram"]
                    utils.callAPI(url: "\(BaseURL)\(checkSocialUsername)", method: .post, params: params, completionHandler: {dic in
                        let status = dic.value(forKey: "status") as! Int
                        
                        if status == 1{
                            let id = (dicData as! NSDictionary).value(forKey: "id")
                            utils.userid = id as! String
                            self.redirectToHome(data: dic)
                        }else{
                            let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
                            nextPage.isInsta = 1
                            nextPage.instausername = username! as! String
                            nextPage.username = username! as! String
                            
                            self.navigationController?.pushViewController(nextPage, animated: true)
                        }
                        self.stopAnimating()
                    })
                case .failure(let error):
                    print(error)
                    self.stopAnimating()
                }
        }
    }
}

extension SignupVC: GIDSignInUIDelegate,GIDSignInDelegate
{
    // MARK: - Google Signin
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if (error == nil) {
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true) {
            //nothing
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true) {
            //nothing
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError : Error!) {
        if(withError == nil) {
            self.startAnimating(indicatorSize, message: nil, type: NVActivityIndicatorType(rawValue: 23)!)

            let params: [String: Any] = ["email" : user.profile.email!,
                                         "socialtype": "google",
                                         "username":user.profile.name!,
                                        ]

            utils.callAPI(url: "\(BaseURL)\(checkSocialEmail)", method: .post, params: params, completionHandler: {dic in
                let status = dic.value(forKey: "status") as! Int
                if status == 1{
                    let data1 = dic.value(forKey: "data") as! NSArray
                    let userInfo = data1.object(at: 0) as! NSDictionary
                    let id = userInfo.object(forKey: "id") as! Int
                    utils.userid = String(id)
                    self.redirectToHome(data: dic)
                }else{
                    let nextPage = self.storyboard?.instantiateViewController(withIdentifier: "ProfileInfoVC") as! ProfileInfoVC
                    nextPage.email = user.profile.email!
                    nextPage.isGoogle = 1
                    nextPage.googleusername = user.profile.name!
                    nextPage.username = user.profile.name!
                    self.navigationController?.pushViewController(nextPage, animated: true)
                }
                self.stopAnimating()
            })
        }
    }
}
