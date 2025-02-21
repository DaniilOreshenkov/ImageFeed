import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    var photos = [Photo]()
    
    var isViewDidLoad = false
    var isUpdatePhotosCalled = false
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhoto(at index: Int) -> Photo? {
        return nil
    }
    
    func updatePhotosAndGetCounts() -> (Int, Int) {
        isUpdatePhotosCalled = true
        return (0, 0)
    }
    
    func nextPage() {
        
    }
    
    func shouldGetNextPage(for index: Int) {
        
    }
    
    func changeLike(at index: Int, _ completion: @escaping (Result<Bool, any Error>) -> Void) {
        
    }
    
    func viewDidLoad() {
        isViewDidLoad = true
    }
}
