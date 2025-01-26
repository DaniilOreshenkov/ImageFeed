import Foundation

enum Constants {
    static let accessKey = "j774M6EHwLyeyINnOm63zrJ7mbiLiVr0O9fh8Bzuazc"
    static let secretKey = "l2I2ND2sizJ0YOWySs7ZywD7o4WaHRHvP2Kxu6w88Jw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    enum UserDefaults {
        static let bearerTokenKey = "bearerToken"
    }
}
