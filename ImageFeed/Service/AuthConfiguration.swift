import Foundation

enum Constants {
    static let accessKey = "j774M6EHwLyeyINnOm63zrJ7mbiLiVr0O9fh8Bzuazc"
    static let secretKey = "l2I2ND2sizJ0YOWySs7ZywD7o4WaHRHvP2Kxu6w88Jw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    enum Keys {
        static let bearerTokenKey = "bearerToken"
    }
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}
