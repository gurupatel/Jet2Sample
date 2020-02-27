//
//  MockURLSession.swift
//  Jet2Travel
//
//  Created by Gaurang Patel on 27/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
  var cachedUrl: URL?
  
    override func dataTask(with url: URL, completionHandler:      @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    self.cachedUrl = url
    return URLSessionDataTask()
  }
}
