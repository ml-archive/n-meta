import HTTP
import Vapor

extension Request {
    var meta: Meta? {
        get { return storage["meta"] as? Meta }
        set { storage["meta"] = newValue }
    }

    func isMetaRequired(drop: Droplet) throws -> Bool {
        // Only APIs
        if(accept.prefers("html")) {
            return false;
        }

        // Check environments
        let requiredEnvironments = try Meta.requiredEnvironments(drop: drop)
        if(!requiredEnvironments.contains(drop.environment.description)) {
            return false
        }

        // Check paths
        let exceptPaths = try Meta.exceptPaths(drop: drop)
        if(exceptPaths.contains(uri.path)) {
            return false
        }

        return true;
    }
}
