import Vapor
final class Meta {
    let drop: Droplet
    let platform: String
    let environment: String
    let version: String
    let major: Int
    let minor: Int
    let patch: Int
    let deviceOs: String
    let device: String

    init(drop: Droplet, meta: String) throws {
        self.drop = drop
        let metaArr = meta.components(separatedBy: ";")

        // Set platform
        let platforms = try Meta.platforms(drop: drop)
        if (metaArr.count < 1 || !platforms.contains(metaArr[0])) {
            throw Abort.custom(status: .badRequest, message: "Platform is not supported")
        }

        self.platform = metaArr[0];

        // Set environment
        let environments = try Meta.environments(drop: drop)
        if(metaArr.count < 2 || !environments.contains(metaArr[1])) {
            throw Abort.custom(status: .badRequest, message: "Environment is not supported")
        }

        self.environment = metaArr[1];

        // Since web is normally using a valid User-Agent there is no reason for asking for more
        if(platform == "web") {
            self.version = "0.0.0"
            self.major = 0
            self.minor = 0
            self.patch = 0
            self.deviceOs = "N/A"
            self.device = "N/A"
            return;
        }

        // Set version
        if(metaArr.count < 3) {
            throw Abort.custom(status: .badRequest, message: "Missing version")
        }

        self.version = metaArr[2]

        // Set major, minor & patch
        let versionArr = version.components(separatedBy: ".")

        self.major = versionArr.count >= 1 ? Int(versionArr[0]) ?? 0 : 0
        self.minor = versionArr.count >= 2 ? Int(versionArr[1]) ?? 0 : 0
        self.patch = versionArr.count >= 3 ? Int(versionArr[2]) ?? 0 : 0

        // Set device os
        if(metaArr.count < 4) {
            throw Abort.custom(status: .badRequest, message: "Missing device os")
        }

        self.deviceOs = metaArr[3]

        // Set device
        if(metaArr.count < 5) {
            throw Abort.custom(status: .badRequest, message: "Missing device")
        }

        self.device = metaArr[4]
    }

    static func platforms(drop: Droplet) throws -> [String] {
        // Get from config
        guard let platforms = drop.config["meta", "platforms"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "Meta error - meta.platforms config is missing or not an array")
        }

        // Make sure all values are strings
        var strictPlatforms : [String] = []
        try platforms.forEach({
            guard let platformStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - one of the meta.platforms could not be casted to string")
            }

            strictPlatforms.append(platformStr)
        })

        return strictPlatforms;
    }

    static func environments(drop: Droplet) throws -> [String] {
        // Get config
        guard let envirionments = drop.config["meta", "environments"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "Meta error - meta.environments config is missing or not an array")
        }

        // Make sure all values are strings
        var strictEnvironments : [String] = []
        try envirionments.forEach({
            guard let environmentStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - one of the meta.enviroments could not be casted to string")
            }

            strictEnvironments.append(environmentStr)
        })

        return strictEnvironments;
    }

    static func requiredEnvironments(drop: Droplet) throws -> [String] {
        // Get config
        guard let requiredEnvironments = drop.config["meta", "requiredEnvironments"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "Meta error - meta.requiredEnvironments config is missing or not an array")
        }

        // Make sure all values are strings
        var strictRequiredEnvironments : [String] = []
        try requiredEnvironments.forEach({
            guard let enviromentStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - one of the meta.requiredEnvironments could not be casted to string")
            }

            strictRequiredEnvironments.append(enviromentStr)
        })

        return strictRequiredEnvironments;
    }

    static func exceptPaths(drop: Droplet) throws -> [String] {
        // Get config
        guard let exceptPaths = drop.config["meta", "exceptedPaths"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "Meta error - meta.exceptPaths config is missing or not an array")
        }

        // Make sure all values are strings
        var strictExceptPaths : [String] = []
        try exceptPaths.forEach({
            guard let exceptPathStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "Meta error - one of the meta.exceptPaths could not be casted to string")
            }

            strictExceptPaths.append(exceptPathStr)
        })

        return strictExceptPaths;
    }

    func toNode() -> Node {
        return Node([
                "platform": Node(platform),
                "environment": Node(environment),
                "version": Node(version),
                "major": Node(major),
                "minor": Node(minor),
                "patch": Node(patch),
                "deviceOs": Node(deviceOs),
                "device": Node(device)
        ])
    }
}
