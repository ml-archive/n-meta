import XCTest
@testable import Meta

class MetaTests: XCTestCase {
    func test() {
        XCTAssertTrue(true)
    }


    static var allTests : [(String, (MetaTests) -> () throws -> Void)] {
        return [
            ("test", test),
        ]
    }
}
