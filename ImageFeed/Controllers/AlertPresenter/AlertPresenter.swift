import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    func showAlert(model: AlertModel, button cancel: Bool = false) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert"
        let button = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        button.accessibilityIdentifier = "Yes"
        let buttonCancel = UIAlertAction(title: "Нет", style: .default) { _ in }
        alert.addAction(button)
        
        if cancel {
            alert.addAction(buttonCancel)
        }
        
        delegate?.present(alert, animated: true)
    }
}
