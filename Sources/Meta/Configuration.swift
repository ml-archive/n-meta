import Foundation
import Vapor
import HTTP

public struct Configuration {
    private enum Keys: String {
        case meta
        case header
        case platforms
        case environments
        case exceptPaths
        case requiredEnvironments
    }

    internal let headerKey: HeaderKey
    internal let platforms: [String]
    internal let environments: [String]
    internal let exceptPaths: [String]
    internal let requiredEnvironments: [String]
    internal let environment: Environment

    internal init(_ config: Config) throws {
        guard let metaConfig: Config = config[Keys.meta.rawValue] else {
            throw Abort(
                .internalServerError,
                reason: "Meta error - meta config is missing."
            )
        }

        headerKey = try metaConfig.get(Keys.header.rawValue)
        platforms = try Configuration.extractArray(
            from: metaConfig,
            forKey: .platforms
        )
        environments = try Configuration.extractArray(
            from: metaConfig,
            forKey: .environments
        )
        exceptPaths = try Configuration.extractArray(
            from: metaConfig,
            forKey: .exceptPaths
        )
        requiredEnvironments = try Configuration.extractArray(
            from: metaConfig,
            forKey: .requiredEnvironments
        )
        environment = metaConfig.environment
    }

    private static func extractArray(
        from config: Config,
        forKey key: Keys
    ) throws -> [String] {
        guard let array = config[key.rawValue]?.array else {
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "Meta error - \(key.rawValue) key is missing."
            )
        }

        return try array.map({
            guard let string = $0.string else {
                throw Abort(
                    .internalServerError,
                    reason: "Invalid value for key: \(key.rawValue)"
                )
            }

            return string
        })
    }
}
