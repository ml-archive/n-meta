import Vapor

public extension Application {
    struct NMeta {

        /// Request header where NMeta data will be extracted from
        public var headerName: String

        /// Supported platforms
        public var platforms: [String]

        /// Supported environments
        public var environments: [String]

        /// Ignore requirement on following paths
        public var exceptPaths: [String]

        /// Only check header on following environments
        public var requiredEnvironments: [String]

        /// Create a new `NMeta` configuration value.
        /// - Parameters:
        ///   - headerName: the request header where NMeta data will be extracted from
        ///   - platforms: supported platforms
        ///   - environments: supported environments
        ///   - exceptPaths:
        ///   paths to ignore NMeta requirement on. Must start with `/` and may end with `/*` to match all sub-paths.
        ///   - requiredEnvironments: environments to check NMeta header for
        public init(
            headerName: String = "N-Meta",
            platforms: [String] = ["web", "android", "ios"],
            environments: [String] = ["local", "development", "staging", "production"],
            exceptPaths: [String] = ["/js/*", "/css/*", "/images/*", "/favicons/*", "/admin/*"],
            requiredEnvironments: [String] = ["local", "development", "staging", "production"]
        ) {
            self.headerName = headerName
            self.platforms = platforms
            self.environments = environments
            self.exceptPaths = exceptPaths
            self.requiredEnvironments = requiredEnvironments
        }

        func assertValid(request: Request) throws {
            if try isMetaRequired(request: request) {
                // Extract and add meta to request.
                request.nMeta = try metaOrFail(request: request)
            }
        }

        private func isMetaRequired(request: Request) throws -> Bool {
            // Check required environments
            if !requiredEnvironments.contains(request.application.environment.name) {
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

        private func metaOrFail(request: Request) throws -> Request.NMeta {
            let meta = try Request.NMeta(request: request)

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

    private struct Key: StorageKey {
        typealias Value = NMeta
    }

    var nMeta: NMeta {
        get {
            if let existing = storage[Key.self] {
                return existing
            } else {
                let new = NMeta()
                storage[Key.self] = new
                return new
            }
        }

        set { storage[Key.self] = newValue }
    }
}
