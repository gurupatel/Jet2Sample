//
//  WebServices.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class WebServices : NSObject {

    var session: URLSession!

    public override init(){}

    // MARK: - getEmployeeData Method

    func getEmployeeData(completion: @escaping (_ response: NSDictionary?, _ error: Error?) -> Void) {
        
        let URL: String = Constants.getEmployeeDataAPI
                
        Network.sharedInstance.request(URL, method: Constants.getMethode, params: nil, onCompletion: { (reponse) in
        
                let jsonObject = try? (JSONSerialization.jsonObject(with: reponse.rawData(), options: []) as! NSDictionary)

                let serverResponseDict = jsonObject as NSDictionary?

                //print("getEmployeeData : ", serverResponseDict!)

                completion(serverResponseDict, reponse.error)
        })
    }
}
