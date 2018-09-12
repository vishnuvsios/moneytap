//  Constants.swift
//  Sr.tn
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.

import UIKit
import Foundation

enum HTTPType: String {
    case Get = "GET"
    case Post = "POST"
}

enum Environment: String {
    case Development = "dev"
    case Production = "production"
    case LocalHost = "localhost"
}

enum ApiRequestType: Int {
    case Synchronous
    case Asynchronous
}

enum  DeviceType : CGFloat {
    case iPhone4 = 480.0
    case iPhone5 = 568.0
    case iPhone6 = 667.0
    case iPhone6Plus = 736.0
    case iPad = 1024.0
}

let deviceType = DeviceType(rawValue: UIScreen.main.bounds.size.height)
let API_VERSION = "1"
let APP_NAME = "moneyTap"
let environment = Environment.Development
var APP_BASEURL: String {
get {
     switch environment {
    case .Development:
        return "https://srtn.com/"
     case .LocalHost:
        return "https://srtn.com/"
    case .Production:
        return ""
    }
 }
}

//GET

let GETWIKIPEDIADETAILSLIST      = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=Sachin+T&gpslimit=10"


