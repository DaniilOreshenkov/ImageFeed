import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            guard let token = KeychainWrapper.standard.string(forKey: Constants.Keys.bearerTokenKey) else {
                print("Bearer token isn't string")
                return KeychainWrapper.standard.string(forKey: Constants.Keys.bearerTokenKey)
            }
            
            return token
        }
        
        set {
            KeychainWrapper.standard.set(newValue ?? "", forKey: Constants.Keys.bearerTokenKey)
        }
    }
}
