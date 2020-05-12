import Vapor

public final class NMetaMiddleware: Middleware {

    public init() {}

    /// See `Middleware.respond(to:)`
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) -> EventLoopFuture<Response> {
        do {
            let config = request.application.nMeta.config
            let nMetaHandler = try NMetaHandler(config: config)

            if try nMetaHandler.isMetaRequired(request: request) {
                // Extract and add meta to request.
                request.nMeta = try nMetaHandler.metaOrFail(request: request)
            }
        } catch(let error) {
            return request.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: request)
    }
}
