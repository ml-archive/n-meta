import Vapor

public enum NMetaError: String, Error {
    case environmentUnsupported
    case headerMissing
    case invalidHeaderFormat
    case invalidVersionFormat
    case platformUnsupported
}

extension NMetaError: AbortError {
    public var identifier: String { rawValue }

    public var reason: String {
        switch self {
        case .environmentUnsupported: return "NMeta: Environment unsupported"
        case .headerMissing: return "NMeta: Header missing"
        case .invalidHeaderFormat: return """
            NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device.
            """
        case .invalidVersionFormat: return """
            NMeta: Invalid version format. Format is 1.2.3 (major.minor.patch).
            """
        case .platformUnsupported: return "NMeta: Platform unsupported"
        }
    }

    public var status: HTTPResponseStatus {
        switch self {
        case .invalidVersionFormat,
             .headerMissing,
             .platformUnsupported,
             .environmentUnsupported,
             .invalidHeaderFormat:
            return .badRequest
        }
    }
}
