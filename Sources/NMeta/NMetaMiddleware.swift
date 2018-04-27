import Async
import HTTP
import Vapor

public final class NMetaMiddleware: Middleware, Service {
    
    /// Creates a new `NMetaMiddleware`
    public init() { }
    
    /// See `Middleware.respond(to:)`
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        return try next.respond(to: request).map(to: Response.self) { res in
            return res
        }
    }
}

