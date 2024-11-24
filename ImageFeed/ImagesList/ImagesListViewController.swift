import UIKit

final class ImagesListViewController: UIViewController {
    
    //MARK: @IBOutlet
    @IBOutlet private var tableView: UITableView!

    //MARK: Private property
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let currentDate = Date()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    //MARK: Private method
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableView DataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        ) as? ImagesListCell else {
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
    
        doGradient(for: cell.gradientView)
        
        cell.imageCell.image = image
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    private func doGradient(for view: UIView) {
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = view.bounds
        
        gradientMaskLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientMaskLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        let ypColor20 = UIColor(named: "YP Black")?.withAlphaComponent(0.2).cgColor
        let ypColor15 = UIColor(named: "YP Black")?.withAlphaComponent(0.15).cgColor
        gradientMaskLayer.colors = [ypColor20 ?? UIColor.black.withAlphaComponent(0.3).cgColor,
                                    ypColor15 ?? UIColor.black.withAlphaComponent(0.15).cgColor,
                                    UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 0.7, 1]
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.mask = gradientMaskLayer
    }
}
