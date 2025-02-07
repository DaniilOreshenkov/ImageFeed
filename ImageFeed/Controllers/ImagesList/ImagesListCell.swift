import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    weak var delegate: ImagesListCellDelegate?
    
    private var isLiked = false
    private var photoId: String?
    
    private let currentDate = Date()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientView.subviews.forEach { $0.removeFromSuperview() }
        imageCell.kf.cancelDownloadTask()
    }
    
    @IBAction private func buttonLikeTapped(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let newImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        self.likeButton.setImage(newImage, for: .normal)
    }
    
    func configCell(in tableView: UITableView, with indexPath: IndexPath, photo: Photo)  {        
        isLiked = photo.isLiked
        photoId = photo.id
        
        guard
            let likeImage = photo.isLiked
                ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        else {
            return
        }
        
        imageCell.kf.indicatorType = .activity
        imageCell.kf.setImage(with: photo.thumbImageURL, placeholder: UIImage(resource: .placeholder)) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        dateLabel.text = photo.createdAt
        likeButton.setImage(likeImage, for: .normal)
        
        doGradient(for: gradientView)
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
