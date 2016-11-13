import HTTP
import Vapor

extension Request {
    var nMeta: NMeta? {
        get { return storage["nmeta"] as? NMeta }
        set { storage["nmeta"] = newValue }
    }
    
    func isNMetaRequired() throws -> Bool {
        
        print(drop.environment.description)
        
        // Only APIs
        if(accept.prefers("html")) {
            return false;
        }
        
        // Check environments
        let requiredEnvironments = try NMeta.requiredEnvironments()
        if(!requiredEnvironments.contains(drop.environment.description)) {
            return false
        }
        
        // Check paths
        let exceptPaths = try NMeta.exceptPaths()
        print(exceptPaths)
        if(exceptPaths.contains(uri.path)) {
            return false
        }
        
        return true;
    }
}
