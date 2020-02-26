//
//  Constants.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct Constants {
    
    //--------------- Server Request URL's ---------------

    static let getEmployeeDataAPI: String = "http://dummy.restapiexample.com/api/v1/employees"
    
    static let employeePlaceHolder: String = "CSMaleOffline"
    
    //MARK:- isConnectedToInternet Functions

    static func isConnectedToInternet() -> Bool {
        
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

