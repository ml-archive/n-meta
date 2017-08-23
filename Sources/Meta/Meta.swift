import Vapor
import Foundation

public struct Meta {
    private enum RawMetaConfig {
        static let delimiter = ";"
        static let webPlatform = "web"
        static let webVersion = "0.0.0"
        static let webDeviceOs = "N/A"
        static let webDevice = "N/A"
    }

    public let platform: String
    public let environment: String
    public let version: Version
    public let deviceOs: String
    public let device: String

    public init(raw: String) throws {
        var components = raw.components(separatedBy: RawMetaConfig.delimiter)

        // Platform.
        try Meta.assertItemsLeft(components, errorMessage: "Platform missing.")
        let platform = components.removeFirst()

        // Environment.
        try Meta.assertItemsLeft(components, errorMessage: "Environment missing.")
        let environment = components.removeFirst()

        // Since web is normally using a valid User-Agent there is no reason
        // to ask for more.
        guard platform != RawMetaConfig.webPlatform else {
            try self.init(
                platform: platform,
                environment: environment,
                version: RawMetaConfig.webVersion,
                deviceOs: RawMetaConfig.webDeviceOs,
                device: RawMetaConfig.webDevice
            )
            return
        }

        // Version.
        try Meta.assertItemsLeft(components, errorMessage: "Version missing.")
        let version = components.removeFirst()

        // Device OS.
        try Meta.assertItemsLeft(components, errorMessage: "Device OS missing.")
        let deviceOs = components.removeFirst()

        // Device.
        try Meta.assertItemsLeft(components, errorMessage: "Device missing.")
        let device = components.removeFirst()

        try self.init(
            platform: platform,
            environment: environment,
            version: version,
            deviceOs: deviceOs,
            device: device
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

        // Set version
        self.version = try Version(string: version)

        // Set device os
        self.deviceOs = deviceOs

        // Set device
        self.device = device
    }


    // MARK: Helper functions.

    private static func assertItemsLeft(_ : [String], errorMessage: String) throws {
        throw Abort(
            .badRequest,
            reason: errorMessage
        )
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
