import XCTVapor
import NMeta

class NMetaTests: XCTestCase {
    var app: Application!
    var nMeta: Request.NMeta?

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
        nMeta = nil
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
        try app.test(
            .GET,
            "",
            headers: [headerName: "android;testing;1.2.3;4.4;Samsung S7"]
        ) { res in
            XCTAssertEqual(res.status, .ok)
        }

        let nMeta = try XCTUnwrap(self.nMeta)

        XCTAssertEqual(nMeta.platform, "android")
        XCTAssertEqual(nMeta.environment, "testing")
        XCTAssertEqual(nMeta.version.string, "1.2.3")
        XCTAssertEqual(nMeta.deviceOS, "4.4")
        XCTAssertEqual(nMeta.device, "Samsung S7")
    }

    func testNMetaEmpty() throws {
        try app.test(.GET, "", headers: [headerName: ""]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaMissingEnv() throws {
        try app.test(.GET, "", headers: [headerName: "a"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
            )
        }
        XCTAssertNil(nMeta)
    }
    
    func testNMetaMissingVersion() throws {
        try app.test(.GET, "", headers: [headerName: "a;b"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaMissingDeviceOs() throws {
        try app.test(.GET, "", headers: [headerName: "a;b;c"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaMissingDevice() throws {
        try app.test(.GET, "", headers: [headerName: "a;b;c;d"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaIncorrectVersion() throws {
        try app.test(.GET, "", headers: [headerName: "a;b;c;d;e"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Invalid version format. Format is 1.2.3 (major.minor.patch)."
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaUnsupportedPlatform() throws {
        try app.test(.GET, "", headers: [headerName: "a;b;1;d;e"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Platform unsupported"
            )
        }
        XCTAssertNil(nMeta)
    }

    func testNMetaUnsupportedEnvironment() throws {
        try app.test(.GET, "", headers: [headerName: "web;b;1;d;e"]) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertEqual(
                try res.content.decode(ErrorReponse.self).reason,
                "NMeta: Environment unsupported"
            )
        }
        XCTAssertNil(nMeta)
    }

    func configure(_ app: Application) {
        app.nMeta.headerName = headerName
        app.nMeta.platforms = platforms
        app.nMeta.environments = environments
        app.nMeta.exceptPaths = exceptPaths
        app.nMeta.requiredEnvironments = requiredEnvironments
        
        app.grouped(NMetaMiddleware()).get("") { req -> String in
            self.nMeta = req.nMeta
            return ""
        }
    }
}

private struct ErrorReponse: Decodable {
    let reason: String
}
