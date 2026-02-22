---
name: Feature Request
about: Suggest a new diagnostic command or improvement
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Summary
<!-- A clear one-line description of the feature you're requesting -->


## Problem or Gap This Solves
<!-- What troubleshooting scenario is currently not covered? Why is this useful? -->
<!-- Example: "There's no way to see if IPv6 is actually functioning, only that it's configured" -->


## Proposed Solution
<!-- Describe what you'd like the tool to do. If you know the specific macOS command(s), please include them. -->

**Suggested command(s):**
```bash
# e.g.
networksetup -getv6prefixlength Wi-Fi
ping6 -c 4 ipv6.google.com
```

**Suggested section:** <!-- Which section should this appear in? e.g. Section 2 - Basic Connectivity -->

**Suggested label for the report:** <!-- What should the section header say in the output file? -->


## Expected Output
<!-- What would the output of this command look like? Paste an example if you have one. -->

```
paste example output here
```

## macOS Version Compatibility
<!-- Does this command work across all supported macOS versions (11+), or only specific versions? -->
<!-- Note any versions where it behaves differently or is unavailable -->

| macOS Version | Works? | Notes |
|---|---|---|
| macOS 11 Big Sur | ✅ / ❌ / Unknown | |
| macOS 12 Monterey | ✅ / ❌ / Unknown | |
| macOS 13 Ventura | ✅ / ❌ / Unknown | |
| macOS 14 Sonoma | ✅ / ❌ / Unknown | |
| macOS 15 Sequoia | ✅ / ❌ / Unknown | |

## Alternatives Considered
<!-- Have you considered any alternative approaches or commands? -->


## Checklist
- [ ] I have searched existing issues and this has not already been requested
- [ ] The suggested command is a built-in macOS tool (no Homebrew or third-party installs required)
- [ ] The suggested command does not collect passwords, Keychain data, or personal files
- [ ] The suggested command does not require root beyond what the script already requests
