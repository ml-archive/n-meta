import Vapor

enum NMetaError: String, Error {
    case platformMissing
    case environmentMissing
    case versionMissing
    case versionNumberMissing
    case deviceOSMissing
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
            case .environmentMissing: return "Platform missing"
            case .versionMissing: return "Platform missing"
            case .versionNumberMissing: return "Platform missing"
            case .deviceOSMissing: return "Platform missing"
            case .deviceMissing: return "Platform missing"
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
            case .versionNumberMissing: return .badRequest
            case .deviceOSMissing: return .badRequest
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
