---
change: CHG-0003-complete-generated-agent-integration-coverage-and-ignore-library-only-swift-reso
artifact: context
---

# Context

The rollout already installed generated SpecSync integrations for Claude, Cursor, Codex, and Gemini. The original
adoption change did not list those generated directories as affected paths, so strict lifecycle validation could not
associate them with an approved migration. Native Swift package verification also creates an untracked
`Package.resolved`, although this repository is a library and does not version that local resolution output.

This change records the missing governance scope and keeps generated SwiftPM state out of the delivery without
altering package sources, tests, public API, or runtime behavior.
