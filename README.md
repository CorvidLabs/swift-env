# swift-env

[![CI](https://img.shields.io/github/actions/workflow/status/CorvidLabs/swift-env/ci.yml?label=CI&branch=main)](https://github.com/CorvidLabs/swift-env/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/CorvidLabs/swift-env)](https://github.com/CorvidLabs/swift-env/blob/main/LICENSE)
[![Version](https://img.shields.io/github/v/release/CorvidLabs/swift-env)](https://github.com/CorvidLabs/swift-env/releases)

A pure Swift library for loading and accessing environment variables from `.env` files.

## Features

- Load environment variables from `.env` files
- Access the process environment
- Typed getters (Int, Double, Bool, URL, Array)
- Required value validation with throwing accessors
- Variable interpolation (`${VAR}` and `$VAR` syntax)
- Merge multiple `.env` files
- Configuration-based loading (`.env.development`, `.env.production`)

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/0xLeif/swift-env.git", from: "0.1.0")
]
```

## Usage

### Basic Usage

```swift
import Env

// Load from .env file
let env = try Env.load()

// Access values
let apiKey = env["API_KEY"]
let port = env.int("PORT") ?? 8080
let debug = env.bool("DEBUG") ?? false
```

### Process Environment

```swift
// Access process environment directly
let path = Env.process["PATH"]
let home = Env.process["HOME"]
```

### Typed Getters

```swift
let env = try Env.load()

// Integers
let port = env.int("PORT")                    // Int?
let port = env.int("PORT", default: 8080)     // Int

// Doubles
let rate = env.double("RATE")                 // Double?
let rate = env.double("RATE", default: 1.0)   // Double

// Booleans (true/false, 1/0, yes/no, on/off)
let debug = env.bool("DEBUG")                 // Bool?
let debug = env.bool("DEBUG", default: false) // Bool

// URLs
let apiURL = env.url("API_URL")               // URL?

// Arrays (comma-separated)
let hosts = env.array("ALLOWED_HOSTS")        // [String]?
let hosts = env.array("HOSTS", separator: ":") // Custom separator

// Data
let data = env.data("TEXT")                   // Data? (UTF-8)
let decoded = env.base64("ENCODED")           // Data? (Base64 decoded)
```

### Required Values

```swift
let env = try Env.load()

// Throws if missing
let secret = try env.require("SECRET_KEY")

// Throws if missing or invalid type
let port = try env.requireInt("PORT")
let debug = try env.requireBool("DEBUG")
let apiURL = try env.requireURL("API_URL")
```

### Variable Interpolation

```swift
// .env file:
// BASE_URL=https://api.example.com
// FULL_URL=${BASE_URL}/v1

let env = try Env.load()
print(env["FULL_URL"]) // "https://api.example.com/v1"
```

### Multiple Files

```swift
// Load and merge multiple files (later files override)
let env = try Env.load(from: [".env", ".env.local", ".env.production"])
```

### Configuration-Based Loading

```swift
// Loads: .env, .env.local, .env.{config}, .env.{config}.local
let env = try Env.loadForConfiguration("production")
```

### Merging Environments

```swift
let base = Env(["A": "1"])
let overrides: Env = ["A": "2", "B": "3"]

let merged = base.merging(with: overrides)
// A = "2", B = "3"
```

## .env File Format

```bash
# Comments start with #
KEY=value

# Quoted values
MESSAGE="Hello World"
SINGLE='Single quoted'

# Export prefix (optional)
export API_KEY=secret

# Variable interpolation
BASE=${HOME}/app
URL=${API_URL}/endpoint

# Empty values
EMPTY=
```

## License

MIT
