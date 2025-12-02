import Foundation

// MARK: - Dotenv Parser

extension Env {
    /// Parses dotenv format text into a dictionary.
    ///
    /// Supports:
    /// - `KEY=value`
    /// - `export KEY=value`
    /// - `# comments`
    /// - `KEY="quoted value"` or `KEY='quoted value'`
    /// - Empty lines
    ///
    /// - Parameter contents: The .env file contents
    /// - Returns: Dictionary of parsed key-value pairs
    /// - Throws: `EnvError.parseError` for malformed lines
    public static func parse(_ contents: String) throws -> [String: String] {
        var result: [String: String] = [:]
        let lines = contents.components(separatedBy: .newlines)

        for (index, line) in lines.enumerated() {
            let lineNumber = index + 1
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Skip empty lines and comments
            if trimmed.isEmpty || trimmed.hasPrefix("#") {
                continue
            }

            // Parse the line
            if let (key, value) = try parseLine(trimmed, lineNumber: lineNumber) {
                result[key] = value
            }
        }

        return result
    }

    /// Parses a single line of dotenv format.
    private static func parseLine(_ line: String, lineNumber: Int) throws -> (String, String)? {
        var remaining = line[...]

        // Handle 'export ' prefix
        if remaining.hasPrefix("export ") {
            remaining = remaining.dropFirst(7)
            remaining = remaining.drop(while: { $0.isWhitespace })
        }

        // Find the = sign
        guard let equalsIndex = remaining.firstIndex(of: "=") else {
            // No equals sign, skip silently (or could throw)
            return nil
        }

        let key = String(remaining[..<equalsIndex]).trimmingCharacters(in: .whitespaces)

        // Validate key
        guard isValidKey(key) else {
            throw EnvError.parseError(line: lineNumber, message: "Invalid key: '\(key)'")
        }

        // Get value part
        let valueStart = remaining.index(after: equalsIndex)
        if valueStart < remaining.endIndex {
            remaining = remaining[valueStart...]
        } else {
            remaining = ""[...]
        }

        let value = parseValue(String(remaining))

        return (key, value)
    }

    /// Validates an environment variable key.
    private static func isValidKey(_ key: String) -> Bool {
        guard !key.isEmpty else { return false }

        // First character must be letter or underscore
        guard let first = key.first, first.isLetter || first == "_" else {
            return false
        }

        // Rest can be letters, digits, or underscores
        return key.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    /// Parses a value, handling quotes and escapes.
    private static func parseValue(_ raw: String) -> String {
        var value = raw.trimmingCharacters(in: .whitespaces)

        // Handle quoted strings
        if (value.hasPrefix("\"") && value.hasSuffix("\"")) ||
           (value.hasPrefix("'") && value.hasSuffix("'")) {
            if value.count >= 2 {
                value = String(value.dropFirst().dropLast())
            }
        } else {
            // Unquoted: remove inline comments
            if let commentIndex = value.firstIndex(of: "#") {
                // Make sure it's not escaped or in quotes
                let beforeComment = value[..<commentIndex]
                value = String(beforeComment).trimmingCharacters(in: .whitespaces)
            }
        }

        // Handle escape sequences in double-quoted strings
        value = value
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\t", with: "\t")
            .replacingOccurrences(of: "\\r", with: "\r")
            .replacingOccurrences(of: "\\\"", with: "\"")
            .replacingOccurrences(of: "\\'", with: "'")
            .replacingOccurrences(of: "\\\\", with: "\\")

        return value
    }
}

// MARK: - Variable Interpolation

extension Env {
    /// Expands variable references in values.
    ///
    /// Supports `${VAR}` and `$VAR` syntax.
    ///
    /// - Parameters:
    ///   - values: Dictionary with potential variable references
    ///   - processEnv: Whether to also look up in process environment
    /// - Returns: Dictionary with expanded values
    public static func interpolate(
        _ values: [String: String],
        withProcessEnv processEnv: Bool = true
    ) -> [String: String] {
        var result = values
        let envLookup = processEnv ? ProcessInfo.processInfo.environment : [:]

        // Multiple passes to handle nested references
        for _ in 0..<10 {
            var changed = false

            for (key, value) in result {
                let expanded = expandVariables(in: value, using: result, fallback: envLookup)
                if expanded != value {
                    result[key] = expanded
                    changed = true
                }
            }

            if !changed { break }
        }

        return result
    }

    /// Expands variable references in a single value.
    private static func expandVariables(
        in value: String,
        using values: [String: String],
        fallback: [String: String]
    ) -> String {
        var result = value

        // Match ${VAR} pattern
        let bracePattern = #"\$\{([A-Za-z_][A-Za-z0-9_]*)\}"#
        if let regex = try? NSRegularExpression(pattern: bracePattern) {
            let range = NSRange(result.startIndex..., in: result)
            let matches = regex.matches(in: result, range: range).reversed()

            for match in matches {
                guard let varRange = Range(match.range(at: 1), in: result) else { continue }
                let varName = String(result[varRange])
                let replacement = values[varName] ?? fallback[varName] ?? ""

                if let fullRange = Range(match.range, in: result) {
                    result.replaceSubrange(fullRange, with: replacement)
                }
            }
        }

        // Match $VAR pattern (not followed by {)
        let simplePattern = #"\$([A-Za-z_][A-Za-z0-9_]*)(?![{])"#
        if let regex = try? NSRegularExpression(pattern: simplePattern) {
            let range = NSRange(result.startIndex..., in: result)
            let matches = regex.matches(in: result, range: range).reversed()

            for match in matches {
                guard let varRange = Range(match.range(at: 1), in: result) else { continue }
                let varName = String(result[varRange])
                let replacement = values[varName] ?? fallback[varName] ?? ""

                if let fullRange = Range(match.range, in: result) {
                    result.replaceSubrange(fullRange, with: replacement)
                }
            }
        }

        return result
    }
}
