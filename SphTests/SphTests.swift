//
//  SphTests.swift
//  SphTests
//
//  Created by 青天揽月1 on 2020/3/5.
//  Copyright © 2020 wenjuu. All rights reserved.
//

import XCTest
import Alamofire
import Foundation

@testable import Sph

class SphTests: XCTestCase {

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
    
    func testDB1() {
        let tem = DbManager.sharedAdapter().getLocalData()
        XCTAssertNotNil(tem, "本地数据出错")
    }
    func testBD2() {
        let dict = ["_id":121,
                    "volume_of_mobile_data":"12.798",
                    "quarter":"2022-Q1"]
            as [String : Any]
        let tem :Array = [dict]
        let res = DbManager.sharedAdapter().saveData(tem)
        XCTAssertTrue(res, "插入数据成功")
    }
    func testRequest() {
        let timeout: TimeInterval = 10
        let urlString = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        let expectation = self.expectation(description: "GET request should succeed: \(urlString)")
        var response: DataResponse<Data?, AFError>?
        AF.request(urlString)
            .response { resp in
                response = resp
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNil(response?.error)
    }
}
