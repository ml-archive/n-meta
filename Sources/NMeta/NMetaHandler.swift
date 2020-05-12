import Vapor

public struct NMetaHandler {
    private let environment: Environment
    private let headerName: String
    private let platforms: [String]
    private let environments: [String]
    private let exceptPaths: [String]
    private let requiredEnvironments: [String]

    init(config: NMetaConfig) throws {
        self.environment = try Environment.detect()
        self.headerName = config.headerName
        self.platforms = config.platforms
        self.environments = config.environments
        self.exceptPaths = config.exceptPaths
        self.requiredEnvironments = config.requiredEnvironments
    }

    func isMetaRequired(request: Request) throws -> Bool {
        // Check required environments
        if !requiredEnvironments.contains(environment.name) {
            return false
        }

        // Bypass CORS requests
        if request.method == .OPTIONS {
            return false
        }

        // Except paths
        for check: String in exceptPaths {
            // Check complete except paths
            if check == request.url.description {
                return false
            }

            // Check except paths and subfolders
            if check.last == "*" && request.url.description.hasPrefix(String(check.dropLast())) {
                return false
            }
        }

        return true
    }

    func metaOrFail(request: Request) throws -> NMeta {
        guard
            let metaString = request.headers.first(name: headerName)
        else {
            throw NMetaError.headerMissing
        }

        if metaString.isEmpty {
            throw NMetaError.headerIsEmpty
        }

        // Build meta header.
        let meta = try NMeta(raw: metaString)

        // Validate meta header.
        // Validate platform.
        guard platforms.contains(meta.platform) else {
            throw NMetaError.platformUnsupported
        }

        // Validate environment.
        guard environments.contains(meta.environment) else {
            throw NMetaError.environmentUnsupported
        }

        return meta
    }
}
