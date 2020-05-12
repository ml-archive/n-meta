import Vapor

extension Request {
    public var nMeta: NMeta? {
        get { self.application.nMeta.nMeta }
        set { self.application.nMeta.nMeta = newValue }
    }
}
