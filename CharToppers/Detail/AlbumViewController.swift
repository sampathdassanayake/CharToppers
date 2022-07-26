import UIKit

class AlbumViewController: BaseViewController {
    var coordinator: AlbumCoordinator?
    var item: FeedResult?
    var copyright: String?
    
    private let albumArtImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .h1
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .gray
        label.numberOfLines = 3
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackV = UIStackView()
        stackV.distribution = .fill
        stackV.alignment = .fill
        stackV.axis = .vertical
        stackV.spacing = 10
        stackV.isLayoutMarginsRelativeArrangement = true
        stackV.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        return stackV
    }()
    
    var chipContainer: UIStackView = {
        let stackV = UIStackView()
        stackV.distribution = .equalSpacing
        stackV.alignment = .center
        stackV.axis = .horizontal
        stackV.spacing = 10
        return stackV

    }()
    
    let chip: UILabel = {
        let chip = UILabel()
        chip.layer.borderWidth = 0.5
        chip.layer.borderColor = UIColor.blue.cgColor
        chip.layer.cornerRadius = 10
        chip.font = .caption
        chip.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return chip
    }()

    var spacerView: UIView = {
        return UIView()
    }()
    
    var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var copyrightLabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .gray
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    var visitButton: UIButton = {
        let button = UIButton()
        button.setTitle("visit_the_album".localized, for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        return button
    }()
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .init(white: 1, alpha: 0.5)
        button.setImage(UIImage(named: "chevron_left"), for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    func configureView() {
        self.view.backgroundColor = .white
        self.view.addSubview(albumArtImageView)
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        albumArtImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        albumArtImageView.heightAnchor.constraint(equalTo: albumArtImageView.widthAnchor).isActive = true
        albumArtImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        albumArtImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        albumArtImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        stackView.addArrangedSubview(artistNameLabel)
        stackView.addArrangedSubview(albumNameLabel)
        
        chipContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.addArrangedSubview(chipContainer)
        
        stackView.addArrangedSubview(spacerView)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(copyrightLabel)
        
        visitButton.heightAnchor.constraint(equalToConstant: 155).isActive = true
        visitButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        visitButton.addTarget(self, action: #selector(visitAlbum), for: .touchUpInside)
        stackView.addArrangedSubview(visitButton)
        
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: albumArtImageView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func updateView() {
        guard let item = item else {
            return
        }

        artistNameLabel.text = item.artistName
        albumNameLabel.text = item.name
        
        if let url = URL(string: item.artworkUrl100) {
            if let image = ImageCache.shared.image(url: url) {
                albumArtImageView.image = image
            } else {
                ImageCache.shared.load(url: url) { image in
                    self.albumArtImageView.image = image
                }
            }
        }
        
        for genre in item.genres {
//            let view = UIView()
            chip.text = "   \(genre.name)   "
//            view.addSubview(chip)
//            chip.leftAnchor
            chipContainer.addArrangedSubview(chip)

        }
        chipContainer.sizeToFit()
        chipContainer.addArrangedSubview(UIView())
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: item.releaseDate) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            releaseDateLabel.text = "released".localized + dateFormatter.string(from: date)
        }
        
        if let copyright = copyright {
            copyrightLabel.text = copyright
        }
    }
    
    @objc
    func visitAlbum() {
        guard let item = item, let url = URL(string: item.url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @objc
    func closeView() {
        coordinator?.pop()
    }

}


