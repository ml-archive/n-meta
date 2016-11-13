import Vapor
import Fluent
import Foundation
import HTTP

final class NMetaMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        
        if(try request.isNMetaRequired()) {
            // Guard header config
            guard let headerStr = drop.config["nmeta", "header"]?.string else {
                throw Abort.custom(status: .internalServerError, message: "N-Meta error - Missing nmeta.header config")
            }
            
            // Guard header is in request
            guard let nMeta = request.headers[HeaderKey(headerStr)]?.string else {
                throw Abort.custom(status: .badRequest, message: "Missing \(headerStr) header")
            }
            
            // Apply request
            try request.nMeta = NMeta(nMeta: nMeta)
        }
        
        return response
    }
}

