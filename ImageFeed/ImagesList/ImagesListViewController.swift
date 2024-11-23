import UIKit

class ImagesListViewController: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    //MARK: Private property
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    //MARK: Private method
    private func setupTableView() {
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableView DataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableView Delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - ImagesListViewController
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)  {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.imageCell.image = image
        cell.dateLabel.text = Date().dateTimeString
        
        let indexPathRow = indexPath.row + 1
        let isLiked = indexPathRow % 2 == 0
        let likeImage = isLiked ? UIImage(named: "LikeButtonActive") : UIImage(named: "LikeButtonNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

