import Vapor
import HTTP

internal struct MetaHandler {
    private let environment: Environment
    private let headerKey: HeaderKey
    private let platforms: [String]
    private let environments: [String]
    private let exceptPaths: [String]
    private let requiredEnvironments: [String]

    internal init(_ config: Configuration) {
        self.environment = config.environment
        self.headerKey = config.headerKey
        self.platforms = config.platforms
        self.environments = config.environments
        self.exceptPaths = config.exceptPaths
        self.requiredEnvironments = config.requiredEnvironments
    }

    internal func isMetaRequired(request: Request) throws -> Bool {
        // Only APIs
        if request.accept.prefers("html") {
            return false
        }
        // Check required environments
        if !requiredEnvironments.contains(environment.description) {
            return false
        }


        // Bypass CORS requests
        if request.method == .options {
            return false
        }

        // Except paths
        for check: String in exceptPaths {
             // Check complete except paths
            if check == request.uri.path {
                return false
            }

            // Check except paths and subfolders
            if check.characters.last == "*" {
                if request.uri.path.hasPrefix(
                    check.substring(
                        to: check.index(
                            check.endIndex,
                            offsetBy: -1
                        )
                    )
                ) {
                    return false
                }
            }
        }

        return true
    }

    internal func metaOrFail(request: Request) throws -> Meta {
        guard let metaString = request.headers[headerKey]?.string else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Missing \(headerKey.key) header."
            )
        }

        // Build meta header.
        let meta = try Meta(raw: metaString)

        // Validate meta header.
        // Validate platform.
        guard platforms.contains(meta.platform) else {
            throw Abort(
                .badRequest,
                reason: "Platform is not supported."
            )
        }

        // Validate environment.
        guard environments.contains(meta.environment) else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Environment is not supported."
            )
        }

        return meta
    }
}
