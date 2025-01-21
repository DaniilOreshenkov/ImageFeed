import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(ServiceError.differentCodes))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("OAuth2Service error: The makeOAuthTokenRequest function returned nil, the request was not created.")
            return
        }
        
        let task = networkService.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let token):
                    guard let token = token.accessToken else {
                        fatalError("token is nil")
                    }
                    completion(.success(token))
                case .failure(let error):
                    completion(.failure(error))
                    print("Error: fetchOAuthToken - NetworkError - \(error.localizedDescription)")
                }
                self.task = nil
                self.lastCode = nil
            }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: Constants.unsplashAuthorizeURLString)
        
        guard
            let url = URL(string: "/oauth/token"
                          + "?client_id=\(Constants.accessKey)"
                          + "&&client_secret=\(Constants.secretKey)"
                          + "&&redirect_uri=\(Constants.redirectURI)"
                          + "&&code=\(code)"
                          + "&&grant_type=authorization_code",
                          relativeTo: baseURL)
        else {
            print("Auth2service: Error creating the URL request.")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
