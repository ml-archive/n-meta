import Vapor
import HTTP

final class MetaMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)

        if(try request.isMetaRequired()) {
            // Guard header config
            guard let headerStr = drop.config["meta", "header"]?.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - Missing meta.header config")
            }

            // Guard header is in request
            guard let meta = request.headers[HeaderKey(headerStr)]?.string else {
                throw Abort.custom(status: .badRequest, message: "Missing \(headerStr) header")
            }

            // Apply request
            try request.meta = Meta(meta: meta)
        }

        return response
    }
}

