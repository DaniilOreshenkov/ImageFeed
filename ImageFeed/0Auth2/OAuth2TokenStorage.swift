import UIKit

final class OAuth2TokenStorage {
    var token: String {
        get {
            guard let token = UserDefaults.standard.string(forKey: Constants.UserDefaults.bearerTokenKey) else {
                fatalError("Bearer token isn't string")
            }
            return token
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.UserDefaults.bearerTokenKey)
        }
    }
}
