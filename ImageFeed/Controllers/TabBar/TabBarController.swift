import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "TabBarController"
        view.backgroundColor = UIColor(resource: .ypBlack)
        tabBar.barTintColor = UIColor(resource: .ypBlack)
        tabBar.tintColor = UIColor(resource: .ypWhite)
        tabBar.isTranslucent = false
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        
        let imagesListService = ImagesListService.shared
        let presenterImagesList = ImagesListPresenter(imagesListService: imagesListService)
        imagesListViewController.presenter = presenterImagesList
        presenterImagesList.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditorialActive),
            selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
