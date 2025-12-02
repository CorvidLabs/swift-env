import Foundation

// MARK: - Loading from Files

extension Env {
    /// Loads environment variables from a `.env` file.
    ///
    /// By default, looks for `.env` in the current working directory.
    ///
    /// ```swift
    /// let env = try Env.load()
    /// let env = try Env.load(from: ".env.production")
    /// ```
    ///
    /// - Parameters:
    ///   - path: Path to the .env file (default: ".env")
    ///   - interpolate: Whether to expand variable references (default: true)
    ///   - mergeWithProcess: Whether to include process environment (default: false)
    /// - Returns: Loaded environment
    /// - Throws: `EnvError` if loading fails
    public static func load(
        from path: String = ".env",
        interpolate: Bool = true,
        mergeWithProcess: Bool = false
    ) throws -> Env {
        let fileManager = FileManager.default

        // Resolve path relative to current directory
        let resolvedPath: String
        if path.hasPrefix("/") || path.hasPrefix("~") {
            resolvedPath = (path as NSString).expandingTildeInPath
        } else {
            resolvedPath = fileManager.currentDirectoryPath + "/" + path
        }

        guard fileManager.fileExists(atPath: resolvedPath) else {
            throw EnvError.fileNotFound(path)
        }

        return try load(contentsOfFile: resolvedPath, interpolate: interpolate, mergeWithProcess: mergeWithProcess)
    }

    /// Loads environment from a file URL.
    ///
    /// - Parameters:
    ///   - url: URL to the .env file
    ///   - interpolate: Whether to expand variable references
    ///   - mergeWithProcess: Whether to include process environment
    /// - Returns: Loaded environment
    public static func load(
        contentsOf url: URL,
        interpolate: Bool = true,
        mergeWithProcess: Bool = false
    ) throws -> Env {
        let contents: String
        do {
            contents = try String(contentsOf: url, encoding: .utf8)
        } catch {
            throw EnvError.readError(url.path, error)
        }

        return try load(contents: contents, interpolate: interpolate, mergeWithProcess: mergeWithProcess)
    }

    /// Loads environment from a file path.
    private static func load(
        contentsOfFile path: String,
        interpolate: Bool,
        mergeWithProcess: Bool
    ) throws -> Env {
        let contents: String
        do {
            contents = try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            throw EnvError.readError(path, error)
        }

        return try load(contents: contents, interpolate: interpolate, mergeWithProcess: mergeWithProcess)
    }

    /// Loads environment from string contents.
    ///
    /// - Parameters:
    ///   - contents: The .env file contents
    ///   - interpolate: Whether to expand variable references
    ///   - mergeWithProcess: Whether to include process environment
    /// - Returns: Loaded environment
    public static func load(
        contents: String,
        interpolate shouldInterpolate: Bool = true,
        mergeWithProcess: Bool = false
    ) throws -> Env {
        var values = try parse(contents)

        if shouldInterpolate {
            values = Self.interpolate(values, withProcessEnv: true)
        }

        if mergeWithProcess {
            let processEnv = ProcessInfo.processInfo.environment
            values = processEnv.merging(values) { _, new in new }
        }

        return Env(values)
    }

    /// Loads and merges multiple .env files.
    ///
    /// Files are loaded in order; later files override earlier ones.
    ///
    /// ```swift
    /// let env = try Env.load(from: [".env", ".env.local", ".env.production"])
    /// ```
    ///
    /// - Parameters:
    ///   - paths: Paths to .env files
    ///   - interpolate: Whether to expand variable references
    ///   - mergeWithProcess: Whether to include process environment
    /// - Returns: Merged environment
    public static func load(
        from paths: [String],
        interpolate: Bool = true,
        mergeWithProcess: Bool = false
    ) throws -> Env {
        var merged: [String: String] = [:]

        if mergeWithProcess {
            merged = ProcessInfo.processInfo.environment
        }

        for path in paths {
            // Skip missing files silently
            let fileManager = FileManager.default
            let resolvedPath: String
            if path.hasPrefix("/") || path.hasPrefix("~") {
                resolvedPath = (path as NSString).expandingTildeInPath
            } else {
                resolvedPath = fileManager.currentDirectoryPath + "/" + path
            }

            guard fileManager.fileExists(atPath: resolvedPath) else {
                continue
            }

            let contents = try String(contentsOfFile: resolvedPath, encoding: .utf8)
            let parsed = try parse(contents)
            merged.merge(parsed) { _, new in new }
        }

        if interpolate {
            merged = Self.interpolate(merged, withProcessEnv: true)
        }

        return Env(merged)
    }
}

// MARK: - Convenience Loaders

extension Env {
    /// Loads `.env` file if it exists, otherwise returns process environment.
    ///
    /// ```swift
    /// let env = Env.loadOrProcess()
    /// ```
    public static func loadOrProcess(from path: String = ".env") -> Env {
        do {
            return try load(from: path, mergeWithProcess: true)
        } catch {
            return process
        }
    }

    /// Loads environment for the current build configuration.
    ///
    /// Looks for files in order:
    /// 1. `.env`
    /// 2. `.env.local`
    /// 3. `.env.{configuration}` (e.g., `.env.debug` or `.env.release`)
    /// 4. `.env.{configuration}.local`
    ///
    /// - Parameter configuration: Build configuration name
    /// - Returns: Merged environment
    public static func loadForConfiguration(_ configuration: String) throws -> Env {
        let paths = [
            ".env",
            ".env.local",
            ".env.\(configuration.lowercased())",
            ".env.\(configuration.lowercased()).local"
        ]
        return try load(from: paths, mergeWithProcess: true)
    }
}
