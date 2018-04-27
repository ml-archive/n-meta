import Foundation
import Vapor

/// Config options for a `NMetaConfig`
public struct NMetaConfig: ServiceType {
    // The request header, which is meta data will be exctracted from
    public let headerKey: String
    
    // The supported platforms
    public let platforms: [String]
    
    // The supported environments
    public let environments: [String]
    
    // Ignore requirement on following paths
    public let exceptPaths: [String]
    
    /// Only check header on following environments
    public let requiredEnvironments: [String]
    
    /// Creates a new `NMetaConfig`.
    public init(
        headerKey: String = "N-Meta",
        platforms: [String] = ["web", "android", "ios"],
        environments: [String] = ["local", "development", "staging", "production"],
        exceptPaths: [String] = [ "/js/*", "/css/*", "/images/*", "/favicons/*", "/admin/*"],
        requiredEnvironments: [String] = ["local", "development", "staging", "production"])
    {
        self.headerKey = headerKey
        self.platforms = platforms
        self.environments = environments
        self.exceptPaths = exceptPaths
        self.requiredEnvironments = requiredEnvironments
    }
    
    // Create default `NMetaConfig`.
    public static func makeService(for worker: Container) throws -> NMetaConfig {
        return self.init()
    }
}
