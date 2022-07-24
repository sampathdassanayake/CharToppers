import Combine
import Foundation
import RealmSwift
import CloudKit

class FeedRepository {
    var realm: Realm?
    lazy var networkClient: NetworkClient = NetworkClient.shared
    lazy var request: Request = Request(
        method: .get,
        url: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json"
    )
    @ThreadSafe var feed: Results<Feed>?
    var error: Error?
    var token: NotificationToken?
    
    init(networkClient: NetworkClient = NetworkClient.shared) {
        self.networkClient = networkClient
        
        do {
            self.realm = try Realm()
        } catch let error  {
            self.error = error
        }
        feed = self.realm?.objects(Feed.self)
    }
    
    func loadFeedFromAPI(completion: @escaping(Error?) -> Void) {
        self.networkClient.performRequest(request) { (result: Result<FeedResponse, Error>)  in
            switch result{
            case .failure(let error):
                self.error = error
                return completion(error)
            case .success(let response):
                do {
                    self.realm = try Realm()
                    try self.realm?.write {
                        self.realm?.add(response.feed)
                    }
                    return completion(nil)
                } catch let error  {
                    self.error = error
                    return completion(error)
                }
            }
            
        }
    }
}
