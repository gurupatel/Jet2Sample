//
//  WebServices.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

@objc protocol EmployeeDataModelClassDelegate {
    
    func didGetEmployeeDataSuccessfully(_ responseDict: NSDictionary?)
    func didGetEmployeeDataFailed(_ error: Error?)
}

class WebServices : NSObject {

    @IBOutlet var delegate : EmployeeDataModelClassDelegate?

    public override init(){}

    // MARK: - getEmployeeData Method

    func getEmployeeData() {
        
        let URL: String = Constants.getEmployeeDataAPI
                
        Network.sharedInstance.request(URL, method: "GET", params: nil, delegate: self.delegate, success: { (json) in
            
            let jsonObject = try? (JSONSerialization.jsonObject(with: json.rawData(), options: []) as! NSDictionary)

            let serverResponseDict = jsonObject as NSDictionary?

            //print("getEmployeeData : ", serverResponseDict!)

            if (serverResponseDict != nil) {
                
                self.delegate!.didGetEmployeeDataSuccessfully(serverResponseDict)
            }

        }, failure: { (error) in
                print(error)

            self.delegate!.didGetEmployeeDataFailed(error)
        
        })
    }

}
