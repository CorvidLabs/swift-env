---
change: CHG-0003-complete-generated-agent-integration-coverage-and-ignore-library-only-swift-reso
artifact: design
---

# Design

Use one no-spec-change migration to cover the four generated agent integration directories and the repository
`.gitignore`. Preserve the integration files exactly as installed by SpecSync 5.0.1. Add `Package.resolved` to
`.gitignore` so local build and verification runs remain deterministic for this library repository.

Canonical Env requirements remain unchanged because neither adjustment changes exported symbols or behavior.
