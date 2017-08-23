import HTTP
import Vapor
import Foundation

extension Request {
    public var meta: Meta? {
        get { return storage["meta"] as? Meta }
        set { storage["meta"] = newValue }
    }
}
