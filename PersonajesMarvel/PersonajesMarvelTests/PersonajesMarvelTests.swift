//
//  PersonajesMarvelTests.swift
//  PersonajesMarvelTests
//
//  Created by F on 17/04/2020.
//  Copyright © 2020 K. All rights reserved.
//

import XCTest
@testable import PersonajesMarvel

class PersonajesMarvelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDescargarImagen() {
        
        class ManagerRedDemo: ManagerRed {
            typealias Handler = ManagerRed.callBack
            var requestedURL: URL?
            func doRequest(for url: URLRequest, completionHandler: @escaping Handler) {
                requestedURL = url.url!
                let data = "ApiMarvel".data(using: .utf8)
                completionHandler(data, nil, nil)
            }
        }

        let red = ManagerRedDemo()
        let descargar = DescargarImagen(managerRed: red)

        var res: DescargarImagen.Result?
        let url = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/4/30/5269579e423ed.jpg")!
        descargar.de(url: URLRequest(url: url)) { res = $0 }
        
        print("*** \(res?.respuesta() ?? (0,"", "".data(using: .utf8)))")
        XCTAssertEqual(red.requestedURL, url)
    }

}
