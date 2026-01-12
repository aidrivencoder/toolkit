# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **aidrivencoder** Claude Code plugin marketplace - a curated collection of professional AI development tools and MCP (Model Context Protocol) servers. The repository serves as a centralized distribution point for plugins that enhance Claude Code workflows with validation frameworks, file search capabilities, and voice integration.

**Owner**: AI-Driven Coder (Mamerto Fabian, Codefrost)
**License**: MIT
**Homepage**: https://aidrivencoder.com

## Repository Structure

```
.
├── .claude-plugin/
│   └── marketplace.json        # Marketplace registry (4 plugins)
├── plugins/
│   └── maid-runner/            # Primary local plugin (v0.7.0)
│       ├── plugin.json         # Plugin metadata
│       ├── hooks/hooks.json    # SessionStart auto-installer
│       ├── commands/           # 13 MAID slash commands
│       ├── agents/             # 7 specialized MAID sub-agents
│       ├── skills/             # On-demand MAID methodology skill
│       ├── scripts/            # install_maid_runner.sh
│       └── docs/               # MAID specs and testing rules
└── README.md                   # User-facing documentation
```

## Architecture Patterns

### 1. Hybrid Local/Remote Plugin Distribution

The marketplace uses a hub-and-spoke model where plugins can be either:
- **Local**: Fully contained in `plugins/` directory (e.g., `maid-runner`)
- **Remote**: Referenced via GitHub repos in `marketplace.json` (e.g., `maid-runner-mcp`, `everything-search`, `elevenlabs`)

This hybrid approach allows:
- Local plugins to be rapidly customized and tested
- Remote plugins to have independent release cycles
- Different maintenance models for different plugins

### 2. Plugin Auto-Installation Pattern (MAID Runner)

The `maid-runner` plugin implements automatic dependency installation using:

**SessionStart Hook** (`hooks/hooks.json`):
- Triggers on every session start
- Executes `scripts/install_maid_runner.sh`
- 30-second timeout

**Installation Script** (`scripts/install_maid_runner.sh`):
- Checks for `uv` package manager (hard requirement)
- Creates `.venv` if missing (prevents system package conflicts)
- Idempotent: silently succeeds if `maid-runner` already installed
- Installs `maid-runner` PyPI package via `uv pip install`

**Key Variables**:
- `${CLAUDE_PLUGIN_ROOT}`: Resolves to plugin installation directory

### 3. Command-as-Markdown Pattern

All 13 MAID commands follow a consistent structure:

**File Format** (`commands/*.md`):
```markdown
---
description: Brief command description
argument-hint: [what user should provide]
---

Command instructions with $ARGUMENTS placeholder

## Quick Method: Use CLI
[Recommended CLI command]

## Alternative: Use Subagent
[When to use specialized agent instead]
```

**Command Namespace**: `/maid-runner:command-name` (auto-prefixed by plugin system)

### 4. Agent Specialization Pattern

Seven agents map to MAID workflow phases:

**Agent File Format** (`agents/*.md`):
```markdown
---
name: agent-name
description: What this agent does
tools: Read, Write, Edit, Bash, Grep, Glob
model: inherit
---

# Phase X: Agent Purpose

[Detailed instructions for agent]
```

**Phase Mapping**:
- **Phase 1**: `maid-manifest-architect` (manifest creation)
- **Phase 2 Gate**: `maid-plan-reviewer` (manifest + test validation)
- **Phase 2**: `maid-test-designer` (behavioral test creation)
- **Phase 3**: `maid-developer` (TDD implementation)
- **Phase 3 Support**: `maid-fixer` (error resolution)
- **Phase 3.5**: `maid-refactorer` (quality improvements)
- **Cross-cutting**: `maid-auditor` (compliance enforcement)

### 5. On-Demand Skill System

MAID methodology documentation is implemented as a **Skill** (not always-active):

**Location**: `skills/maid-methodology/SKILL.md`

**Activation Triggers**:
- User mentions "MAID", "manifest", or related keywords
- User runs any `/maid-*` command
- User asks about MAID methodology

**Benefits**:
- Reduces context overhead during non-MAID sessions
- Loads full v1.3 specification only when needed
- Includes progressive disclosure to reference docs

## Marketplace Configuration

### marketplace.json Structure

The marketplace registry defines 4 plugins:

1. **maid-runner** (v0.7.0) - Local source: `./plugins/maid-runner`
2. **maid-runner-mcp** (v0.1.0) - GitHub: `mamertofabian/maid-runner-mcp`
3. **everything-search** (latest) - GitHub: `mamertofabian/mcp-everything-search`
4. **elevenlabs** (latest) - GitHub: `mamertofabian/elevenlabs-mcp-server`

### Installation Commands

Users install via:
```bash
# Add marketplace
/plugin marketplace add aidrivencoder/toolkit

# Install individual plugins
/plugin install maid-runner@aidrivencoder
/plugin install everything-search@aidrivencoder
```

## Development Workflow

### Modifying the MAID Runner Plugin

1. **Edit plugin files** in `plugins/maid-runner/`:
   - Commands: `commands/*.md`
   - Agents: `agents/*.md`
   - Hooks: `hooks/hooks.json`
   - Skills: `skills/maid-methodology/SKILL.md`

2. **Update version** in `plugins/maid-runner/plugin.json`

3. **Test locally**:
   ```bash
   claude --plugin-dir ./plugins/maid-runner
   ```

4. **Commit and push** to GitHub (marketplace users will get updates)

### Adding New Plugins to Marketplace

1. **Create plugin** (either local or remote GitHub repo)

