import UIKit

class FeedCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FeedViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showDetail(item: FeedResult, copyright: String?) {
        let child = AlbumCoordinator(navigationController: navigationController)
        child.item = item
        child.copyright = copyright
        childCoordinators.append(child)
        child.start()
//        let vc = AlbumViewController()
//        vc.coordinator = self
//        vc.updateView(item: item)
//        navigationController.pushViewController(vc, animated: false)
    }
}
