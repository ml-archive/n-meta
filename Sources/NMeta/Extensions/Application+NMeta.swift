import Vapor

extension Application {

    public var nMeta: NMetaStorage {
        .init(application: self)
    }
}
