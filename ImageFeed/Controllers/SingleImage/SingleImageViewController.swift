import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageURL: URL?
    
    var image = UIImage()
    
    override func viewDidLoad() {
        
        setFullImage()
        scrollView.delegate = self
        setupImageView()
    }
    
    override func viewWillLayoutSubviews() {
        configureScrollView(imageSize: image.size)
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityView.overrideUserInterfaceStyle = .dark
        present(activityView, animated: true)
    }
    
    private func setupImageView() {
        guard let image = imageView.image else { return }
        
        var widthScale: CGFloat = .zero
        var heightScale: CGFloat = .zero
        
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        if scrollViewSize.width != 0 && scrollViewSize.height != 0 {
            widthScale = scrollViewSize.width / imageSize.width
            heightScale = scrollViewSize.height / imageSize.height
        }
        
        let scale = min(widthScale, heightScale)
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
    }
    
    private func setFullImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let value):
                self.image = value.image
                self.imageView.frame.size = image.size
                self.configureScrollView(imageSize: image.size)
            case .failure(let error):
                print("Error \(error)")
                let alertPresenter = AlertPresenter()
                alertPresenter.delegate = self
                
                let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: "Попробовать еще раз?",
                    buttonText: "Ок") { [weak self] _ in
                        self?.setFullImage()
                    }
                alertPresenter.showAlert(model: alertModel)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func configureScrollView(imageSize: CGSize?) {
        
        
        setupZoomScales()
        centerImage()
        
        guard let imageSize = imageSize else { return }
        scrollView.contentSize = imageSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupZoomScales() {
        let scrollViewFrame = scrollView.bounds
        let imageSize = imageView.bounds.size
        let minScale = min(scrollViewFrame.width / imageSize.width, scrollViewFrame.height / imageSize.height)
        let maxScale = max(scrollViewFrame.width / imageSize.width, scrollViewFrame.height / imageSize.height)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        scrollView.zoomScale = maxScale
    }
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let xOffset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let yOffset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        imageView.center = CGPoint(x: xOffset + imageViewSize.width / 2, y: yOffset + imageViewSize.height / 2)
    }
}

// MARK: - UIScrollView Delegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
