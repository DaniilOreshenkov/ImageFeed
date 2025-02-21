import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func doLogoutAction()
    func updateAvatar()
    func viewDidLoad()
}
