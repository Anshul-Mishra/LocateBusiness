//
//  APIManager.swift
//  SFApp
//
//  Created by mac on 18/06/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

typealias ServiceResponse = (Bool,  AnyObject?, Error?) -> Void

class APIManager: NSObject {
    
    class func postRequest(url:String, params:NSDictionary? ,onCompletion: @escaping ServiceResponse) -> () {
        
        KRProgressHUD.set(style: .black)
        KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        
        let parameters = params as! [String : Any]
        
        print(url)
        print(parameters)
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            KRProgressHUD.dismiss()
            
            /*
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            */
 
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    onCompletion(true, response.result.value as AnyObject,nil)
                }
                break
                
            case .failure(_):
                onCompletion(false, nil,response.result.error)
                break
                
            }
        }
    }
    
    class func getTheAutoCompleteAddress(url:String, onCompletion: @escaping ServiceResponse) {
        
        //KRProgressHUD.set(style: .black)
        //KRProgressHUD.show(withMessage: "Loading...", completion: nil)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            KRProgressHUD.dismiss()
            
            /*
             if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
             print("Data: \(utf8Text)") // original server data as UTF8 string
             }
             */
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    onCompletion(true, response.result.value as AnyObject,nil)
                }
                break
                
            case .failure(_):
                onCompletion(false, nil,response.result.error)
                break
                
            }
        }
    }
}
