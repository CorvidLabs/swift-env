---
change: CHG-0002-document-the-existing-swift-env-api-at-complete-specsync-coverage
artifact: docs
---

# Docs

Add one stable `env` canonical companion whose source map includes all five
files under `Sources/Env`. Requirements describe only behavior demonstrated by
the current implementation and native tests: storage and merging, dotenv
parsing, variable interpolation, file loading, typed optional/default access,
throwing required access, and error reporting.

Every parsed public export must appear in the companion's API surface, and
strict SpecSync must report 100% file and LOC coverage. README and public API
documentation remain unchanged because this change documents rather than
alters the existing contract.
