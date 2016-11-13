import Vapor
import Foundation
final class NMeta {
    
    let platform: String
    let environment: String
    let version: String
    let major: Int
    let minor: Int
    let patch: Int
    let deviceOs: String
    let device: String
    
    init(nMeta: String) throws {
        let nMetaArr = nMeta.components(separatedBy: ";")
        
        // Set platform
        let platforms = try NMeta.platforms()
        if (nMetaArr.count < 1 || !platforms.contains(nMetaArr[0])) {
            throw Abort.custom(status: .badRequest, message: "Platform is not supported")
        }
        
        self.platform = nMetaArr[0];
        
        // Set environment
        let environments = try NMeta.environments()
        if(nMetaArr.count < 2 || !environments.contains(nMetaArr[1])) {
            throw Abort.custom(status: .badRequest, message: "Environment is not supported")
        }
        
        self.environment = nMetaArr[1];
        
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
        if(nMetaArr.count < 3) {
            throw Abort.custom(status: .badRequest, message: "Missing version")
        }
        
        self.version = nMetaArr[2]
        
        // Set major, minor & patch
        let versionArr = version.components(separatedBy: ".")
        
        self.major = versionArr.count >= 1 ? Int(versionArr[0]) ?? 0 : 0
        self.minor = versionArr.count >= 2 ? Int(versionArr[1]) ?? 0 : 0
        self.patch = versionArr.count >= 3 ? Int(versionArr[2]) ?? 0 : 0
       
        // Set device os
        if(nMetaArr.count < 4) {
            throw Abort.custom(status: .badRequest, message: "Missing device os")
        }
        
        self.deviceOs = nMetaArr[3]
        
        // Set device
        if(nMetaArr.count < 5) {
            throw Abort.custom(status: .badRequest, message: "Missing device")
        }
        
        self.device = nMetaArr[4]
    }
    
    static func platforms() throws -> [String] {
        // Get from config
        guard let platforms = drop.config["nmeta", "platforms"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "N-Meta error - nmeta.platforms config is missing or not an array")
        }
        
        // Make sure all values are strings
        var strictPlatforms : [String] = []
        try platforms.forEach({
            guard let platformStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "N-Meta error - one of the nmeta.platforms could not be casted to string")
            }
            
            strictPlatforms.append(platformStr)
        })
        
        return strictPlatforms;
    }
    
    static func environments() throws -> [String] {
        // Get config
        guard let envirionments = drop.config["nmeta", "environments"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "N-Meta error - nmeta.environments config is missing or not an array")
        }
        
        // Make sure all values are strings
        var strictEnvironments : [String] = []
        try envirionments.forEach({
            guard let environmentStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "N-Meta error - one of the nmeta.enviroments could not be casted to string")
            }
            
            strictEnvironments.append(environmentStr)
        })
        
        return strictEnvironments;
    }
    
    static func requiredEnvironments() throws -> [String] {
        // Get config
        guard let requiredEnvironments = drop.config["nmeta", "requiredEnvironments"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "N-Meta error - nmeta.requiredEnvironments config is missing or not an array")
        }
        
        // Make sure all values are strings
        var strictRequiredEnvironments : [String] = []
        try requiredEnvironments.forEach({
            guard let enviromentStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "N-Meta error - one of the nmeta.requiredEnvironments could not be casted to string")
            }
            
            strictRequiredEnvironments.append(enviromentStr)
        })
        
        return strictRequiredEnvironments;
    }
    
    static func exceptPaths() throws -> [String] {
        // Get config
        guard let exceptPaths = drop.config["nmeta", "exceptedPaths"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "N-Meta error - nmeta.exceptPaths config is missing or not an array")
        }
        
        // Make sure all values are strings
        var strictExceptPaths : [String] = []
        try exceptPaths.forEach({
            guard let exceptPathStr : String = $0.string else {
                throw Abort.custom(status: .internalServerError, message: "N-Meta error - one of the nmeta.exceptPaths could not be casted to string")
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
