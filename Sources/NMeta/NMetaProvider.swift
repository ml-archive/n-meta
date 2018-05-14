import Service
import Vapor

public final class NMetaProvider {
    public let config: NMetaConfig

    public init(config: NMetaConfig = NMetaConfig()) {
        self.config = config
    }
}

// MARK: - Provider
extension NMetaProvider: Provider {
    public func register(_ services: inout Services) {
        services.register(config)
        services.register(NMetaMiddleware.self)
        services.register { _ in
            return NMetaCache()
        }
    }

    public func didBoot(_ container: Container) -> EventLoopFuture<Void> {
        return .done(on: container)
    }
}
