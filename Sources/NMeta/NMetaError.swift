import Vapor

enum NMetaError: String, Error {
    case platformMissing
    case environmentMissing
    case versionMissing
    case versionIsIncorrectFormat
    case deviceOsMissing
    case deviceMissing
    case headerMissing
    case platformUnsupported
    case environmentUnsupported
    case headerIsEmpty
    case nMetaIsNotAttachedToRequest
}

extension NMetaError: AbortError {
    var identifier: String {
        return rawValue
    }
    
    var reason: String {
        switch self {
            case .platformMissing: return "Platform missing"
            case .environmentMissing: return "Environment missing"
            case .versionMissing: return "Version missing"
            case .versionIsIncorrectFormat: return "Version format incorrect. Format is 1.2.3 (major.minor.patch)"
            case .deviceOsMissing: return "DeviceOs missing"
            case .deviceMissing: return "Device missing"
            case .headerMissing: return "Header missing"
            case .platformUnsupported: return "Platform unsupported"
            case .environmentUnsupported: return "Environment unsupported"
            case .headerIsEmpty: return "Header is empty"
            case .nMetaIsNotAttachedToRequest: return "NMeta is not attached to request. This is most likely cause the middleware is not used on the route"
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
            case .platformMissing: return .badRequest
            case .environmentMissing: return .badRequest
            case .versionMissing: return .badRequest
            case .versionIsIncorrectFormat: return .badRequest
            case .deviceOsMissing: return .badRequest
            case .deviceMissing: return .badRequest
            case .headerMissing: return .badRequest
            case .platformUnsupported: return .badRequest
            case .environmentUnsupported: return .badRequest
            case .headerIsEmpty: return .badRequest
            case .nMetaIsNotAttachedToRequest: return .internalServerError
        }
    }
}

/*
extension NMetaError: Debuggable {
    public var identifier: String {
        return rawValue
    }
}
*/
