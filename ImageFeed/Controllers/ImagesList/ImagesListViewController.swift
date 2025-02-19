import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    //MARK: @IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    //MARK: Private property
    var presenter: ImagesListPresenterProtocol?
    
    init(presenter: ImagesListPresenterProtocol? = nil) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListCell = UITableViewCell()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(
        //            forName: ImagesListService.didChangeNotification,
        //            object: nil,
        //            queue: .main) { [weak self] _ in
        //                guard let self = self else { return }
        //                self.updateTableViewAnimated()
        imageListCell = ImagesListCell()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard
                let url = presenter?.getPhoto(at: indexPath.row)?.largeImageURL
            else {
                return
            }
            
            viewController.imageURL = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func showProgressHUD() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissProgressHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateTableViewAnimated() {
        guard
            let (oldCount, newCount) = presenter?.updatePhotosAndGetCounts()
        else { return }
        
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    //MARK: Private method
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableView DataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let imageListCell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }
        
        guard
            let photo = presenter?.getPhoto(at: indexPath.row)
        else {
            return imageListCell
        }
        
        imageListCell.delegate = self
        imageListCell.configCell(in: tableView, with: indexPath, photo: photo)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.shouldGetNextPage(for: indexPath.row)
    }
}

// MARK: - UITableView Delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier,
                     sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(at: indexPath.row) else {
            return UIImage(named: "PlaceholderCellImage")?.size.height ?? 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    //    func imageListCellDidTapLike(_ cell: ImagesListCell) {
    //        guard let indexPath = tableView.indexPath(for: cell) else { return }
    //        let photo = photos[indexPath.row]
    //
    //        UIBlockingProgressHUD.show()
    //        imagesListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self] result in
    //            guard let self = self else { return }
    //            switch result {
    //            case .success(let newPhoto):
    //                self.photos[indexPath.row] = newPhoto
    //                cell.setIsLiked(newPhoto.isLiked)
    //            case .failure(let error):
    //                print(error)
    //            }
    //            UIBlockingProgressHUD.dismiss()
    //        }
    //    }
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.changeLike(at: indexPath.row) { [weak self] result in
            switch result {
            case .success(let isLiked):
                cell.setIsLiked(isLiked)
                self?.dismissProgressHUD()
            case .failure(let error):
                print(error)
            }
        }
    }
}
