//
//  KandinskyAPIServiceTests.swift
//  KaleidoscopeTests
//
//  Created by Erast (MatoiDev) on 08.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import XCTest


@testable import Kaleidoscope

class KandinskyAPIServiceTests: XCTestCase {
    
    var service: KandinskyAPIService!

    override func setUp() {
        service = KandinskyAPIService()
    }

    override func tearDown() {
        service = nil
    }

    func test_service_fetch_styles() -> Void {
        let expectation = XCTestExpectation(description: "Fetch styles")
        
        service.fetchStyles { result in
            switch result {
            case .success(let styles):
                dump(styles)
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
