---
spec: env.spec.md
---

## Context

Swift applications need a small cross-platform value type for process variables and conventional dotenv files without
introducing a runtime dependency. Env keeps parsing, interpolation, loading, conversion, and required-value failures in
one synchronous API while retaining the original string values.

## Related Modules

- `Package.swift` exposes the single `Env` library product.
- `Tests/EnvTests` provides native evidence for storage, parsing, interpolation, loading, typed access, and failures.

## Design Decisions

- Keep storage immutable and return new values for merging.
- Treat ordered file lists as optional overlays while treating a single requested file as required.
- Keep optional/default and throwing required access patterns separate.
- Limit interpolation passes to ten to terminate cyclic references.
