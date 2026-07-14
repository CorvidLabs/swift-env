---
change: CHG-0003-complete-generated-agent-integration-coverage-and-ignore-library-only-swift-reso
artifact: testing
---

# Testing

## Automated Verification

- `specsync agents status` reports Claude, Cursor, Codex, and Gemini installed.
- `specsync check --strict --require-coverage 100 --force` validates the complete lifecycle and canonical coverage.
- `fledge lanes run verify` builds the Swift package and runs all native tests.
- `fledge trust doctor` validates the Trust configuration.

## Delivery Assertions

- `git diff --check` reports no whitespace errors.
- The pull-request diff contains no changes under `Sources/` or `Tests/`.
- `Package.resolved` remains absent from the versioned delivery after native verification.
