import Vapor

extension Request {
    
    public func getNMeta() throws -> NMeta {
        guard let nMeta = try make(NMetaContainerService.self).nMeta else {
            throw NMetaError.nMetaIsNotAttachedToRequest
        }
        
        return nMeta
    }
}
