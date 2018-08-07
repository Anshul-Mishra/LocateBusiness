//
//  Extentions.swift
//  SFApp
//
//  Created by mac on 18/06/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(with title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlertWithAction(with title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default,  handler: { (action) in
            self.okBtnTapped()
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    func okBtnTapped(){
        
    }
    
    func showAlert(with title:String? , message:String? , defaultBtn:String? , cancelBtn:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: defaultBtn, style: .default, handler: { (action) in
            self.defaultBtnTapped()
        }))
        alertController.addAction(UIAlertAction(title: cancelBtn, style: .cancel, handler: { (action) in
            self.cancelBtnTapped()
        }))
        present(alertController, animated: true, completion: nil)
    }
    func defaultBtnTapped(){
        
    }
    func cancelBtnTapped(){
        
    }
    
}

extension UIView {
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func showAlertWithActionOnView(with title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default,  handler: { (action) in
            self.okBtnTapped()
        }))
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { (action) in
            self.NewCancelButton()
        }))
        
        
    }
    func okBtnTapped(){
        
    }
    func NewCancelButton(){
        
    }
    
    func showAlertWithNOActionOnView(with title:String?, message:String?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
}
