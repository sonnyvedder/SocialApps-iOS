enum AppError: LocalizedError {
    case network(String)
    case authentication(String)
    case validation(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .network(let message):
            return "Network Error: \(message)"
        case .authentication(let message):
            return "Authentication Error: \(message)"
        case .validation(let message):
            return "Validation Error: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}