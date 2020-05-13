public struct Version {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public var string: String {
        "\(major).\(minor).\(patch)"
    }

    public init(string: String) throws {
        let components = string.components(separatedBy: ".")
        var numbers = components.compactMap(Int.init)

        guard !numbers.isEmpty else {
            throw NMetaError.versionIsIncorrectFormat
        }

        major = numbers.removeFirst()
        minor = numbers.isEmpty ? 0 : numbers.removeFirst()
        patch = numbers.isEmpty ? 0 : numbers.removeFirst()
    }
}
