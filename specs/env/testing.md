---
spec: env.spec.md
---

## Automated Testing

| Test File | Requirements | What It Covers |
|-----------|--------------|----------------|
| `EnvTests.swift` | REQ-env-001 | Construction, subscript/default access, key metadata, sequence, description, process access, and merging. |
| `EnvParseTests.swift` | REQ-env-002, REQ-env-003 | Assignments, exports, quotes, escapes, comments, invalid keys, duplicate keys, and nested/process interpolation. |
| `EnvLoadTests.swift` | REQ-env-004 | Raw contents, interpolation choice, process merge, missing files, ordered overlays, and fallback loading. |
| `EnvTypedTests.swift` | REQ-env-005, REQ-env-006, REQ-env-007 | Optional/default conversions, Boolean forms, arrays, data, Base64, required values, and typed failures. |

## Manual Testing

No interactive flow exists. Run the Fledge `verify` lane, strict SpecSync at 100%, and Trust from a clean checkout.

## Edge Cases & Boundary Conditions

| Scenario | Expected Behavior |
|----------|-------------------|
| Empty dotenv content | Empty Env. |
| Missing single requested file | `EnvError.fileNotFound`. |
| Missing path in an ordered overlay list | File skipped. |
| Duplicate keys or overlay values | Later value wins. |
| Invalid typed optional value | Nil or caller default. |
| Invalid typed required value | `EnvError.invalidType`. |
| Cyclic interpolation | Processing stops after ten passes. |
