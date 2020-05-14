import XCTVapor
@testable import NMeta

class NMetaTests: XCTestCase {
    var app: Application!

    let headerName = "N-Meta"
    let platforms = ["web", "android", "ios"]
    let environments = ["testing"]
    let exceptPaths = ["/js/*", "/css/*", "/images/*", "/favicons/*", "/admin/*"]
    let requiredEnvironments = ["testing"]

    override func setUp() {
        app = Application(.testing)
        configure(app)
    }

    override func tearDown() {
        app.shutdown()
    }

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
        app.grouped(NMetaMiddleware()).get("test-success") { req -> String in
            XCTAssertEqual(req.nMeta?.platform, "android")
            XCTAssertEqual(req.nMeta?.environment, "testing")
            XCTAssertEqual(req.nMeta?.version.string, "1.2.3")
            XCTAssertEqual(req.nMeta?.deviceOS, "4.4")
            XCTAssertEqual(req.nMeta?.device, "Samsung S7")
            return ""
        }

        try app.test(
            .GET,
            "test-success",
            headers: [headerName: "android;testing;1.2.3;4.4;Samsung S7"]
        ) { res in
            XCTAssertEqual(res.status, .ok)
        }

    }

    func testNMetaEmpty() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: ""]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }
    
    func testNMetaMissingEnv() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: "a"]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }
    
    func testNMetaMissingVersion() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: "a;b"]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }
    func testNMetaMissingDeviceOs() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: "a;b;c"]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func testNMetaMissingDevice() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: "a;b;c;d"]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func testNMetaIncorrectVersion() throws {
        try app.test(.GET, "test-bad-request", headers: [headerName: "a;b;c;d;e"]) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func configure(_ app: Application) {
        app.nMeta.headerName = headerName
        app.nMeta.platforms = platforms
        app.nMeta.environments = environments
        app.nMeta.exceptPaths = exceptPaths
        app.nMeta.requiredEnvironments = requiredEnvironments
        
        app.grouped(NMetaMiddleware()).get("test-bad-request") { req -> String in
             return ""
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
