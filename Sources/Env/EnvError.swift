import Foundation

/// Errors that can occur when loading or accessing environment variables.
public enum EnvError: Error, Sendable {
    /// The specified file was not found.
    case fileNotFound(String)
    /// Failed to read the file contents.
    case readError(String, Error)
    /// A required environment variable is missing.
    case missingRequired(String)
    /// Failed to convert value to expected type.
    case invalidType(key: String, expected: String, actual: String)
    /// Parse error in the .env file.
    case parseError(line: Int, message: String)
}

// MARK: - LocalizedError

extension EnvError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "Environment file not found: \(path)"
        case .readError(let path, let error):
            return "Failed to read environment file '\(path)': \(error.localizedDescription)"
        case .missingRequired(let key):
            return "Required environment variable '\(key)' is not set"
        case .invalidType(let key, let expected, let actual):
            return "Environment variable '\(key)' has invalid type: expected \(expected), got '\(actual)'"
        case .parseError(let line, let message):
            return "Parse error on line \(line): \(message)"
        }
    }
}

// MARK: - Equatable

extension EnvError: Equatable {
    public static func == (lhs: EnvError, rhs: EnvError) -> Bool {
        switch (lhs, rhs) {
        case (.fileNotFound(let a), .fileNotFound(let b)):
            return a == b
        case (.missingRequired(let a), .missingRequired(let b)):
            return a == b
        case (.invalidType(let k1, let e1, let a1), .invalidType(let k2, let e2, let a2)):
            return k1 == k2 && e1 == e2 && a1 == a2
        case (.parseError(let l1, let m1), .parseError(let l2, let m2)):
            return l1 == l2 && m1 == m2
        default:
            return false
        }
    }
}
