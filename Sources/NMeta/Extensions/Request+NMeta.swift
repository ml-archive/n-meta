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

            let components = metaString.components(separatedBy: ";")
            let componentsCount = components.count

            guard
                (components.first == "web" && componentsCount >= 2) ||
                componentsCount == 5
            else {
                throw NMetaError.invalidHeaderFormat
            }

            self.platform = components[0]
            self.environment = components[1]
            self.version = try Version(string: componentsCount > 2 ? components[2] : "0.0.0")
            self.deviceOS = componentsCount > 3 ? components[3] : "N/A"
            self.device = componentsCount > 4 ? components[4] : "N/A"
        }
    }

    var nMeta: NMeta? {
        get { storage[NMetaKey.self] }
        set { storage[NMetaKey.self] = newValue }
    }
}
