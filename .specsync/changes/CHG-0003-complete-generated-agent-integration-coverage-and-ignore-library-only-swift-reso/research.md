---
change: CHG-0003-complete-generated-agent-integration-coverage-and-ignore-library-only-swift-reso
artifact: research
---

# Research

Inspection confirmed that SpecSync installed files under `.claude/`, `.cursor/`, `.codex/`, and `.gemini/`.
The strict lifecycle gate reported those paths as uncovered because the earlier change definition omitted them.

Running the existing Swift build and test lane creates `Package.resolved` for the documentation plugin dependency.
The file is not part of the existing branch delivery and is local resolution state for this library, so ignoring it
prevents verification from introducing an unrelated artifact.
