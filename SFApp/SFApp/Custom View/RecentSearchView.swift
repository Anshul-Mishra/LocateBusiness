//
//  RecentSearchView.swift
//  SFApp
//
//  Created by Anshul Mishra on 27/05/18.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit
import GooglePlaces

protocol RecentSearchViewDelegate {
    func removeRecentSearchView()
    func getAddressData(addressDic:NSDictionary)
}

class RecentSearchView: UIView {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var txtAddress:UITextField!
    
    var addressArr:NSArray?
    
    var delegate : RecentSearchViewDelegate?
    
    var viewController:UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {
        tableView.register(UINib(nibName: "RecentSearchCell", bundle: nil), forCellReuseIdentifier: "RecentSearchCell")
        
        if let arrAddress = UserModel.getRecentSearchData() {
            if arrAddress.count > 0 {
                addressArr = arrAddress
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func btnDismissPopup(sender:UIButton) {
        if delegate != nil {
            delegate?.removeRecentSearchView()
        }
    }
    
    @IBAction func btnGetCurrentLocation(sender:UIButton) {
        LocationManager.sharedInstance.getUserLocation(viewController: viewController!)
    }
    
}

extension RecentSearchView : UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let arrTemp = addressArr {
            return arrTemp.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as! RecentSearchCell
        cell.selectionStyle = .none
        
        cell.lblAddress.text = (addressArr?.object(at: indexPath.row) as! NSDictionary).object(forKey: "address") as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserModel.setRecentSearchData(searchData: addressArr?.object(at: indexPath.row) as? NSDictionary)
        if delegate != nil {
            delegate?.removeRecentSearchView()
            delegate?.getAddressData(addressDic: (addressArr?.object(at: indexPath.row) as? NSDictionary)!)
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        viewController?.present(autocompleteController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


extension RecentSearchView : GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        
        let addressDic = NSMutableDictionary()
        addressDic["address"] = place.formattedAddress
        let location:CLLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        addressDic["location"] = location
        UserModel.setRecentSearchData(searchData: addressDic)
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
