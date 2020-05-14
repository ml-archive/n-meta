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
        
        init(request: Request) throws {
            guard let metaString = request.headers.first(name: request.application.nMeta.headerName) else {
                throw NMetaError.headerMissing
            }

            var components = metaString.components(separatedBy: ";")

            guard components.count == 5 else {
                throw NMetaError.ivalidHeaderFormat
            }

            self.platform = components.removeFirst()
            self.environment = components.removeFirst()
            self.version = try Version(string: components.removeFirst())
            self.deviceOS = components.removeFirst()
            self.device = components.removeFirst()
        }
    }

    var nMeta: NMeta? {
        get { storage[NMetaKey.self] }
        set { storage[NMetaKey.self] = newValue }
    }
}

