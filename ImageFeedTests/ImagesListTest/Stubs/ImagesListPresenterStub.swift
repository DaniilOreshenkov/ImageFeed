import Foundation
import ImageFeed

final class ImagesListPresenterStub: ImagesListPresenterProtocol {
    weak var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    var isLiked = false
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhoto(at index: Int) -> ImageFeed.Photo? {
        return nil
    }
    
    func updatePhotosAndGetCounts() -> (Int, Int) {
        return (0, 0)
    }
    
    func nextPage() { }
    
    func shouldGetNextPage(for index: Int) { }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        view?.showProgressHUD()
        
        isLiked = !isLiked
        completion(.success(isLiked))
    }
    
    func viewDidLoad() { }
}
