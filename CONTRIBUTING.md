# Contributing to macOS WiFi Diagnostics Tool

Thank you for taking the time to contribute! Whether you're fixing a bug, suggesting an improvement, or adding a new diagnostic command — all contributions are welcome and appreciated.

Please take a moment to read these guidelines before getting started.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Ways to Contribute](#ways-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Coding Guidelines](#coding-guidelines)
- [Commit Message Style](#commit-message-style)
- [Testing Across macOS Versions](#testing-across-macos-versions)

---

## Code of Conduct

This project follows a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold it. Please report unacceptable behaviour through GitHub.

---

## Ways to Contribute

You don't have to write code to contribute. Here are some ways to help:

- 🐛 **Report a bug** — something not working as expected on your Mac
- 💡 **Suggest a feature** — a new diagnostic command or output improvement
- 📖 **Improve documentation** — fix typos, clarify instructions, improve the README
- 🧪 **Test on different hardware** — try it on different Mac models, macOS versions, or with different WiFi adapters (including USB and Thunderbolt adapters) and report your findings
- 🔍 **Review pull requests** — provide feedback on open PRs

---

## Reporting Bugs

Before submitting a bug report, please:

1. Check the [existing issues](../../issues) to see if it has already been reported
2. Make sure you ran `chmod +x wifi_diagnostics.sh` before executing the script
3. Note whether you accepted the `sudo` password prompt — some commands require it
4. Confirm your macOS version with `sw_vers` in Terminal

When opening a bug report, please include:

- Your macOS version (e.g. macOS 14.4 Sonoma)
- Your Mac model (e.g. MacBook Pro M3, 2024)
- Your shell (`echo $SHELL` in Terminal)
- What you expected to happen
- What actually happened, including any error messages shown in Terminal
- Whether you have a WiFi adapter present and enabled
- Whether the `airport` utility was found or skipped

> **Please do not include your WiFi report output files in public issues** — they may contain your network names, IP addresses, MAC addresses, or other sensitive information.

---

## Suggesting Enhancements

Open a GitHub issue with the label `enhancement` and describe:

- What the new diagnostic command or feature would do
- Why it would be useful for troubleshooting
- The specific macOS command(s) you have in mind
- Any macOS version compatibility considerations

---

## Submitting a Pull Request

1. **Fork** the repository and create a new branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the coding guidelines below

3. **Test your changes** by running the full script on a Mac and verifying:
   - The script runs from end to end without errors
   - WiFi interface is auto-detected correctly
   - All sections appear in the output `.txt` file
   - The `.zip` file is created and can be opened
   - The script handles machines with no WiFi adapter gracefully
   - The script handles `sudo` rejection gracefully

4. **Commit your changes** with a clear commit message (see style guide below)

5. **Open a Pull Request** against the `main` branch with:
   - A clear title and description of what you changed and why
   - The macOS version(s) you tested on
   - Reference to any related issue (e.g. `Closes #12`)

---

## Coding Guidelines

Since this project is a Bash shell script, please follow these conventions:

**General**
- Target **Bash**, not Zsh — macOS ships Bash as a compatibility shell and it is the most portable choice for scripts
- Use `#!/bin/bash` as the shebang — never `/bin/sh` as some commands used are Bash-specific
- Always quote variables: `"$VAR"` not `$VAR` — prevents word splitting on paths with spaces
- Use `local` for variables inside functions

**Interface detection**
- Never hardcode `en0` — always auto-detect the WiFi interface via `networksetup -listallhardwareports` with a fallback
- If a command requires a specific interface, pass `$WIFI_IF` as a variable

**Commands**
- Always add time/count limits to commands that could hang: `-c 4` for ping, `-m 30` for traceroute
- Use `2>&1` to capture stderr alongside stdout so errors appear in the report
- Wrap optional commands (like `airport`) in an existence check before running
- Add inline comments for any non-obvious behaviour (e.g. MTU test explanations)

**sudo**
- Request `sudo -v` once at the start rather than per-command where possible
- Use the keepalive loop pattern (`sudo -n true` in background) to avoid repeated prompts
- Only use `sudo` where genuinely required — never elevate unnecessarily

**Output**
- Always add a descriptive label when calling `run_and_log` — it becomes the section header in the report
- Keep section comments in the script aligned with the label used in `run_and_log`
- Do not collect passwords, WiFi PSKs, personal files, or browser data under any circumstances

**Compatibility**
- Test on both Intel and Apple Silicon Macs where possible
- Note any commands that behave differently across macOS versions in a code comment

---

## Commit Message Style

Use short, clear commit messages in the imperative mood:

```
Add dig output alongside nslookup for richer DNS info
Fix airport path detection on macOS 15 Sequoia
Skip ndp gracefully when not available on older macOS
Update README with airport field explanations
Add IPv6 connectivity test via ping6
```

Avoid vague messages like `fix stuff`, `update`, or `changes`.

---

## Testing Across macOS Versions

If you have access to multiple macOS versions, testing on the following is especially appreciated:

| Version | Name | Notes |
|---|---|---|
| macOS 11 | Big Sur | Minimum supported version |
| macOS 12 | Monterey | |
| macOS 13 | Ventura | `airport` path may differ |
| macOS 14 | Sonoma | |
| macOS 15 | Sequoia | Latest — `airport` deprecation changes |

Please note your macOS version in your PR or bug report.

---

Thank you for helping make this tool better! 🙏
