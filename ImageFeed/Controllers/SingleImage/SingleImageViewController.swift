import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        imageView.image = image
        scrollView.delegate = self
        setupImageView()
        configureScrollView(imageSize: image?.size)
    }
    
    override func viewWillLayoutSubviews() { 
        configureScrollView(imageSize: image?.size)
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = image else { return }
        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityView.overrideUserInterfaceStyle = .dark
        present(activityView, animated: true)
    }
    
    func setupImageView() {
        guard let image = imageView.image else { return }
        
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let scale = min(widthScale, heightScale) 
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)
    }
    
    private func configureScrollView(imageSize: CGSize?) {
        guard let imageSize = imageSize else { return }
        scrollView.contentSize = imageSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        setupZoomScales()
        centerImage()
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
