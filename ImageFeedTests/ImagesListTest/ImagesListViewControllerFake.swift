import Foundation
import ImageFeed
import XCTest

final class ImagesListViewControllerFake: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListPresenterProtocol)?
    
    func showProgressHUD() {
        
    }
    
    func dismissProgressHUD() {
        
    }
    
    func updateTableViewAnimated() {
        let (_, _) = presenter!.updatePhotosAndGetCounts()
    }
}
