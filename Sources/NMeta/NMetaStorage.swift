import Vapor

public class NMetaStorage {

    public var config: NMetaConfig {
        get { self.storage.nMetaConfig }
        set { self.storage.nMetaConfig = newValue }
    }

    public var nMeta: NMeta? {
        get { self.storage.nMeta }
        set { self.storage.nMeta = newValue }
    }

    private let application: Application

    private final class Storage {
        var nMetaConfig: NMetaConfig
        var nMeta: NMeta?

        init() {
            self.nMetaConfig = .init()
        }
    }

    private struct Key: StorageKey {
        typealias Value = Storage
    }


    private var storage: Storage {
        if let existing = self.application.storage[Key.self] {
            return existing
        } else {
            let new = Storage()
            self.application.storage[Key.self] = new
            return new
        }
    }

    public init(application: Application) {
        self.application = application
    }
}
