import XCTest
@testable import NMeta

class NMetaTests: XCTestCase {
    func testVersionFull() throws {
        
        let version = try Version(string: "1.2.3")
        
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 3)
    }
    
    func testVersionMinor() throws {
        
        let version = try Version(string: "1")
        
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
    }

    func testVersionPatch() throws {
        
        let version = try Version(string: "1.2")
        
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
    }

    static var allTests = [
        ("testVersionFull", testVersionFull),
        ("testVersionMinor", testVersionMinor),
        ("testVersionPatch", testVersionPatch),
    ]
}
