import Foundation
import RealmSwift

struct FeedResponse: Codable {
    let feed: Feed
}

// MARK: - Feed
class Feed: Object, Codable {
    @Persisted var title: String
    @Persisted var id: String
    @Persisted var author: Author?
    @Persisted var links: List<Link>
    @Persisted var copyright: String
    @Persisted var country: String
    @Persisted var icon: String
    @Persisted var updated: String
    @Persisted var results: List<FeedResult>
}

// MARK: - Author
class Author: Object, Codable {
    @Persisted var name: String
    @Persisted var url: String
}

// MARK: - Link
class Link: Object, Codable {
    @Persisted var linkSelf: String

    enum CodingKeys: String, CodingKey {
        case linkSelf = "self"
    }
}

// MARK: - Result
class FeedResult: Object, Codable {
    @Persisted var artistName: String
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var releaseDate: String
    @Persisted var kind: String
    @Persisted var artistID: String?
    @Persisted var artistURL: String?
    @Persisted var contentAdvisoryRating: String?
    @Persisted var artworkUrl100: String
    @Persisted var genres: List<Genre>
    @Persisted var url: String

    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case contentAdvisoryRating, artworkUrl100, genres, url
    }
}

// MARK: - Genre
class Genre: Object, Codable {
    @Persisted var genreID: String
    @Persisted var  name: String
    @Persisted var url: String

    enum CodingKeys: String, CodingKey {
        case genreID = "genreId"
        case name, url
    }
}
