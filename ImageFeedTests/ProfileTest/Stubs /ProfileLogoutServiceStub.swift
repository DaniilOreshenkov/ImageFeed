
import Foundation
import ImageFeed

final class ProfileLogoutServiceStub: ProfileLogoutServiceProtocol {
    static var shared: any ImageFeed.ProfileLogoutServiceProtocol = ProfileLogoutServiceStub()
    
    func logout() { }
}
