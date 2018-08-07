//
//  Constant.swift
//  SFApp
//
//  Created by mac on 18/06/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit

let APP_NAME = "SFApp"

let GOOGLE_PLACE_API_KEY = "AIzaSyAhC-aZZe0x1QP6mSD1LHf-ewvz5wzJiWQ"

var API_TYPE_TO_GET_BUSINESS = "GPS"

var SEARCHED_ADDRESS = ""

var SCREEN_WIDTH = UIScreen.main.bounds.size.width
var SCREEN_HEIGHT = UIScreen.main.bounds.size.height

struct URLS {
    static let BASE_URL = "https://www.signfolder.com/api/"
    static let GET_BUSINESS = "list_business/format/json"
    static let GET_BUSINESS_FROM_ADDRESS = "list_business_by_address/format/json"
    static let GET_BUSINESS_DETAIL = "storefront/"
}

struct USER_LOCATION {
    static var LATITUDE : Double = 0.0
    static var LONGITUDE : Double = 0.0
}

struct PARAMS {
    static var LIMIT = 30
    static var RADIUS = 5
    static var OFFSET = 0
}

struct COLOR_BROWN_DARK {
    static var R : CGFloat = 74
    static var G : CGFloat = 53
    static var B : CGFloat = 33
}

struct COLOR_BROWN_LIGHT {
    static var R : CGFloat = 198
    static var G : CGFloat = 147
    static var B : CGFloat = 87
}
