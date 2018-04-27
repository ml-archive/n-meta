import Async
import HTTP
import Vapor

public final class NMetaMiddleware: Middleware, Service {
    
    public init() {}
    
    /// See `Middleware.respond(to:)`
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        return try next.respond(to: request).map(to: Response.self) { res in
            
            let config = try request.make(NMetaConfig.self)
            let nMetaHandler = try NMetaHandler(config)
            
            guard try nMetaHandler.isMetaRequired(request: request) else {
                return res
            }
            
            // Extract and add meta to request.
            try request.make(NMetaCache.self).nMeta = try nMetaHandler.metaOrFail(request: request)
            
            return res
        }
    }
}

