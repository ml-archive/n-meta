import HTTP
import Vapor
import Foundation

extension Request {

    public var meta: Meta? {
        get { return storage["meta"] as? Meta }
        set { storage["meta"] = newValue }
    }

    public func isMetaRequired(configuration: Configuration, drop: Droplet) throws -> Bool {
        // Only APIs
        if accept.prefers("html") {
            return false
        }
        // Check required environments
        if !configuration.requiredEnvironments.contains(drop.config.environment.description) {
            return false
        }


        // Bypass CORS requests
        if method == .options {
            return false
        }

        // Except paths
        for check: String in configuration.exceptPaths {
             // Check complete except paths
            if check == uri.path {
                return false
            }
            
            // Check except paths and subfolders
            if check.characters.last == "*" {
                if uri.path.hasPrefix(check.substring(to: check.index(check.endIndex, offsetBy: -1))) {
                    return false
                }
            }
        }

        return true
    }
}
