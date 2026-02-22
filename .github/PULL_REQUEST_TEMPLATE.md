## Description
<!-- A clear summary of what this PR changes and why -->


## Type of Change
<!-- Check all that apply -->

- [ ] 🐛 Bug fix — fixes an existing issue (link below)
- [ ] ✨ New feature — adds a new diagnostic command or section
- [ ] 🔧 Improvement — refactors or improves existing functionality
- [ ] 📖 Documentation — README, comments, or other docs only
- [ ] 🔒 Security fix — addresses a security concern
- [ ] 🍎 Compatibility fix — addresses a specific macOS version issue

## Related Issue
<!-- Link to the issue this PR addresses, if applicable -->
Closes #

## Changes Made
<!-- List the specific changes. Be precise — "added X command to Section 4", not just "updated script" -->

- 
- 
- 

## Testing Performed
<!-- Describe how you tested this. Be specific about macOS versions and hardware. -->

| Test | Result |
|---|---|
| Script runs end-to-end without errors | ✅ / ❌ |
| WiFi interface auto-detected correctly | ✅ / ❌ |
| WiFi service name auto-detected correctly | ✅ / ❌ |
| Output `.txt` report is complete and readable | ✅ / ❌ |
| `.zip` file is created successfully | ✅ / ❌ |
| airport utility found / fallback handled correctly | ✅ / ❌ / N/A |
| Script handles no WiFi adapter gracefully | ✅ / ❌ |
| sudo prompt works and keepalive functions | ✅ / ❌ |

**macOS version(s) tested:**
**Mac hardware tested (Intel / Apple Silicon / both):**
**Shell tested (`echo $SHELL`):**

## macOS Version Compatibility
<!-- If your change affects specific macOS versions, note them here -->

| macOS Version | Tested | Notes |
|---|---|---|
| macOS 11 Big Sur | ✅ / ❌ / Not tested | |
| macOS 12 Monterey | ✅ / ❌ / Not tested | |
| macOS 13 Ventura | ✅ / ❌ / Not tested | |
| macOS 14 Sonoma | ✅ / ❌ / Not tested | |
| macOS 15 Sequoia | ✅ / ❌ / Not tested | |

## Security Checklist
<!-- Confirm your changes meet the security requirements of this project -->

- [ ] My changes do not collect passwords, PSKs, Keychain data, or personal files
- [ ] My changes do not transmit any data over the network
- [ ] My changes do not modify any system settings or preferences
- [ ] Any new commands used are built-in macOS tools only (no Homebrew or third-party dependencies)
- [ ] sudo is only used where genuinely required, not as a convenience
- [ ] I have reviewed my changes for unintended data exposure

## Additional Notes
<!-- Anything else reviewers should know — known limitations, follow-up work needed, tested on managed/corporate device, etc. -->
