import Async
import HTTP
import Vapor

public final class NMetaMiddleware: Middleware, ServiceType {
    public static func makeService(for container: Container) throws -> NMetaMiddleware {
        return .init()
    }

    public init() {}

    /// See `Middleware.respond(to:)`
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Future<Response> {

        let config = try request.make(NMetaConfig.self)
        let nMetaHandler = try NMetaHandler(config)

        if try nMetaHandler.isMetaRequired(request: request) {
            // Extract and add meta to request.
            try request.make(NMetaCache.self).nMeta = try nMetaHandler.metaOrFail(request: request)
        }
        return try next.respond(to: request)
    }
}
