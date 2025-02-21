import Foundation
@testable import ImageFeed

final class AuthHelperFake: AuthHelperProtocol {
    func authRequest() -> URLRequest? {
        return URLRequest(url: URL(string: "https://")!)
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
