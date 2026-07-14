---
change: CHG-0002-document-the-existing-swift-env-api-at-complete-specsync-coverage
artifact: testing
---

# Testing

| Native Test File | Requirement Evidence |
|------------------|----------------------|
| `Tests/EnvTests/EnvTests.swift` | REQ-env-001 |
| `Tests/EnvTests/EnvParseTests.swift` | REQ-env-002, REQ-env-003 |
| `Tests/EnvTests/EnvLoadTests.swift` | REQ-env-004 |
| `Tests/EnvTests/EnvTypedTests.swift` | REQ-env-005, REQ-env-006, REQ-env-007 |

The configured `fledge lanes run verify` command builds the package and runs all
65 native tests across eight suites. Strict SpecSync separately validates all
five mapped implementation files, every parsed public export, and the 100%
file and LOC coverage threshold. No hosted result is claimed by this artifact.
