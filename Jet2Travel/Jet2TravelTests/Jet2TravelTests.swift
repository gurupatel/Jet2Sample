//
//  Jet2TravelTests.swift
//  Jet2TravelTests
//
//  Created by Gaurang Patel on 25/02/20.
//  Copyright © 2020 Jet2Travel. All rights reserved.
//

import XCTest
@testable import Jet2Travel

class Jet2TravelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_API_IsCorrect() {

        let URL: String = Constants.getEmployeeDataAPI

        let expectedBaseURLString = URL
                       
        Network.sharedInstance.request(URL, method: Constants.getMethode, params: nil, onCompletion: { (reponse) in
        
            XCTAssertEqual(try! String(contentsOf: reponse.url!), expectedBaseURLString, "Base URL does not match expected base URL. Expected base URLs to match.")
        })
    }

    func testGetEmployeesDetailsSuccess() {
        let webServices = WebServices()

        let empExpectation = expectation(description: "employees")
        var empResponse: NSDictionary?

        webServices.getEmployeeData { (reponse, error) in

            empResponse = reponse
            empExpectation.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            
            XCTAssertNil(error, "\(String(describing: empResponse))")
        }
    }
}
