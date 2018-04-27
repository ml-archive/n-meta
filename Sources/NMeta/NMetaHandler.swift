import Vapor
import HTTP

internal struct NMetaHandler {
    private let environment: Environment
    private let headerKey: String
    private let platforms: [String]
    private let environments: [String]
    private let exceptPaths: [String]
    private let requiredEnvironments: [String]
    
    internal init(_ config: NMetaConfig) throws {
        self.environment = try Environment.detect()
        self.headerKey = config.headerKey
        self.platforms = config.platforms
        self.environments = config.environments
        self.exceptPaths = config.exceptPaths
        self.requiredEnvironments = config.requiredEnvironments
    }
    
    internal func isMetaRequired(request: Request) throws -> Bool {
         // TODO, look into this, should not be here?
        // Only APIs
        /*
        if request.http.accept.pr {
            return false
        }
        */
        
        // Check required environments
        if !requiredEnvironments.contains(environment.name) {
            return false
        }
        
        // Bypass CORS requests // TODO, look into making this configurable
        if request.http.method == HTTPMethod.OPTIONS {
            return false
        }
        
        // Except paths
        for check: String in exceptPaths {
            // Check complete except paths
            if check == request.http.urlString {
                return false
            }
            
            // Check except paths and subfolders
            if check.stringValue.last == "*" {
                if request.http.urlString.hasPrefix(
                    //check[check.index..<check.endIndex]
                    
                    check.substring(
                        to: check.index(
                            check.endIndex,
                            offsetBy: -1
                        )
                    )
                    
                    ) {
                    return false
                }
            }
        }
        
        return true
    }
    
    internal func metaOrFail(request: Request) throws -> NMeta {
        guard let metaString = request.http.headers.firstValue(name: HTTPHeaderName(headerKey)) else {
            throw NMetaError.headerMissing // Missing header
        }
        
        // Build meta header.
        let meta = try NMeta(raw: metaString)
        
        // Validate meta header.
        // Validate platform.
        guard platforms.contains(meta.platform) else {
            throw NMetaError.platformMissing // Missing platform
        }
        
        // Validate environment.
        guard environments.contains(meta.environment) else {
            throw NMetaError.environmentMissing // Missing env
        }
        
        return meta
    }
}
