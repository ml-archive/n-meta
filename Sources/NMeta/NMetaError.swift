import Vapor

public enum NMetaError: String, Error {
    case platformMissing
    case environmentMissing
    case versionMissing
    case versionIsIncorrectFormat
    case deviceOSMissing
    case deviceMissing
    case headerMissing
    case platformUnsupported
    case environmentUnsupported
    case nMetaIsNotAttachedToRequest
    case ivalidHeaderFormat
}

extension NMetaError: AbortError {
    public var identifier: String { rawValue }

    public var reason: String {
        switch self {
        case .platformMissing: return "NMeta: Platform missing"
        case .environmentMissing: return "NMeta: Environment missing"
        case .versionMissing: return "NMeta: Version missing"
        case .versionIsIncorrectFormat: return """
            NMeta: Version format incorrect. Format is 1.2.3 (major.minor.patch)
        """
        case .deviceOSMissing: return "NMeta: DeviceOS missing"
        case .deviceMissing: return "NMeta: Device missing"
        case .headerMissing: return "NMeta: Header missing"
        case .platformUnsupported: return "NMeta: Platform unsupported"
        case .environmentUnsupported: return "NMeta: Environment unsupported"
        case .nMetaIsNotAttachedToRequest: return """
            NMeta is not attached to request. This is most likely cause the middleware is not used
            on the route.
        """
        case .ivalidHeaderFormat: return "NMeta: Invalid header format. Format is platform;environment;version;deviceOS;device."
        }
    }

    public var status: HTTPResponseStatus {
        switch self {
        case .platformMissing: return .badRequest
        case .environmentMissing: return .badRequest
        case .versionMissing: return .badRequest
        case .versionIsIncorrectFormat: return .badRequest
        case .deviceOSMissing: return .badRequest
        case .deviceMissing: return .badRequest
        case .headerMissing: return .badRequest
        case .platformUnsupported: return .badRequest
        case .environmentUnsupported: return .badRequest
        case .nMetaIsNotAttachedToRequest: return .internalServerError
        case .ivalidHeaderFormat: return .badRequest
        }
    }
}
