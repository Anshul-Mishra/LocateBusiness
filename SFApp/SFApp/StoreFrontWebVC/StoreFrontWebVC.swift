//
//  StoreFrontWebVC.swift
//  SFApp
//
//  Created by mac on 10/08/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit

class StoreFrontWebVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_NavBG: UIView!
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    
    fileprivate weak var largeImageView: UIImageView!
    
    var str_BusinessTitleAndID = ""
    var str_BusinessTitle = ""
    var str_BusinessID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view_NavBG.layer.masksToBounds = false
        view_NavBG.layer.shadowColor = UIColor.black.cgColor
        view_NavBG.layer.shadowOpacity = 0.5
        view_NavBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        view_NavBG.layer.shadowRadius = 1
        
        view_NavBG.layer.shadowPath = UIBezierPath(rect: view_NavBG.bounds).cgPath
        view_NavBG.layer.shouldRasterize = true
        
        view_NavBG.layer.rasterizationScale = UIScreen.main.scale
        
        
        if str_BusinessTitleAndID != "", str_BusinessTitleAndID.contains("___") {
            
            let arr = str_BusinessTitleAndID.components(separatedBy: "___")
            str_BusinessTitle = (arr as NSArray).object(at: 0) as! String
            str_BusinessID = (arr as NSArray).object(at: 1) as! String
            lbl_Title.text = str_BusinessTitle
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if str_BusinessID != "" {
            let str = "http://signfolder.com/storefront/\(str_BusinessID)"
            
            indicator.startAnimating()
            
            webView.loadRequest(URLRequest(url: (URL(string: str))!))
            
        }
    }
    
    //MARK:- Navigation bar button action
    
    @IBAction func websiteTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func signBoardTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        indicator.stopAnimating()
    }
}
