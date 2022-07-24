import Combine
import Foundation

public typealias HTTPHeaders = [String: String]
public typealias ResultCompletion<Value> = (Result<Value, Error>) -> Void
public let requestTimeoutInterval: TimeInterval = 30

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Enum to map content types
public enum ContentType {
    case json, xml
    case other(code: String)
    
    var value: String {
        switch self {
        case .json: return "application/json"
        case .xml: return "application/xml"
        case .other(let code): return code
        }
    }
}

protocol NetworkClientProtocol {
    func performRequest<T: Codable>(
        _ request: RequestTask,
        completion: @escaping ResultCompletion<T>
    )
}

class NetworkClient {
    static let shared = NetworkClient()
    private let urlSession: URLSession
    private let decoder = JSONDecoder()
  
    init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }
}

extension NetworkClient: NetworkClientProtocol {
    
    func performRequest<T>(
        _ request: RequestTask,
        completion: @escaping ResultCompletion<T>
    ) where T : Codable {

        guard let request = try? request.urlRequest() else {
            return completion(.failure(NetworkError.invalidRequest))
        }

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, let data = data else {
                return completion(.failure(NetworkError.unknownError))
            }

            guard 200..<300 ~= response.statusCode else {
                return completion(.failure(NetworkError.httpError(response.statusCode)))
            }

            if let value = try? self.decoder.decode(T.self, from: data) {
                return completion(.success(value))
            }
            return completion(.failure(NetworkError.decodingError))
        }.resume()
    }
}

