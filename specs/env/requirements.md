---
spec: env.spec.md
---

# Requirements

### REQ-env-001

Env SHALL provide immutable dictionary-style storage, lookup, key metadata, iteration, description, process access, and
non-mutating merge operations where incoming values take precedence.

Acceptance Criteria
- Missing subscript keys return nil and defaulted string lookup returns the supplied default.
- Merging an Env or dictionary preserves unique existing values and replaces duplicate keys with incoming values.

### REQ-env-002

The dotenv parser SHALL accept assignments, optional `export` prefixes, quoted and unquoted values, comments, empty
values, supported escapes, and valid environment variable keys.

Acceptance Criteria
- Empty lines and full-line comments are ignored, and later duplicate assignments replace earlier values.
- Invalid keys return `EnvError.parseError` with the one-based source line.

### REQ-env-003

Interpolation SHALL expand `${VAR}` and `$VAR` references from parsed values with optional process-environment fallback.

Acceptance Criteria
- Stored values take precedence over process values and missing references expand to an empty string.
- Nested references are processed for at most ten passes so cycles terminate deterministically.

### REQ-env-004

Env SHALL load dotenv data from a path, URL, raw contents, ordered paths, or conventional build-configuration paths.

Acceptance Criteria
- A required missing file throws `fileNotFound`, while missing files in an ordered optional list are skipped.
- Later files override earlier files, and requested process values are merged without overriding parsed file values.

### REQ-env-005

Typed accessors SHALL provide optional and defaulted Int, Double, Bool, URL, and separated-array conversion plus UTF-8
and Base64 data conversion.

Acceptance Criteria
- Optional accessors return nil for missing or invalid values, and default overloads return the caller's default.
- Boolean parsing is case-insensitive for true/false, 1/0, yes/no, and on/off.

### REQ-env-006

Required accessors SHALL return present String, Int, Double, Bool, and URL values or throw a typed EnvError.

Acceptance Criteria
- Missing required keys throw `missingRequired`.
- Present values that cannot be converted throw `invalidType` with the key, expected type, and actual value.

### REQ-env-007

EnvError SHALL expose localized descriptions and deterministic equality for file-not-found, missing-required,
invalid-type, and parse failures.

Acceptance Criteria
- Each error case produces a description containing its relevant path, key, expected/actual value, or line/message.
- Read errors retain the underlying error and are not treated as equal solely by their path.

## Constraints

- Public operations are synchronous and `Env` plus `EnvError` follow the implementation's Sendable contract.
- File decoding is UTF-8 and process access uses Foundation `ProcessInfo`.
- Runtime code has no third-party package dependency.

## Out of Scope

- Mutating the process environment, secret storage, schema generation, remote configuration, and behavior changes in
  this documentation-only migration.
