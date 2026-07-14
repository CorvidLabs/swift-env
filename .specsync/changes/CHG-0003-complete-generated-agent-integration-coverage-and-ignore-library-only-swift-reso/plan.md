---
change: CHG-0003-complete-generated-agent-integration-coverage-and-ignore-library-only-swift-reso
artifact: plan
---

# Plan

1. Declare all four generated agent integration directories as affected governance paths.
2. Ignore locally generated `Package.resolved` output.
3. Confirm all four integrations remain installed and no source or test files changed.
4. Run strict SpecSync at 100% and the native Fledge verification lane.
5. Record definition and closing approvals only after the completed checks pass.
