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
            throw Abort.custom(status: .badRequest, message: "Platform is not supported.")
        }

        self.platform = components.removeFirst()

        // Set environment
        guard !components.isEmpty && configuration.environments.contains(components[0]) else {
            throw Abort.custom(status: .badRequest, message: "Environment is not supported.")
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
            throw Abort.custom(status: .badRequest, message: "Missing version.")
        }

        version = try Version(string: components.removeFirst())

        // Set device os
        guard !components.isEmpty else {
            throw Abort.custom(status: .badRequest, message: "Missing device os.")
        }

        self.deviceOs = components.removeFirst()

        // Set device
        guard !components.isEmpty else {
            throw Abort.custom(status: .badRequest, message: "Missing device.")
        }

        self.device = components.removeFirst()
    }
}

// MARK: - NodeConvertible -

extension Meta: NodeConvertible {

    public init(node: Node, in context: Context) throws {
        platform    = try node.extract("platform")
        environment = try node.extract("environment")
        version     = try node.extract("version")
        deviceOs    = try node.extract("deviceOs")
        device      = try node.extract("device")
    }

    public func makeNode(context: Context) throws -> Node {
        return Node([
            "platform": platform.makeNode(),
            "environment": environment.makeNode(),
            "version": try version.makeNode(),
            "deviceOs": deviceOs.makeNode(),
            "device": device.makeNode()
            ])
    }
}
