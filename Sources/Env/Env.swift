import Foundation

/// Environment variable container with typed access.
///
/// Load environment variables from `.env` files or access the process environment.
///
/// ```swift
/// // Load from .env file
/// let env = try Env.load()
///
/// // Access values
/// let apiKey = env["API_KEY"]
/// let port = env.int("PORT") ?? 8080
/// let debug = env.bool("DEBUG") ?? false
///
/// // Required values
/// let secret = try env.require("SECRET_KEY")
/// ```
public struct Env: Sendable {
    /// The environment variables as a dictionary.
    public let values: [String: String]

    /// Creates an Env from a dictionary.
    ///
    /// - Parameter values: Dictionary of environment variables
    public init(_ values: [String: String] = [:]) {
        self.values = values
    }

    /// Access environment variable by key.
    ///
    /// - Parameter key: Environment variable name
    /// - Returns: Value if present, nil otherwise
    public subscript(key: String) -> String? {
        values[key]
    }

    /// Returns the value for a key, or a default if not present.
    ///
    /// - Parameters:
    ///   - key: Environment variable name
    ///   - defaultValue: Value to return if key is missing
    /// - Returns: The value or default
    public func string(_ key: String, default defaultValue: String) -> String {
        values[key] ?? defaultValue
    }

    /// Checks if a key exists.
    ///
    /// - Parameter key: Environment variable name
    /// - Returns: True if the key exists
    public func has(_ key: String) -> Bool {
        values[key] != nil
    }

    /// All environment variable keys.
    public var keys: [String] {
        Array(values.keys)
    }

    /// Number of environment variables.
    public var count: Int {
        values.count
    }

    /// Whether the environment is empty.
    public var isEmpty: Bool {
        values.isEmpty
    }
}

// MARK: - Process Environment

extension Env {
    /// The current process environment.
    ///
    /// Provides access to `ProcessInfo.processInfo.environment`.
    ///
    /// ```swift
    /// let path = Env.process["PATH"]
    /// ```
    public static var process: Env {
        Env(ProcessInfo.processInfo.environment)
    }
}

// MARK: - Merging

extension Env {
    /// Creates a new Env by merging with another.
    ///
    /// Values from `other` take precedence over existing values.
    ///
    /// - Parameter other: Env to merge with
    /// - Returns: New Env with merged values
    public func merging(with other: Env) -> Env {
        Env(values.merging(other.values) { _, new in new })
    }

    /// Creates a new Env by merging with a dictionary.
    ///
    /// - Parameter other: Dictionary to merge with
    /// - Returns: New Env with merged values
    public func merging(with other: [String: String]) -> Env {
        Env(values.merging(other) { _, new in new })
    }
}

// MARK: - Sequence Conformance

extension Env: Sequence {
    public func makeIterator() -> Dictionary<String, String>.Iterator {
        values.makeIterator()
    }
}

// MARK: - CustomStringConvertible

extension Env: CustomStringConvertible {
    public var description: String {
        "Env(\(values.count) variables)"
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension Env: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self.values = Dictionary(uniqueKeysWithValues: elements)
    }
}
