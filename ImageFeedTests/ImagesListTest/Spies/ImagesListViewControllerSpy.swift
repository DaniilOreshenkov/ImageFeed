import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListPresenterProtocol)?
    
    var isShowedProgressHUD = false
    var isCalledUpdateTable = false
    
    func showProgressHUD() {
        isShowedProgressHUD = true
    }
    
    func dismissProgressHUD() {
        
    }
    
    func updateTableViewAnimated() {
        isCalledUpdateTable = true
    }
}
