import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    // MARK: Properties
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .photo)
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = UIColor(resource: .ypWhite)
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ecaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(resource: .ypGray)
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(resource: .ypWhite)
        label.numberOfLines = 0
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(.exit, for: .normal)
        return button
    }()
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(model: profileService.profile)
    
        setupViews()
        setupLayouts()
        setupAppearance()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    func configure(model: Profile?) {
        guard let model = model else { return }
        userNameLabel.text = model.name
        loginLabel.text = model.loginName
        descriptionLabel.text = model.bio
    }
    
    private func updateAvatar() {
        
        let processor = RoundCornerImageProcessor(cornerRadius: 50)
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .stub),
            options: [
                .processor(processor)
            ]
        )
    }
    
    private func setupViews() {
        [
            avatarImageView,
            userNameLabel,
            loginLabel,
            descriptionLabel,
            logoutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            loginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = UIColor(resource: .ypBlack)
        logoutButton.addTarget(self, action: #selector(buttonLogoutTapped), for: .touchUpInside)
    }
    
    @objc private func buttonLogoutTapped() {
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            buttonText: "Да") { [weak self] _ in
                guard let self else { return }
                self.profileLogoutService.logout()
            }
        alertPresenter.showAlert(model: alertModel, button: true)
    }
}
