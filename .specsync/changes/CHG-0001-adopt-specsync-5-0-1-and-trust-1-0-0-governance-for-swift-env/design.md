---
change: CHG-0001-adopt-specsync-5-0-1-and-trust-1-0-0-governance-for-swift-env
artifact: design
---

# Design

Keep all existing workflows unchanged. Add a macOS trust job on each pull
request and main push using full history and immutable Trust v1.0.0. Trust runs
Swift build and tests through Fledge, blocks risk, uses progressive provenance,
and leaves documentation Pages independent.
