import Vapor
import Foundation

public struct Meta {
    private enum RawMetaConfig {
        static let delimiter = ";"
        static let size = 5
        static let platformIndex = 0
        static let environementIndex = 1
        static let versionIndex = 2
        static let deviceOsIndex = 3
        static let deviceIndex = 4
    }

    public let platform: String
    public let environment: String
    public let version: Version
    public let deviceOs: String
    public let device: String

    public init(raw: String) throws {
        let components = raw.components(separatedBy: RawMetaConfig.delimiter)
        guard components.count == RawMetaConfig.size else {
            throw Abort(
                .internalServerError,
                metadata: nil,
                reason: "Meta header has wrong format. Expected \(RawMetaConfig.size) compoennts, got \(components.count)."
            )
        }

        try self.init(
            platform: components[RawMetaConfig.platformIndex],
            environment: components[RawMetaConfig.environementIndex],
            version: components[RawMetaConfig.versionIndex],
            deviceOs: components[RawMetaConfig.deviceOsIndex],
            device: components[RawMetaConfig.deviceIndex]
        )
    }

    public init(
        platform: String,
        environment: String,
        version: String,
        deviceOs: String,
        device: String
    ) throws {
        // Set platform
        self.platform = platform

        // Set environment
        self.environment = environment

        // Since web is normally using a valid User-Agent there is no reason for asking for more.
        if platform == "web" {
            self.version  = try Version(string: "0.0.0")
            self.deviceOs = "N/A"
            self.device   = "N/A"
            return
        }

        // Set version
        self.version = try Version(string: version)

        // Set device os
        self.deviceOs = deviceOs

        // Set device
        self.device = device
    }
}

// MARK: - NodeConvertible -

extension Meta: NodeConvertible {
    public init(node: Node) throws {
        platform    = try node.get("platform")
        environment = try node.get("environment")
        version     = try node.get("version")
        deviceOs    = try node.get("deviceOs")
        device      = try node.get("device")
    }

    public func makeNode(in context: Context?) throws -> Node {
        return try Node(node: [
            "platform": Node(platform),
            "environment": Node(environment),
            "version": Node(node: version),
            "deviceOs": Node(deviceOs),
            "device": Node(device)
        ])
    }
}
