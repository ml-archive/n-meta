import Vapor
import HTTP

public final class Middleware: HTTP.Middleware, ConfigInitializable {
    private let metaHandler: MetaHandler

    public init(config: Config) throws {
        let metaConfig = try Configuration(config)
        metaHandler = MetaHandler(metaConfig)
    }

    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Response {
        // Check if meta is required
        guard try metaHandler.isMetaRequired(request: request) else {
            return try next.respond(to: request)
        }

        // Extract and add meta to request.
        request.meta = try metaHandler.metaOrFail(request: request)

        return try next.respond(to: request)
    }
}
