import UIKit

class BaseViewController: UIViewController {
    var activityIndictor = UIActivityIndicatorView(style: .large)

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
