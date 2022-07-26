import Foundation

/// Enum to map different network erro states.
public enum NetworkError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
    case apiError(_ error: String)
}

public extension NetworkError {
    /// Parses a HTTP StatusCode and returns a NetworkError enum
    /// - Parameters:
    ///     - statusCode: HTTP status code
    /// - Returns: Mapped NetworkError enum
    static func httpError(
        _ statusCode: Int
    ) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return NetworkError enum case
    /// - Parameters:
    ///     - error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
    static func handleError(
        _ error: Error
    ) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkError:
            return error
            
        default:
            return .unknownError
        }
    }
}
