import Foundation
import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
    static var shared: any ImageFeed.ProfileServiceProtocol = ProfileServiceStub()
    
    var profile: ImageFeed.Profile? = Profile()
    
    func clearBeforeLogout() { }
    
    func fetchProfile(bearerToken: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
        profile = Profile()
    }
    
    
}
