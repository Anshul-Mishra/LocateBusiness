//
//  CommonClass.swift
//  SFApp
//
//  Created by mac on 18/06/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import Alamofire

class CommonClass {
    
    class func getScreenSize() -> Double {
        return Double(UIScreen.main.bounds.size.height)
    }
    
    class func getNetworkStatus() -> Bool {
        return (NetworkReachabilityManager.init()?.isReachable)!
    }
    
    class func setColorFromRGB(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
}

class CustomView: UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
}
