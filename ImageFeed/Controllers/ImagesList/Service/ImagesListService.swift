import UIKit

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    
    private let tokenStorage = OAuth2TokenStorage()
    private let networkService = NetworkService()
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    init() {}
    
    
    func fetchPhotosNextPage() {
        if task != nil {
            print("Repeated fetch photos request ")
            return
        }
        
        let page = (lastLoadedPage ?? 0) + 1
        guard let request = makeRequestPhoto(page: page) else {
            print("Cannot construct request")
            return
        }
        
        let task = networkService.objectTask(for: request) { [weak self] (result: (Result<[PhotoResult], Error>)) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                lastLoadedPage = page
                print("ImagesListService - Result: Fetched \(photoResult) photos for page \(page)")
                photoResult.forEach {
                    guard let photo = self.convertToPhoto(from: $0) else { return }
                    self.photos.append(photo)
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                print("ImagesListService error: fetchPhotosNextPage - SomeError - \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequestPhoto(page: Int) -> URLRequest? {
        let baseURL = URL(string: Constants.defaultBaseURL)
        
        guard
            let url = URL(string: "/photos", relativeTo: baseURL)
        else {
            assertionFailure("Cannot construct url")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(tokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func convertToPhoto(from photoResult: PhotoResult) -> Photo? {
        
        let size = CGSize(width: photoResult.width, height: photoResult.height)
        
        guard let thumbImageURL = URL(string: photoResult.urls.thumb) else { return nil}
        guard let largeImageURL = URL(string: photoResult.urls.full) else { return nil}
        
        let photo = Photo(
            id: photoResult.id,
            size: size,
            createdAt: Date(), // MARK: edit Date
            welcomeDescription: photoResult.description ?? photoResult.altDescription,
            thumbImageURL: photoResult.urls.thumb,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser
        )
        
        return photo
    }
}
