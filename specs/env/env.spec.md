---
module: env
version: 2
status: stable
files:
  - Sources/Env/Env+Load.swift
  - Sources/Env/Env+Parse.swift
  - Sources/Env/Env+Typed.swift
  - Sources/Env/Env.swift
  - Sources/Env/EnvError.swift
db_tables: []
depends_on: []
---

# Env

## Purpose

`Env` is a synchronous, value-oriented Swift library for reading process environment values and dotenv content. It
provides dictionary-style storage, dotenv parsing and interpolation, file and configuration loading, typed optional and
default accessors, throwing required accessors, merging, iteration, and typed errors.

## Public API

The source-derived inventory covers the public declarations in all five mapped implementation files. Overloads share a
single symbol entry because SpecSync validates exported declaration names rather than signature multiplicity.

| Symbol | Description |
|--------|-------------|
| `Env` | Sendable environment-value container. |
| `values` | Stored key/value dictionary. |
| `init` | Dictionary and dictionary-literal construction. |
| `subscript` | Optional value lookup by key. |
| `string` | String lookup with a caller-provided default. |
| `has` | Key-presence query. |
| `keys` | Stored keys. |
| `count` | Number of stored variables. |
| `isEmpty` | Whether no variables are stored. |
| `process` | Snapshot of the current process environment. |
| `merging` | Non-mutating merge with another `Env` or dictionary, preferring incoming values. |
| `makeIterator` | Sequence iterator over stored pairs. |
| `description` | Count-based human-readable description. |
| `load` | Dotenv loading from a path, URL, contents, or ordered path list. |
| `loadOrProcess` | File loading with process-environment fallback. |
| `loadForConfiguration` | Ordered base/local/configuration dotenv loading. |
| `parse` | Dotenv text parser. |
| `interpolate` | `${VAR}` and `$VAR` expansion. |
| `int` | Optional or defaulted integer access. |
| `double` | Optional or defaulted double access. |
| `bool` | Optional or defaulted boolean access. |
| `url` | Optional or defaulted URL access. |
| `array` | Optional or defaulted separated-list access. |
| `data` | UTF-8 data access. |
| `base64` | Base64-decoded data access. |
| `require` | Required string access. |
| `requireInt` | Required integer access. |
| `requireDouble` | Required double access. |
| `requireBool` | Required boolean access. |
| `requireURL` | Required URL access. |
| `EnvError` | Sendable, localized, equatable failure type. |
| `fileNotFound` | Missing dotenv file failure. |
| `readError` | Dotenv read failure retaining path and underlying error. |
| `missingRequired` | Missing required key failure. |
| `invalidType` | Required conversion failure. |
| `parseError` | Invalid dotenv key failure with line and message. |
| `errorDescription` | Stable localized failure description. |
| `==` | Value comparison for supported `EnvError` cases. |

## Invariants

1. `Env` operations return new values rather than mutating the stored dictionary.
2. Incoming values override existing values during merges and later files override earlier files during ordered loads.
3. Dotenv keys begin with a letter or underscore and continue with letters, digits, or underscores.
4. Interpolation resolves stored values before the optional process-environment fallback and stops after at most ten passes.
5. Optional typed accessors return `nil` for missing or invalid values; default overloads return the supplied default.
6. Required accessors distinguish missing values from invalid conversions with `EnvError`.

## Behavioral Examples

- Parsing `export PORT=8080` produces `PORT` with value `8080`; comments and empty lines are ignored.
- Merging `Env(["A": "1"])` with `["A": "2", "B": "3"]` produces `A=2` and `B=3`.
- Boolean access recognizes true/false, 1/0, yes/no, and on/off without case sensitivity.
- Loading configuration `production` considers `.env`, `.env.local`, `.env.production`, then
  `.env.production.local`, with later values winning.

## Error Cases

| Condition | Behavior |
|-----------|----------|
| A required single file does not exist | `EnvError.fileNotFound`. |
| A URL or path cannot be read as UTF-8 | `EnvError.readError`. |
| A dotenv key is invalid | `EnvError.parseError` with the one-based line number. |
| A required key is absent | `EnvError.missingRequired`. |
| A required typed conversion fails | `EnvError.invalidType`. |
| A file in an ordered optional path list is absent | The file is skipped. |

## Dependencies

Runtime code uses Foundation and the Swift standard library. The Swift DocC package is a documentation plugin and does
not participate in environment loading or parsing.

## Change Log

| Date | Change |
|------|--------|
| 2026-07-13 | Initial complete API documentation for SpecSync 5 governance. |
| 2026-07-14 | CHG-0002-document-the-existing-swift-env-api-at-complete-specsync-coverage: Document the existing Swift Env API at complete SpecSync coverage |
