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

    func request(_ strURL : String, method : String, params : [String : AnyObject]?, delegate: AnyObject?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
                
        strApi = strURL
                
        let sessionManager = self.initSessionManager()

        var delegate = delegate

        if (delegate == nil) {
            
            delegate = "" as AnyObject
        }

        sessionManager!.request(strURL, method: HTTPMethod(rawValue: method)!, parameters: params, encoding: JSONEncoding.default)
            .responseSwiftyJSON(completionHandler: { dataResponse in
                
                if (dataResponse.result.value != nil) {

                    //(dataResponse.request?.url)!
                                        
                    let resJson = JSON(dataResponse.result.value!)
                    success(resJson)
                    
                    if let status = dataResponse.response?.statusCode {
                        
                        let jsonObject = try? (JSONSerialization.jsonObject(with: resJson.rawData(), options: []) as! NSDictionary)

                        let serverResponseDict = jsonObject as NSDictionary?

                        switch(status) {
                        
                        case 200...204:
                            //Success
                            
                            break
                        case 500...504:
                            //Fail

                            if dataResponse.result.isFailure {
                                
                                let error : Error = dataResponse.result.error!

                                if (error._code != NSURLErrorTimedOut && error._code != NSURLErrorNotConnectedToInternet && error._code != NSURLErrorNetworkConnectionLost && error._code != -999) {
                                    
                                    failure(error)
                                }
                                else {
                                    
                                    self.checkErrorStateAndPerformAction(error: error)
                                }
                            }
                            
                        default:
                            
                            print("error with response status: \(status)")
                        }
                    }
                    
                    if dataResponse.result.isFailure {
                        
                        let error : Error = dataResponse.result.error!

                        if (error._code != NSURLErrorTimedOut && error._code != NSURLErrorNotConnectedToInternet && error._code != NSURLErrorNetworkConnectionLost && error._code != -999) {
                            
                            failure(error)
                        }
                        else {
                            
                            self.checkErrorStateAndPerformAction(error: error)
                        }
                    }
                }
                else {
                    
                    let error : Error = dataResponse.result.error!

                    if (error._code != NSURLErrorTimedOut && error._code != NSURLErrorNotConnectedToInternet && error._code != NSURLErrorNetworkConnectionLost && error._code != -999) {
                        
                        failure(error)
                    }
                    else {
                        
                        self.checkErrorStateAndPerformAction(error: error)
                    }

                    print("**** NO RESPONSE FROM SERVER ****")
                }
            })
    }
    
    // MARK: - checkErrorStateAndPerformAction Method

    func checkErrorStateAndPerformAction(error: Error)
    {
        if (error._code == NSURLErrorTimedOut) {
            print("Request timeout!")
            
        }
        else if (error._code == NSURLErrorNotConnectedToInternet || error._code == -1009 || error.localizedDescription == "The Internet connection appears to be offline.") {

            print("NO Internet Connection!")
            
        }
        else if (error._code == NSURLErrorBadServerResponse || error._code == 500) {

            print("Server Error!")
            
        }
        else if error._code == NSURLErrorNetworkConnectionLost {

            print("The network connection was lost.")
        }
    }
    
    // MARK: - startNetworkReachabilityObserver Method

    @objc func startNetworkReachabilityObserver() {

        reachabilityManager?.listener = { status in
            switch status {

                case .notReachable:
                    print("The network is not reachable")

                case .unknown :
                    print("It is unknown whether the network is reachable")

                case .reachable(.ethernetOrWiFi):
                    print("The network is reachable over the WiFi connection")

                case .reachable(.wwan):
                    print("The network is reachable over the WWAN connection")

                }
            }

            // start listening
            reachabilityManager?.startListening()
       }
}
