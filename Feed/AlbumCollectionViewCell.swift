import Foundation
import UIKit

final class AlbumCollectionViewCell: UICollectionViewCell {
    private let albumArtImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let artistNamelabel: UILabel = {
        let label = UILabel()
        label.font = .caption
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackV = UIStackView()
        stackV.distribution = .fill
        stackV.axis = .vertical
        stackV.isLayoutMarginsRelativeArrangement = true
        stackV.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        return stackV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        addSubview(albumArtImageView)
        
        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        albumArtImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumArtImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        albumArtImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        albumArtImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.addArrangedSubview(albumNameLabel)
        stackView.addArrangedSubview(artistNamelabel)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func updateCell(item: FeedResult) {
        if let url = URL(string: item.artworkUrl100) {
            if let image = ImageCache.shared.image(url: url) {
                albumArtImageView.image = image
            } else {
                ImageCache.shared.load(url: url) { image in
                    self.albumArtImageView.image = image
                }
            }
        }
        artistNamelabel.text = item.artistName
        albumNameLabel.text = item.name
    }
}
