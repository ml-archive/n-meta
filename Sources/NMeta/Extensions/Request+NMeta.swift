import Vapor

private struct NMetaKey: StorageKey {
    typealias Value = Request.NMeta
}

public extension Request {
    struct NMeta {

        public let platform: String
        public let environment: String
        public let version: Version
        public let deviceOS: String
        public let device: String
        
        private enum webEnvironment {
            static let platform = "web"
            static let versionString = "0.0.0"
            static let deviceOS = "N/A"
            static let device = "N/A"
        }
        
        init(request: Request) throws {
            guard let metaString = request.headers.first(name: request.application.nMeta.headerName) else {
                throw NMetaError.headerMissing
            }

            var components = metaString.components(separatedBy: ";")
            
            // As the web environment _does not_ need to have all 5 values we initially checks
            // that at least two components are present (platform and environment)
            guard components.count >= 2 else {
                throw NMetaError.invalidHeaderFormat
            }
            
            self.platform = components.removeFirst()
            self.environment = components.removeFirst()
            
            if self.platform.lowercased() == webEnvironment.platform {
                // We're in webland, so we set version, deviceOS and device to default values. If
                // we need the real values we can get them from the user-agent
                self.version = try Version(string: webEnvironment.versionString)
                self.deviceOS = webEnvironment.deviceOS
                self.device = webEnvironment.device
            } else {
                // We're going mobile. Therefore there _must_ be three values for us to use. If there is
                // not, we give up
                guard components.count == 3 else {
                    throw NMetaError.invalidHeaderFormat
                }
                
                self.version = try Version(string: components.removeFirst())
                self.deviceOS = components.removeFirst()
                self.device = components.removeFirst()
            }
        }
    }

    var nMeta: NMeta? {
        get { storage[NMetaKey.self] }
        set { storage[NMetaKey.self] = newValue }
    }
}
