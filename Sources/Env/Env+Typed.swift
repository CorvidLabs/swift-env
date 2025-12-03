import Foundation

// MARK: - Typed Getters

extension Env {
    /**
     Returns the value as an Int.

     - Parameter key: Environment variable name
     - Returns: Parsed Int or nil
     */
    public func int(_ key: String) -> Int? {
        guard let value = values[key] else { return nil }
        return Int(value)
    }

    /**
     Returns the value as an Int with a default.

     - Parameters:
        - key: Environment variable name
        - defaultValue: Value to return if missing or invalid
     - Returns: Parsed Int or default
     */
    public func int(_ key: String, default defaultValue: Int) -> Int {
        int(key) ?? defaultValue
    }

    /**
     Returns the value as a Double.

     - Parameter key: Environment variable name
     - Returns: Parsed Double or nil
     */
    public func double(_ key: String) -> Double? {
        guard let value = values[key] else { return nil }
        return Double(value)
    }

    /**
     Returns the value as a Double with a default.

     - Parameters:
        - key: Environment variable name
        - defaultValue: Value to return if missing or invalid
     - Returns: Parsed Double or default
     */
    public func double(_ key: String, default defaultValue: Double) -> Double {
        double(key) ?? defaultValue
    }

    /**
     Returns the value as a Bool.

     Recognizes: `true`, `false`, `1`, `0`, `yes`, `no`, `on`, `off` (case-insensitive)

     - Parameter key: Environment variable name
     - Returns: Parsed Bool or nil
     */
    public func bool(_ key: String) -> Bool? {
        guard let value = values[key]?.lowercased() else { return nil }

        switch value {
        case "true", "1", "yes", "on":
            return true
        case "false", "0", "no", "off":
            return false
        default:
            return nil
        }
    }

    /**
     Returns the value as a Bool with a default.

     - Parameters:
        - key: Environment variable name
        - defaultValue: Value to return if missing or invalid
     - Returns: Parsed Bool or default
     */
    public func bool(_ key: String, default defaultValue: Bool) -> Bool {
        bool(key) ?? defaultValue
    }

    /**
     Returns the value as a URL.

     - Parameter key: Environment variable name
     - Returns: Parsed URL or nil
     */
    public func url(_ key: String) -> URL? {
        guard let value = values[key] else { return nil }
        return URL(string: value)
    }

    /**
     Returns the value as a URL with a default.

     - Parameters:
        - key: Environment variable name
        - defaultValue: Value to return if missing or invalid
     - Returns: Parsed URL or default
     */
    public func url(_ key: String, default defaultValue: URL) -> URL {
        url(key) ?? defaultValue
    }

    /**
     Returns the value as an array by splitting on a separator.

     - Parameters:
        - key: Environment variable name
        - separator: Separator string (default: ",")
     - Returns: Array of strings or nil if key missing
     */
    public func array(_ key: String, separator: String = ",") -> [String]? {
        guard let value = values[key] else { return nil }
        return value.components(separatedBy: separator)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    /**
     Returns the value as an array with a default.

     - Parameters:
        - key: Environment variable name
        - separator: Separator string
        - defaultValue: Value to return if missing
     - Returns: Array of strings
     */
    public func array(_ key: String, separator: String = ",", default defaultValue: [String]) -> [String] {
        array(key, separator: separator) ?? defaultValue
    }

    /**
     Returns the value as Data (UTF-8 encoded).

     - Parameter key: Environment variable name
     - Returns: UTF-8 data or nil
     */
    public func data(_ key: String) -> Data? {
        values[key]?.data(using: .utf8)
    }

    /**
     Returns the value as Base64-decoded Data.

     - Parameter key: Environment variable name
     - Returns: Decoded data or nil
     */
    public func base64(_ key: String) -> Data? {
        guard let value = values[key] else { return nil }
        return Data(base64Encoded: value)
    }
}

// MARK: - Required (Throwing) Getters

extension Env {
    /**
     Returns the value or throws if missing.

     - Parameter key: Environment variable name
     - Returns: The value
     - Throws: `EnvError.missingRequired` if key is not set
     */
    public func require(_ key: String) throws -> String {
        guard let value = values[key] else {
            throw EnvError.missingRequired(key)
        }
        return value
    }

    /**
     Returns the value as Int or throws if missing/invalid.

     - Parameter key: Environment variable name
     - Returns: Parsed Int
     - Throws: `EnvError.missingRequired` or `EnvError.invalidType`
     */
    public func requireInt(_ key: String) throws -> Int {
        let value = try require(key)
        guard let intValue = Int(value) else {
            throw EnvError.invalidType(key: key, expected: "Int", actual: value)
        }
        return intValue
    }

    /**
     Returns the value as Double or throws if missing/invalid.

     - Parameter key: Environment variable name
     - Returns: Parsed Double
     - Throws: `EnvError.missingRequired` or `EnvError.invalidType`
     */
    public func requireDouble(_ key: String) throws -> Double {
        let value = try require(key)
        guard let doubleValue = Double(value) else {
            throw EnvError.invalidType(key: key, expected: "Double", actual: value)
        }
        return doubleValue
    }

    /**
     Returns the value as Bool or throws if missing/invalid.

     - Parameter key: Environment variable name
     - Returns: Parsed Bool
     - Throws: `EnvError.missingRequired` or `EnvError.invalidType`
     */
    public func requireBool(_ key: String) throws -> Bool {
        let value = try require(key)
        guard let boolValue = bool(key) else {
            throw EnvError.invalidType(key: key, expected: "Bool", actual: value)
        }
        return boolValue
    }

    /**
     Returns the value as URL or throws if missing/invalid.

     - Parameter key: Environment variable name
     - Returns: Parsed URL
     - Throws: `EnvError.missingRequired` or `EnvError.invalidType`
     */
    public func requireURL(_ key: String) throws -> URL {
        let value = try require(key)
        guard let urlValue = URL(string: value) else {
            throw EnvError.invalidType(key: key, expected: "URL", actual: value)
        }
        return urlValue
    }
}
