//
//  AppConstant.swift
//  TotalTesla
//
//  Created by Coldfin on 9/14/18.
//  Copyright © 2018 Coldfin. All rights reserved.
//

import Foundation
import UIKit

let utils : CommonUtility = CommonUtility()

let MESSAGE = "Total Tesla first commit----"

let kAppName = "TotalTesla"
let themeColor = UIColor(red:0.00, green:0.62, blue:0.95, alpha:1.0)

//let BaseURL = "http://18.223.241.133:8012/api/"
let BaseURL = "https://www.totaltesla.com/api/"
let COUNTRYURL = "http://geodata.solutions/api/api.php?type=getCountries"
let STATEURL = "http://geodata.solutions/api/api.php?type=getStates&countryId="
let CITYURL = "http://geodata.solutions/api/api.php?type=getCities&countryId="
let INSTAGRAM_ACCESSTOKEN = "https://api.instagram.com/v1/users/self/?access_token="
let INSTAGRAM_LOGOUT = "https://instagram.com/accounts/logout"

let checkSocialUsername = "checkSocialUsername"
let checkSocialEmail = "checkSocialEmail"
let authenticate = "authenticate"
let register = "register"
let addUsername = "addUsername"
let getCarModels = "getCarModels"
let getProductionYear = "getProductionYear"
let getTrimsOption = "getTrimsOption"
let getRoofOption = "getRoofOption"
let getInteriorColor = "getInteriorColor"
let getExteriorColor = "getExteriorColor"
let getSingleNotebleOption = "getSingleNotebleOption"
let getAfterMarketOption = "getAfterMarketOption"
let getWheels = "getWheels"
let getCategoryResult = "getCategoryResult"
let addcar = "addcar"
let editcar = "editcar"
let getallcar = "getallcar"
let addCarLike = "addCarLike"
let getcardetail = "getcardetail"

// Indicator Size Constants
let indicatorSize = CGSize(width: 50, height:50)

let GOOGLE_CLIENT_ID = "741617625136-fuq6m8fsmpck1ut7vmm35o3qeej4tj3a.apps.googleusercontent.com"

let CAR_DEFAULT_URL = "https://s3.us-east-2.amazonaws.com/teslaweb-images/15400194061721537773721190software_update.jpg"

struct INSTAGRAM_IDS {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "61b510b378944ddcb562e790c5850bb7"
    
    static let INSTAGRAM_CLIENTSERCRET = "360abf23c2d64553855defbc00bef601"
    
    static let INSTAGRAM_REDIRECT_URI = "http://com.totaltesla"
    
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
}

