//
//  HomeVC.swift
//  SFApp
//
//  Created by mac on 17/06/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}

class HomeVC: UIViewController, LocationManagerDelegate {
    
    @IBOutlet weak var btnSign:UIButton!
    @IBOutlet weak var btnFolder:UIButton!
    @IBOutlet weak var btnGPS:UIButton!
    @IBOutlet weak var btnMap:UIButton!
    @IBOutlet weak var btnSearch:UIButton!
    @IBOutlet weak var btnBusinessList:UIButton!
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    // Store data...
    var dic_businessData : NSDictionary?
    var arr_FrontBusinesses = NSMutableArray()
    var arr_BackBusinesses = NSMutableArray()
    var arr_Businesses = NSMutableArray()
    var arr_Categories = NSMutableDictionary()
    
    var isCellTypeSign = true
    
    // Map setup...
    
    var recentSearchView:RecentSearchView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        LocationManager.sharedInstance.getUserLocation(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- IBAction
    //MARK:- Tab Bar
    
    @IBAction func btnAction(sender:UIButton) {
        
        switch sender.tag {
        case 0:
            // sign btn action
            isCellTypeSign = true
            
            self.collectionView.reloadData()
            
        case 1:
            // folder btn action
            isCellTypeSign = false
            self.collectionView.reloadData()
            
        case 2:
            // GPS btn action
            LocationManager.sharedInstance.getUserLocation(viewController: self)
            
        case 3:
            // map btn action
            print("map button action")
            
        case 4:
            // search btn action
            self.showecentSearchView()
            
        case 5:
            // business list btn action
            print("business list btn action")
            
            
        default:
            print("unknown btn tapped")
        }
        
    }
    
    //MARK:- Set btn color
    func setBtnColor(sender:UIButton){
        
    }
    
    //MARK:- Web Service
    
    func getBusiness() {
        
        var param : [String:Any] = [:]
        param["latitude"] = USER_LOCATION.LATITUDE
        param["longitude"] = USER_LOCATION.LONGITUDE
        param["limit"] = PARAMS.LIMIT
        param["offset"] = PARAMS.OFFSET
        param["direction"] = "E"
        param["radius"] = PARAMS.RADIUS
        
        print("Params: \(param)")
        
        //https://www.signfolder.com/api/list_business/format/json
        
        APIManager.postRequest(url: "\(URLS.BASE_URL)\(URLS.GET_BUSINESS)", params: param as NSDictionary?) { (isSuccess, response, error) in
            
            print("\(String(describing: response))")
            
            if error != nil {
                self.showAlert(with: APP_NAME, message: error?.localizedDescription)
            }
            
            if isSuccess {
                
                if let status = (response as? NSDictionary)?.object(forKey: "status"), (status is NSString) {
                    
                    if (status as! NSString) == "listed" {
                        self.dic_businessData = response as? NSDictionary
                        
                        self.arr_FrontBusinesses = NSMutableArray()
                        self.arr_BackBusinesses = NSMutableArray()
                        self.arr_Businesses = NSMutableArray()
                        
                        if let leftTopTempArr = (response as? NSDictionary)?.object(forKey: "lefttop"), (leftTopTempArr is NSArray) {
                            
                            if (leftTopTempArr as! NSArray).count > 0 {
                                self.arr_FrontBusinesses.addObjects(from: (leftTopTempArr as! NSArray) as! [Any])
                            }
                        }
                        
                        if let rightTopTempArr = (response as? NSDictionary)?.object(forKey: "righttop"), (rightTopTempArr is NSArray) {
                            
                            if (rightTopTempArr as! NSArray).count > 0 {
                                self.arr_FrontBusinesses.addObjects(from: (rightTopTempArr as! NSArray) as! [Any])
                            }
                        }
                        
                        if let leftBottomTempArr = (response as? NSDictionary)?.object(forKey: "leftbottom"), (leftBottomTempArr is NSArray) {
                            
                            if (leftBottomTempArr as! NSArray).count > 0 {
                                self.arr_BackBusinesses.addObjects(from: (leftBottomTempArr as! NSArray) as! [Any])
                            }
                        }
                        
                        if let rightBottomTempArr = (response as? NSDictionary)?.object(forKey: "rightbottom"), (rightBottomTempArr is NSArray) {
                            
                            if (rightBottomTempArr as! NSArray).count > 0 {
                                self.arr_BackBusinesses.addObjects(from: (rightBottomTempArr as! NSArray) as! [Any])
                            }
                        }
                        
                        self.arr_Categories.removeAllObjects()
                        
                        if let leftCategory = ((response as? NSDictionary)?.object(forKey: "result") as? NSDictionary)?.object(forKey: "left"), (leftCategory is NSDictionary) {
                            
                            self.arr_Categories.addEntries(from: (leftCategory as! NSDictionary) as! [AnyHashable : Any])
                        }
                        
                        if let rightCategory = ((response as? NSDictionary)?.object(forKey: "result") as? NSDictionary)?.object(forKey: "right"), (rightCategory is NSDictionary) {
                            
                            self.arr_Categories.addEntries(from: (rightCategory as! NSDictionary) as! [AnyHashable : Any])
                        }
                        
                        if self.arr_FrontBusinesses.count > 0 {
                            self.arr_Businesses.addObjects(from: self.arr_FrontBusinesses as! [Any])
                        }
                        if self.arr_BackBusinesses.count > 0 {
                            self.arr_Businesses.addObjects(from: self.arr_BackBusinesses as! [Any])
                        }
                        
                        self.collectionView.reloadData()
                    } else {
                        self.showAlert(with: APP_NAME, message: "No Business found")
                    }
                } else {
                    self.showAlert(with: APP_NAME, message: "No Business found")
                }
            } else {
                self.showAlert(with: APP_NAME, message: "No Business found")
            }
        }
    }
    
    //MARK:- LocationManagerDelegate
    
    func getCurrentLocation(location: CLLocation) {
        
        USER_LOCATION.LATITUDE = location.coordinate.latitude
        USER_LOCATION.LONGITUDE = location.coordinate.longitude
        
        self.getBusiness()
    }
    
    func errorInLocationManager() {
        self.showAlert(with: "Location Error", message: "Unable to fetch location.")
    }
}

//MARK:- Collection View Extention

extension HomeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arr_Businesses.count > 0 {
            return arr_Businesses.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isCellTypeSign {
            
            let cell:SignCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignCell", for: indexPath) as! SignCell
                        
            if let businessImage = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "image"), (businessImage is NSString), ((businessImage as! NSString) != "") {
                
                cell.image_Business.isHidden = false
                cell.lbl_Business.isHidden = true
                //cell.lbl_Business.text = ""
                cell.image_Business.sd_setImage(with: NSURL(string: businessImage as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
                
            } else {
                
                cell.image_Business.isHidden = true
                cell.lbl_Business.isHidden = false
                //cell.image_Business.image = UIImage()
                
                if let businessTitle = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "title"), (businessTitle is NSString) {
                    cell.lbl_Business.text = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
                } else {
                    cell.lbl_Business.text = "Business name not available"
                }
            }
            
            return cell
            
        } else {
            
            let cell:FolderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
            
            if let businessImage = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "image"), (businessImage is NSString), ((businessImage as! NSString) != "") {
                cell.image_Business.sd_setImage(with: NSURL(string: businessImage as! String)! as URL, placeholderImage: UIImage(named: "placeholder.png"))
            } else {
                cell.image_Business.image = UIImage()
            }
            
