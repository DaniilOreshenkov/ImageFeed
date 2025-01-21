import UIKit

final class SplashViewController: UIViewController {
    // MARK: UI
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Properties
    private let tokenStorage = OAuth2TokenStorage()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNextScreen()
    }
    
    private func configure() {
        view.backgroundColor = UIColor(resource: .ypBlack)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
        ])
    }
    
    private func showNextScreen() {
        if let token = tokenStorage.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            if let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController2") as? AuthViewController {
                
                authViewController.delegate = self
                let navigationController = UINavigationController(rootViewController: authViewController)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

// MARK: AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: false)
    }
}
// MARK: AuthViewController Network
extension SplashViewController {
    private func fetchProfile(token: String) {
        let profileService = ProfileService.shared
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
}
