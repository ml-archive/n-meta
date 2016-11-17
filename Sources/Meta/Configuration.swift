import Foundation
import Vapor
import HTTP

public struct Configuration {

    public enum Field: String {
        case header                 = "meta.header"
        case platforms              = "meta.platforms"
        case environments           = "meta.environments"
        case requiredEnvironments   = "meta.requiredEnvironments"
        case exceptPaths            = "meta.exceptPaths"

        var path: [String] {
            return rawValue.components(separatedBy: ".")
        }

        var error: Abort {
            return .custom(status: .internalServerError,
                           message: "Meta error - \(rawValue) config is missing.")
        }
    }

    public let headerKey: HeaderKey
    public let platforms: [String]
    public let environments: [String]
    public let requiredEnvironments: [String]
    public let exceptPaths: [String]

    public init(drop: Droplet) throws {
        self.platforms            = try Configuration.extract(field: .platforms, drop: drop)
        self.environments         = try Configuration.extract(field: .environments, drop: drop)
        self.requiredEnvironments = try Configuration.extract(field: .requiredEnvironments, drop: drop)
        self.exceptPaths          = try Configuration.extract(field: .exceptPaths, drop: drop)

        let headerString: String = try Configuration.extract(field: .header, drop: drop)
        self.headerKey = HeaderKey(headerString)
    }

    private static func extract(field: Field , drop: Droplet) throws -> [String] {
        // Get array
        guard let platforms = drop.config[field.path]?.array else {
            throw field.error
        }

        // Get from config and make sure all values are strings
        return try platforms.map({
            guard let string = $0.string else {
                throw field.error
            }

            return string
        })
    }

    private static func extract(field: Field , drop: Droplet) throws -> String {
        guard let string = drop.config[field.path]?.string else {
            throw field.error
        }

        return string
    }
}

// MARK: - Extract -

extension Configuration {
    public func extractHeaderString(withRequest request: Request) throws -> String {
        guard let metaString = request.headers[headerKey]?.string else {
            throw Abort.custom(status: .badRequest, message: "Missing \(headerKey.key) header.")
        }
        return metaString
    }
}
