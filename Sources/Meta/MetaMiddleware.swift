import Vapor
import HTTP

public final class MetaMiddleware: Middleware {

    let drop: Droplet
    let configuration: Configuration

    public init(drop: Droplet) throws {
        self.drop = drop
        self.configuration = try Configuration(drop: drop)
    }

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        // Check if meta is required
        guard try request.isMetaRequired(configuration: configuration, drop: drop) else {
            return try next.respond(to: request)
        }

        // Extract and add meta to request
        let metaString = try configuration.extractHeaderString(withRequest: request)
        request.meta   = try Meta(configuration: configuration, meta: metaString)

        return try next.respond(to: request)
    }
}

