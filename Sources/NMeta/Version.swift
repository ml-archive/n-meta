public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int
    
    public var string: String {
        return "\(major).\(minor).\(patch)"
    }
    
    public init(string: String) throws {
        let components = string.components(separatedBy: ".")
        var numbers    = components.flatMap({ $0.int })
        
        guard !numbers.isEmpty else {
            throw Abort(
                .badRequest,
                metadata: nil,
                reason: "Missing version number."
            )
        }
        
        major = numbers.removeFirst()
        minor = !numbers.isEmpty ? numbers.removeFirst() : 0
        patch = !numbers.isEmpty ? numbers.removeFirst() : 0
    }
}
