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
    
    func testNMetaSuccess() throws {
        
        let nMeta = try NMeta(raw: "android;production;1.2.3;4.4;Samsung S7")
        
        XCTAssertEqual(nMeta.platform, "android")
        XCTAssertEqual(nMeta.environment, "production")
        XCTAssertEqual(nMeta.version.string, "1.2.3")
        XCTAssertEqual(nMeta.deviceOs, "4.4")
        XCTAssertEqual(nMeta.device, "Samsung S7")
    }

    func testNMetaEmpty() throws {
        XCTAssertThrowsError(try NMeta(raw: "")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.headerIsEmpty)
        }
    }
    
    func testNMetaMissingEnv() throws {
        XCTAssertThrowsError(try NMeta(raw: "a")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.environmentMissing)
        }
    }
    
    func testNMetaMissingVersion() throws {
        XCTAssertThrowsError(try NMeta(raw: "a;b")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.versionMissing)
        }
    }
    
    func testNMetaMissingDeviceOs() throws {
        XCTAssertThrowsError(try NMeta(raw: "a;b;c")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.deviceOsMissing)
        }
    }
    
    func testNMetaMissingDevice() throws {
        XCTAssertThrowsError(try NMeta(raw: "a;b;c;d")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.deviceMissing)
        }
    }
    
    func testNMetaIncorrectVersion() throws {
        XCTAssertThrowsError(try NMeta(raw: "a;b;c;d;e")) { error in
            XCTAssertEqual(error as? NMetaError, NMetaError.versionIsIncorrectFormat)
        }
    }
    
    static var allTests = [
        ("testVersionFull", testVersionFull),
        ("testVersionMinor", testVersionMinor),
        ("testVersionPatch", testVersionPatch),
        ("testNMetaSuccess", testNMetaSuccess),
        ("testNMetaEmpty", testNMetaEmpty),
        ("testNMetaMissingEnv", testNMetaMissingEnv),
        ("testNMetaMissingVersion", testNMetaMissingVersion),
        ("testNMetaMissingDeviceOs", testNMetaMissingDeviceOs),
        ("testNMetaMissingDevice", testNMetaMissingDevice),
        ("testNMetaIncorrectVersion", testNMetaIncorrectVersion),
        
    ]
}