            if let businessTitle = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "title"), (businessTitle is NSString) {
                cell.lbl_Business.text = (arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String
            } else {
                cell.lbl_Business.text = "Business name not available"
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storeFrontWebViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StoreFrontWebVC") as! StoreFrontWebVC
        
        storeFrontWebViewVC.str_BusinessTitleAndID = "\(String(describing: ((arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "title") as? String)!))___\(String(describing: ((arr_Businesses.object(at: indexPath.row) as! NSDictionary).object(forKey: "id") as? String)!))"
        
        if isCellTypeSign {
            if let imageCell = collectionView.cellForItem(at: indexPath) as? SignCell {
                storeFrontWebViewVC.cc_setZoomTransition(originalView: imageCell.image_BG)
            }
        } else {
            if let imageCell = collectionView.cellForItem(at: indexPath) as? FolderCell {
                storeFrontWebViewVC.cc_setZoomTransition(originalView: imageCell.image_BG)
            }
        }
        
        self.present(storeFrontWebViewVC, animated: true, completion: nil)
    }
}

extension HomeVC : RecentSearchViewDelegate {
    
    func showecentSearchView() {
        if recentSearchView == nil {
            recentSearchView = RecentSearchView().loadNib() as? RecentSearchView
            recentSearchView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }
        recentSearchView?.initialSetup()
        recentSearchView?.delegate = self
        recentSearchView?.viewController = self
        self.view.addSubview(recentSearchView!)
        recentSearchView?.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.recentSearchView?.alpha = 1
        }
    }
    
    func removeRecentSearchView() {
        
        self.recentSearchView?.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.recentSearchView?.alpha = 0
            self.recentSearchView = nil
        }
        
    }
    
    func getAddressData(addressDic: NSDictionary) {
        print("addressDic : \(addressDic)")
        
        let location = addressDic.object(forKey: "location") as! CLLocation
        
        USER_LOCATION.LATITUDE = location.coordinate.latitude
        USER_LOCATION.LONGITUDE = location.coordinate.longitude
        
        self.getBusiness()
        
    }
    
}
