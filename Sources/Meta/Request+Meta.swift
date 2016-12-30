import HTTP
import Vapor

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
        if !configuration.requiredEnvironments.contains(drop.environment.description) {
            return false
        }

        // Bypass CORS requests
        if method.equals(any: .options) {
            return false
        }

        // Check except paths
        if configuration.exceptPaths.contains(uri.path) {
            return false
        }

        return true
    }
}
