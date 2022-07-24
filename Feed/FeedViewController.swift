import RealmSwift
import UIKit

class FeedViewController: BaseViewController {
    var coordinator: FeedCoordinator?
    var collectionView: UICollectionView?
    lazy var viewModel: FeedViewModel = FeedViewModel()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        observeFeed()
        loadFeed()
        self.title = "app.title".localized
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCell")
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.dataSource = self
        collectionView?.prefetchDataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView ?? UICollectionView())
        
        self.view = view
    }
    
    func loadFeed() {
        viewModel.loadFeedFromAPI {error in
            if let error = error {
                self.showError(error: error)
            }
        }
    }
    
    func observeFeed() {
        token = viewModel.feed?.observe({ [unowned self] changes in
            self.hideSpinner()
            switch changes {
            case .error(let error):
                self.showError(error: error)
            case .initial, .update:
                self.collectionView?.reloadData()
            }
        })
        
        if viewModel.feed?.first?.results != nil {
            self.collectionView?.reloadData()
        } else {
            showSpinner()
        }
    }
    
    func showError(error: Error) {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(title: "alert".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
            alert.addAction(UIAlertAction(title: "try_again".localized, style: .default, handler: { action  in
                self.loadFeed()
            }))
            self.present(alert, animated: true)
        }
    }
}


extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.feed?.first?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = viewModel.feed?.first?.results[indexPath.row],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell(frame: .zero)
        }
        
        cell.updateCell(item: item)
        return cell
    }
}

extension FeedViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let item = viewModel.feed?.first?.results[indexPath.row],
               let url = URL(string: item.artworkUrl100) {
                ImageCache.shared.load(url: url) { _ in }
            }
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing - 5
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel.feed?.first?.results[indexPath.row] else { return }
        coordinator?.showDetail(item: item, copyright: viewModel.feed?.first?.copyright)
    }
}
