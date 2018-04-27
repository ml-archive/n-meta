public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    enum NMetaVersionError: String, Error {
        case missingVersionNumber
    }
    
    public var string: String {
        return "\(major).\(minor).\(patch)"
    }
    
    public init(string: String) throws {
        let components = string.components(separatedBy: ".")
        var numbers    = components.compactMap({ Int($0) })
        
        guard !numbers.isEmpty else {
            throw NMetaVersionError.missingVersionNumber
        }
        
        major = numbers.removeFirst()
        minor = !numbers.isEmpty ? numbers.removeFirst() : 0
        patch = !numbers.isEmpty ? numbers.removeFirst() : 0
    }
}
