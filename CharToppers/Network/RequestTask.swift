import Foundation

/// Public interface for a Requesttask that is fired through a URlSession
public protocol RequestTask {
    var method: HTTPMethod { get }
    var contentType: ContentType { get }
    var body: Data? { get }
    var headers: HTTPHeaders? { get }
    var requestUrl: URL? { get }
}

extension RequestTask {
    /// Creates a new URLRequest f
    /// stored in this request
    /// - Parameters:
    ///     - cachePolicy: URLRequest.CachePolicy,  Default: ReturnCacheDataElseLoad
    ///     - timeout: TimeInterval. defaulted to reloadIgnoringLocalAndRemoteCacheData
    func urlRequest(
        cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData,
        timeout: TimeInterval = requestTimeoutInterval
    ) throws -> URLRequest {
        guard let url = requestUrl else {
            throw NetworkError.invalidRequest
        }
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        urlRequest.httpMethod = method.rawValue
        if let body = body {
            urlRequest.httpBody = body
        }
        if let headers = self.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        return urlRequest
    }
}

struct Request: RequestTask {
    let method: HTTPMethod
    var contentType: ContentType = .json
    let body: Data?
    var headers: HTTPHeaders? = nil
    let requestUrl: URL?
    
    init(
        method: HTTPMethod,
        url: String,
        contentType: ContentType = .json,
        queryParameters: [URLQueryItem]? = nil,
        body: Data? = nil,
        headers: HTTPHeaders? = nil
        
    ) {
        if let url = URL(string: url),
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
           
        {
            self.method = method
            self.body = body
            self.contentType = contentType
            self.headers = headers
            components.queryItems = queryParameters
            
            //Construct the URL
            requestUrl = components.url
            
        } else {
            fatalError()
            
        }
        
    }
    
}

