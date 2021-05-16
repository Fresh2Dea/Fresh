//
//  RegisterTest.swift
//  FreshTests
//
//  Created by deion bacchus on 5/15/21.
//

import XCTest
@testable import Fresh
class RegisterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateValidation() throws {
        let registerModule=Register(email:"db101097@",username:"db101097",password:"goodpass12?",confirmPassword:"goodpass12?")
        XCTAssertThrowsError(try registerModule.create())
        
    }

}
