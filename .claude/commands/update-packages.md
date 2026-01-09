---
description: Check PyPI and update maid-runner and maid-lsp packages
allowed-tools: Bash(curl:*), Bash(jq:*), Read, Edit, Bash(git:*)
argument-hint: [--dry-run]
---

# Update MAID Packages from PyPI

This command checks PyPI for the latest versions of maid-runner and maid-lsp packages, updates the marketplace.json file with new versions, commits the changes, and pushes to the repository.

## Current versions

- Check current versions: !`cat .claude-plugin/marketplace.json | jq -r '.plugins[] | select(.name == "maid-runner" or .name == "maid-lsp") | "\(.name): \(.version)"'`

## Your task

1. **Check PyPI for latest versions:**
   - Fetch latest version of maid-runner: `curl -s https://pypi.org/pypi/maid-runner/json | jq -r '.info.version'`
   - Fetch latest version of maid-lsp: `curl -s https://pypi.org/pypi/maid-lsp/json | jq -r '.info.version'`

2. **Compare versions:**
   - Compare the fetched versions with the current versions in marketplace.json
   - If versions differ, proceed with updates. If they're the same, report "All packages are up to date"

3. **Update marketplace.json:**
   - Read the current `.claude-plugin/marketplace.json` file
   - Update the `version` field for both `maid-runner` and `maid-lsp` plugins with the latest PyPI versions
   - If the argument `--dry-run` is provided as `$ARGUMENTS`, only show what would be updated without making changes

4. **Sync plugin version (for maid-runner only):**
   - Also update `plugins/maid-runner/plugin.json` to match the new maid-runner version from PyPI
   - This keeps the local plugin version in sync with the PyPI package version

5. **Commit and push changes:**
   - Stage the changes: `git add .claude-plugin/marketplace.json plugins/maid-runner/plugin.json`
   - Create a commit with message: "chore: update maid-runner to vX.X.X and maid-lsp to vX.X.X"
   - Push to the repository: `git push origin main`
   - Skip commit and push if `--dry-run` is specified

## Success criteria

- Both packages are checked against PyPI
- If updates are available, marketplace.json is updated
- Changes are committed and pushed (unless --dry-run)
- Clear summary of what was updated is provided

## Example output format

```
Checking PyPI for updates...
✓ maid-runner: 0.7.0 → 0.8.0 (update available)
✓ maid-lsp: 0.1.2 → 0.1.3 (update available)

Updating marketplace.json...
Updating plugins/maid-runner/plugin.json...
Committing changes...
Pushing to repository...

✓ Successfully updated packages!
```
