import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func setAvatar(url: URL)
    func configure(model: Profile?)
    func updateAvatar()
}
