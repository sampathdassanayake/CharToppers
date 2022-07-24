import UIKit

class BaseViewController: UIViewController {
    var activityIndictor = UIActivityIndicatorView(style: .large)
    lazy var errorStateMessage: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showSpinner() {
        activityIndictor.translatesAutoresizingMaskIntoConstraints = false
        activityIndictor.startAnimating()
        self.view.addSubview(activityIndictor)
        activityIndictor.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndictor.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func hideSpinner() {
        self.activityIndictor.stopAnimating()
        self.activityIndictor.removeFromSuperview()
    }
    
    
}