2. **Add entry to `.claude-plugin/marketplace.json`**:
   ```json
   {
     "name": "new-plugin",
     "source": "./plugins/new-plugin",  // or GitHub source
     "description": "What it does",
     "version": "1.0.0",
     "author": { "name": "...", "email": "..." },
     "repository": "https://github.com/...",
     "license": "MIT",
     "category": "productivity",
     "keywords": ["relevant", "tags"]
   }
   ```

3. **Validate marketplace**:
   ```bash
   claude plugin validate .
   ```

### Plugin Validation

Use Claude Code's validation tools:
```bash
# Validate marketplace structure
claude plugin validate .

# Or from within Claude Code
/plugin validate .
```

**Common validation errors**:
- Missing required fields (`name`, `source`)
- Duplicate plugin names
- Invalid JSON syntax
- Path traversal in sources (`..` not allowed)

## MAID Methodology Integration

### Core Concepts

**MAID** = Manifest-driven AI Development

**Key Principles**:
- Only public APIs need manifests (no `_` prefix)
- Three phases: Planning → Testing → Implementation
- Explicit contracts via JSON manifests
- Structural validation + behavioral testing
- TDD workflow (Red-Green-Refactor)

### MAID Workflow Commands

**Complete Workflow**:
- `/maid-run` - Orchestrates entire workflow from goal to validated implementation

**Phase 1 (Planning)**:
- `/spike` - Explore ideas before committing to manifest
- `/generate-manifest` - Create manifest from goal
- `/enhance-manifest` - Improve existing manifest
- `/validate-manifest` - Quality gate before Phase 2

**Phase 2 (Testing)**:
- `/plan` - Complete Phase 1 + 2 (manifest + tests)
- `/generate-tests` - Create behavioral tests from manifest
- `/improve-tests` - Enhance test coverage

**Phase 3 (Implementation)**:
- `/implement` - Code implementation via TDD
- `/fix` - Resolve validation/test failures
- `/run-validation` - Execute validation for specific manifest

**Phase 3.5 (Refinement)**:
- `/refactor` - Improve code while maintaining compliance

**Cross-cutting**:
- `/audit` - Check MAID compliance

### Manifest File Naming Convention

```
manifests/task-XXX-description.manifest.json
```

Where:
- `XXX` = Zero-padded task number (001, 002, etc.)
- `description` = Kebab-case brief description
- Must be in `manifests/` directory

### CLI Command References

The plugin provides slash commands that often recommend CLI usage:

```bash
# Manifest creation
maid manifest create <file_path> --goal "Description"

# Validation
maid validate manifests/task-XXX.manifest.json --use-manifest-chain

# Snapshot generation
maid snapshot <file_path>

# Schema inspection
maid schema
```

**Requirement**: The `maid-runner` PyPI package must be installed (auto-installed by plugin's SessionStart hook).

## Key Dependencies

### Required

- **uv** - Universal Python package manager (https://github.com/astral-sh/uv)
  - Used by auto-installer script
  - Hard requirement: script exits with error if missing

### Plugin-Managed

- **maid-runner** (PyPI) - Auto-installed by SessionStart hook
  - Provides CLI commands for manifest operations
  - Version synced with plugin version (currently 0.7.0)

### User Project Dependencies (Optional)

- **Python 3.10+** - For Python projects using MAID
- **pytest** or **vitest/jest** - Test runners for behavioral tests

## File Modification Rules

### DO Modify

- `plugins/maid-runner/commands/*.md` - Command documentation
- `plugins/maid-runner/agents/*.md` - Agent instructions
- `plugins/maid-runner/skills/maid-methodology/SKILL.md` - MAID docs
- `.claude-plugin/marketplace.json` - Plugin registry
- `README.md` - User-facing documentation

### DO NOT Modify (Without Coordination)

- `plugins/maid-runner/scripts/install_maid_runner.sh` - Critical for auto-install
- `plugins/maid-runner/hooks/hooks.json` - SessionStart trigger configuration

### Version Synchronization

When updating plugin version, update **both**:
1. `plugins/maid-runner/plugin.json` → `version` field
2. `.claude-plugin/marketplace.json` → matching plugin entry's `version` field

## Environment Variables

**Available in Hooks**:
- `${CLAUDE_PLUGIN_ROOT}` - Plugin installation directory
- `${CLAUDE_PROJECT_DIR}` - Project root directory (for SessionStart hooks)
- `$CLAUDE_ENV_FILE` - File path for persisting env vars (SessionStart only)

## Common Issues

### "uv not found" Error

**Symptom**: SessionStart hook fails with error message
**Solution**: Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### Commands Not Available

**Symptom**: `/maid-*` commands don't autocomplete
**Solution**: Restart Claude Code session to reload plugin

### Plugin Updates Not Reflecting

**Symptom**: Changes to plugin files don't appear
**Solution**: Clear plugin cache and reinstall:
```bash
rm -rf ~/.claude/plugins/cache
/plugin install maid-runner@aidrivencoder
```

### Virtual Environment Conflicts

**Symptom**: Package installation affects system Python
**Solution**: The auto-installer creates `.venv` automatically (as of v0.7.0). Delete `.venv` and restart Claude Code to recreate.

## Documentation Resources

- **YouTube**: https://www.youtube.com/@aidrivencoder
  - [MAID Methodology Tutorial](https://youtu.be/A4_6zqPO1yQ)
  - [MCP Integration Guide](https://youtu.be/A0spAPTD4XY)
- **Discord**: https://aidrivencoder.com/discord
- **GitHub Issues**: https://github.com/mamertofabian/maid-runner/issues
- **PyPI Package**: https://pypi.org/project/maid-runner/
- **Professional Services**: mamerto@codefrost.dev
