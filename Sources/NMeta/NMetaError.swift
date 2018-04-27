import Vapor

enum NMetaError: String, Error {
    case platformMissing
    case environmentMissing
    case versionMissing
    case versionNumberMissing
    case deviceOSMissing
    case deviceMissing
    case headerMissing
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
