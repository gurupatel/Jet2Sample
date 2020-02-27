//
//  Network.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

//
// MARK: - Network
//

class Network {
    
    static let sharedInstance = Network()

    private var sessionManager: SessionManager?

    var strApi = ""
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    // MARK: - cancelAllRequests Method

    func initSessionManager() -> SessionManager? {

        let sessionManager = Alamofire.SessionManager.default
        
        //We can change time out interval from here
        sessionManager.session.configuration.timeoutIntervalForRequest = 300
        sessionManager.session.configuration.timeoutIntervalForResource = 300

        return sessionManager
    }
    
    // MARK: - cancelAllRequests Method

    func cancelAllRequests() {
              
        let sessionManager = self.initSessionManager()
        
        sessionManager!.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
        
    // MARK: - request Method

    func request(_ strURL : String, method : String, params : [String : AnyObject]?, onCompletion:@escaping ((_ response: JSON) -> Void)) {
                
        strApi = strURL
                
        let sessionManager = self.initSessionManager()

        sessionManager!.request(strURL, method: HTTPMethod(rawValue: method)!, parameters: params, encoding: JSONEncoding.default)
            .responseSwiftyJSON(completionHandler: { dataResponse in
                
                var contentJSON = JSON()

                    if dataResponse.result.isSuccess {
                    
                        contentJSON = JSON(dataResponse.result.value!)
                
                    } else {
                    
                        contentJSON = JSON(dataResponse.result.error!)
                    }
                
                    onCompletion(contentJSON)
            })
    }
}
