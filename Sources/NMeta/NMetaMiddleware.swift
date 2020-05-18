import Vapor

public final class NMetaMiddleware: Middleware {

    public init() {}

    /// See `Middleware.respond(to:)`
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) -> EventLoopFuture<Response> {
        do {
            try request.application.nMeta.assertValid(request: request)
        } catch(let error) {
            return request.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: request)
    }
}
