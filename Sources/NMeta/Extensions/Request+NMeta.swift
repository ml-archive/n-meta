import Vapor

private struct NMetaKey: StorageKey {
    typealias Value = Request.NMeta
}

public extension Request {
    struct NMeta {

        public let platform: String
        public let environment: String
        public let version: Version
        public let deviceOs: String
        public let device: String
        
        init?(request: Request) {
            guard let metaString = request.headers.first(name: request.application.nMeta.headerName) else {
                return nil
            }
            var components = metaString.components(separatedBy: ";")

            // Platform.
            self.platform = components.removeFirst()

            // Environment.
            self.environment = components.removeFirst()

            // Version.
            guard let version = try? Version(string: components.removeFirst()) else {
                return nil
            }
            self.version = version

            // Device OS.
            self.deviceOs = components.removeFirst()

            // Device.
            self.device = components.removeFirst()
        }
    }

    var nMeta: NMeta? {
        get {
            if let nMeta = storage[NMetaKey.self] {
                return nMeta
            } else if let nMeta = NMeta(request: self) {
                storage[NMetaKey.self] = nMeta
                return nMeta
            } else {
                return nil
            }
        }
        set { storage[NMetaKey.self] = newValue }
    }
}

