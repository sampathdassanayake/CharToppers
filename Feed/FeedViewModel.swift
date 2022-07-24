import Foundation
import RealmSwift

class FeedViewModel {
    lazy var feedRepository = FeedRepository()
    var feed: Results<Feed>? {
        feedRepository.feed
    }
    var token: NotificationToken? {
        feedRepository.token
    }
    
    func loadFeedFromAPI(completion: @escaping(Error?) -> Void) {
        feedRepository.loadFeedFromAPI { error in
            completion(error)
        }
    }
}


