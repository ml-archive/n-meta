import Vapor
import HTTP

public final class MetaMiddleware: Middleware {
    let drop: Droplet

    public init(drop: Droplet) {
        self.drop = drop
    }
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        if(try request.isMetaRequired(drop: drop)) {
            // Guard header config
            guard let headerStr = drop.config["meta", "header"]?.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - Missing meta.header config")
            }

            // Guard header is in request
            guard let meta = request.headers[HeaderKey(headerStr)]?.string else {
                throw Abort.custom(status: .badRequest, message: "Missing \(headerStr) header")
            }

            // Apply request
            try request.meta = Meta(drop: drop, meta: meta)
        }

        let response = try next.respond(to: request)

        return response
    }
}

