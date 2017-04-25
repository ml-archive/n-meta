import Vapor
import Foundation

public struct Meta {

    public let platform: String
    public let environment: String
    public let version: Version
    public let deviceOs: String
    public let device: String

    public init(configuration: Configuration, meta: String) throws {
        var components = meta.components(separatedBy: ";")

        // Set platform
        guard !components.isEmpty && configuration.platforms.contains(components[0]) else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Platform is not supported."
            )
        }

        self.platform = components.removeFirst()

        // Set environment
        guard !components.isEmpty && configuration.environments.contains(components[0]) else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Environment is not supported."
            )
        }

        self.environment = components.removeFirst()

        // Since web is normally using a valid User-Agent there is no reason for asking for more
        if platform == "web" {
            self.version  = try Version(string: "0.0.0")
            self.deviceOs = "N/A"
            self.device   = "N/A"
            return
        }

        // Set version
        guard !components.isEmpty else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Missing version."
            )
        }

        version = try Version(string: components.removeFirst())

        // Set device os
        guard !components.isEmpty else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Missing device os."
            )
        }

        self.deviceOs = components.removeFirst()

        // Set device
        guard !components.isEmpty else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Missing device."
            )
        }

        self.device = components.removeFirst()
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
