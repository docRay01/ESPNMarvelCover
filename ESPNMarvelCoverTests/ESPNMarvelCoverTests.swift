//
//  ESPNMarvelCoverTests.swift
//  ESPNMarvelCoverTests
//
//  Created by Davis, R. Steven on 4/28/22.
//

import XCTest
import CryptoKit
@testable import ESPNMarvelCover

class ESPNMarvelCoverTests: XCTestCase {
    
    func testIssueParsingNormal() {
        guard let data = getDataFromJsonFile(name: "XmenAlphaIssue1") else {
            XCTFail("Couldn't read standard issue data")
            return
        }
        let id = "Xmen1"
        guard let issueModel = MarvelNetworkService().parseIssue(comicId: id, data: data) else {
            XCTFail("Standard issue did not parse")
            return
        }
        
        XCTAssertEqual(issueModel.id, id)
        XCTAssertEqual(issueModel.name, "X-Men: Alpha (1995) #1")
        XCTAssertEqual(issueModel.imageURLString, "http://i.annihil.us/u/prod/marvel/i/mg/7/00/599b1cf83439a/portrait_uncanny.jpg")
        XCTAssertEqual(issueModel.description, "Standard description")
    }
    
    func testIssueParsingWithPullDescription() {
        guard let data = getDataFromJsonFile(name: "4Issue1") else {
            XCTFail("Couldn't read non-standard issue data")
            return
        }
        let id = "4_1"
        guard let issueModel = MarvelNetworkService().parseIssue(comicId: id, data: data) else {
            XCTFail("Non-standard issue did not parse")
            return
        }
        
        XCTAssertEqual(issueModel.id, id)
        XCTAssertEqual(issueModel.name, "4 (2004) #1")
        XCTAssertEqual(issueModel.imageURLString, "http://i.annihil.us/u/prod/marvel/i/mg/5/e0/5841c1f921b0c/portrait_uncanny.jpg")
        XCTAssertEqual(issueModel.description, "Pull description")
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func getDataFromJsonFile(name: String) -> Data? {
        do {
            let bundle = Bundle(for: type(of: self))
            if let path = bundle.path(forResource: name, ofType: "json") {
                let parsedData = try String(contentsOfFile: path).data(using: .utf8)
                return parsedData
                
            }
        } catch {
            print(error)
        }
            
        return nil
    }

    func testMD5Hash() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let inputString = "Hello World"
        // Taken as the result from https://www.md5hashgenerator.com/
        let expectedResult = "b10a8db164e0754105b7a99be72e3fe5"
        
        let actualResult = Insecure.MD5.stringHash(string: inputString)
        XCTAssertEqual(expectedResult, actualResult)
    }

}
