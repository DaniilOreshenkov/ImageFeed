import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var isAvatarSet = false
    var isConfigure = false
    var isAvatarImageUpdated = false

    func setAvatar(url: URL) {
        isAvatarSet = true
    }
    
    func configure(model: ImageFeed.Profile?) {
        isConfigure = true
    }

    func configure(for profile: Profile) {
        isConfigure = true
    }

    func updateAvatar() {
        isAvatarImageUpdated = true
    }
}
