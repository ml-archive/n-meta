import Vapor

private struct NMetaKey: StorageKey {
    typealias Value = Application.NMeta
}

extension Application {
    struct NMeta {
        // The request header, which is meta data will be exctracted from
        public let headerName: String = "N-Meta"

        // The supported platforms
        public let platforms: [String] = ["web", "android", "ios"]

        // The supported environments
        public let environments: [String] = ["local", "development", "staging", "production"]

        // Ignore requirement on following paths
        public let exceptPaths: [String] = ["/js/*", "/css/*", "/images/*", "/favicons/*", "/admin/*"]

        /// Only check header on following environments
        public let requiredEnvironments: [String] = ["local", "development", "staging", "production"]

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
            guard
                let metaString = request.headers.first(name: headerName)
                else {
                    throw NMetaError.headerMissing
            }

            if metaString.isEmpty {
                throw NMetaError.headerIsEmpty
            }

            // Build meta header.
            guard let meta = Request.NMeta(request: request) else {
                throw NMetaError.ivalidHeaderFormat
            }

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

    var nMeta: NMeta {
        get {
            if let existing = storage[NMetaKey.self] {
                return existing
            } else {
                let new = NMeta()
                storage[NMetaKey.self] = new
                return new
            }
        }

        set { storage[NMetaKey.self] = newValue }
    }
}
