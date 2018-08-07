//
//  UserModel.swift
//  SFApp
//
//  Created by Anshul Mishra on 27/05/18.
//  Copyright © 2018 Frank. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    class func setRecentSearchData(searchData:NSDictionary?) {
        if let dataDic = searchData {
            let arrAddress = NSMutableArray()
            if let arrTemp = getRecentSearchData() {
                if arrTemp.count > 0 {
                    arrAddress.addObjects(from: (arrTemp.mutableCopy() as! NSMutableArray) as! [Any])
                    if arrAddress.contains(dataDic) {
                        arrAddress.remove(dataDic)
                    } else {
                        arrAddress.add(dataDic)
                        if arrAddress.count > 20 {
                            arrAddress.removeLastObject()
                        }
                    }
                } else {
                    arrAddress.add(dataDic)
                }
            } else {
                arrAddress.add(dataDic)
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject: arrAddress)
            UserDefaults.standard.set(data, forKey: "RecentSearch")
        }
    }
    
    class func getRecentSearchData() -> NSArray? {
        if let data = UserDefaults.standard.value(forKey: "RecentSearch") {
            let dataDic = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return dataDic as? NSArray
        } else {
            return nil
        }
    }
    
}
