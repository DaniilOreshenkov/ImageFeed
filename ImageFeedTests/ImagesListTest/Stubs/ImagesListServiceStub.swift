import Foundation
@testable import ImageFeed

final class ImagesListServiceStub: ImagesListServiceProtocol {
    static var didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    static var shared: ImagesListServiceProtocol = ImagesListServiceStub()
    var photoId = 0
    
    var photos: [ImageFeed.Photo] = [Photo(id: "0", size: CGSize.zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "http://")!, largeImageURL: URL(string: "http://")!, isLiked: false)]
    
    
    func clearBeforeLogout() {
        photos = [Photo(id: "0", size: CGSize.zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "http://")!, largeImageURL: URL(string: "http://")!, isLiked: false)]
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<ImageFeed.Photo, any Error>) -> Void) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index].changeLike()
            completion(.success((photos[index])))
        }
    }
    
    func fetchPhotosNextPage() {
        photoId += 1
        let newPhoto = Photo(id: "\(photoId)", size: CGSize.zero, createdAt: nil, welcomeDescription: nil, thumbImageURL: URL(string: "http://")!, largeImageURL: URL(string: "http://")!, isLiked: false)
        photos.append(newPhoto)
        NotificationCenter.default.post(name: ImagesListServiceStub.didChangeNotification, object: self)
    }
}
