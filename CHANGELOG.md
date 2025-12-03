# Changelog

All notable changes to swift-env will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-03

### Added
- Initial release of swift-env package
- Pure Swift 6 implementation with Sendable conformance
- Load environment variables from `.env` files
- Access process environment variables
- Typed getters: `int()`, `double()`, `bool()`, `url()`, `array()`, `data()`, `base64()`
- Required value validation with throwing accessors: `require()`, `requireInt()`, `requireBool()`, `requireURL()`
- Variable interpolation support (`${VAR}` and `$VAR` syntax)
- Merge multiple `.env` files with override semantics
- Configuration-based loading (`.env.development`, `.env.production`)
- Support for quoted values (single and double quotes)
- Export prefix support (`export VAR=value`)
- Comment support (`# comment`)
- Comprehensive test suite
- Platform support:
  - iOS 16+
  - macOS 13+
  - tvOS 16+
  - watchOS 9+
  - visionOS 1+

[0.1.0]: https://github.com/CorvidLabs/swift-env/releases/tag/0.1.0
