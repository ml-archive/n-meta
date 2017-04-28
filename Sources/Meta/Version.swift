import Vapor

public struct Version {
    let major: Int
    let minor: Int
    let patch: Int

    var string: String {
        return "\(major).\(minor).\(patch)"
    }

    init(string: String) throws {
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

extension Version: NodeConvertible {
    public init(node: Node) throws {
        major = try node.get("major")
        minor = try node.get("minor")
        patch = try node.get("patch")
    }

    public func makeNode(in context: Context?) throws -> Node {
        return Node([
            "major": Node(major),
            "minor": Node(minor),
            "patch": Node(patch)
            ])
    }
}
