import UIKit

final class SplashViewController: UIViewController {
    
    private let showGallerySegueId = "showGallery"
    private let showAuthSegueId = "showAuthorization"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        showNextScreen()
    }
    
//    private func showNextScreen() {
//        guard let token = oauth2TokenStorage.token else { return }
//        let token2: String? = nil
//        if ((token2?.isEmpty) != nil) {
//            print("gallery showed")
//            performSegue(withIdentifier: showGallerySegueId, sender: self)
//        } else {
//            performSegue(withIdentifier: showAuthSegueId, sender: self)
//        }
//    }
    
    private func showNextScreen() {
        if let token = oauth2TokenStorage.token, !token.isEmpty {
            print("gallery showed")
            performSegue(withIdentifier: showGallerySegueId, sender: self)
        } else {
            performSegue(withIdentifier: showAuthSegueId, sender: self)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
           
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthSegueId {
            let navigationController = segue.destination as? UINavigationController
            guard let authViewController = navigationController?.viewControllers[0] as? AuthViewController 
            else {
                assertionFailure("Failed to prepare for \(showAuthSegueId)")
                return
            }
            
            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}
