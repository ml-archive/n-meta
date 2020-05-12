import Vapor

public struct NMeta {
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
        if raw.isEmpty {
            throw NMetaError.headerIsEmpty
        }

        var components = raw.components(separatedBy: RawMetaConfig.delimiter)

        // Platform.
        try NMeta.assertItemsLeft(components, error: NMetaError.platformMissing)
        let platform = components.removeFirst()

        // Environment.
        try NMeta.assertItemsLeft(components, error: NMetaError.environmentMissing)
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
        try NMeta.assertItemsLeft(components, error: NMetaError.versionMissing)
        let version = components.removeFirst()

        // Device OS.
        try NMeta.assertItemsLeft(components, error: NMetaError.deviceOsMissing)
        let deviceOs = components.removeFirst()

        // Device.
        try NMeta.assertItemsLeft(components, error: NMetaError.deviceMissing)
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
        self.platform = platform
        self.environment = environment
        self.version = try Version(string: version)
        self.deviceOs = deviceOs
        self.device = device
    }

    // MARK: Helper functions.

    private static func assertItemsLeft(_ items: [String], error: NMetaError) throws {
        guard !items.isEmpty else {
            throw error
        }
    }
}
