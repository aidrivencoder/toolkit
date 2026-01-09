# MAID Runner Plugin for Claude Code

A Claude Code plugin that provides complete Manifest-driven AI Development (MAID) methodology support without requiring manual initialization.

## What is MAID?

MAID (Manifest-driven AI Development) is a structured methodology for software engineering with AI assistance. It ensures architectural integrity, quality, and maintainability by having developers act as high-level architects who provide AI agents with explicit, testable, and isolated tasks.

## What This Plugin Provides

### Automatic Installation
- **Auto-installs maid-runner PyPI package** on session start using `uv`
- No manual `maid init` required - everything is ready to use

### 13 MAID Commands
Slash commands available immediately after plugin installation:

- `/spike` - Explore and spike an idea before creating manifest
- `/plan` - Complete Phase 1 & 2 (manifest + tests) from goal
- `/maid-run` - Run complete MAID workflow from goal to validated implementation
- `/generate-manifest` - Generate MAID manifest from goal (Phase 1)
- `/enhance-manifest` - Enhance existing manifest with additional details
- `/validate-manifest` - Validate and review manifest (Phase 1/2 quality gate)
- `/generate-tests` - Generate behavioral tests from manifest (Phase 2)
- `/implement` - Implement code from manifest (Phase 3)
- `/fix` - Fix validation errors and test failures (Phase 3 support)
- `/refactor` - Refactor code while maintaining compliance (Phase 3.5)
- `/audit` - Audit MAID compliance (cross-cutting)
- `/run-validation` - Run validation tests for a manifest or task number
- `/improve-tests` - Enhance test coverage and quality

### 7 MAID Agents
Specialized sub-agents for different phases:

- **maid-manifest-architect** - Phase 1: Creates and validates manifests from goals
- **maid-plan-reviewer** - Phase 2 Quality Gate: Reviews manifest and tests before implementation
- **maid-test-designer** - Phase 2: Creates behavioral tests from manifests
- **maid-developer** - Phase 3: Implements code to pass tests (TDD)
- **maid-fixer** - Phase 3 Support: Fixes validation errors and test failures
- **maid-refactorer** - Phase 3.5: Improves code quality while maintaining compliance
- **maid-auditor** - Cross-cutting: Enforces MAID compliance across all phases

### On-Demand MAID Methodology Guidance
- **MAID Methodology Skill** - Activated when you ask about MAID or use MAID commands
- Full MAID specification (v1.3) available on-demand
- Unit testing rules and best practices
- Documentation loaded only when needed - keeps sessions lightweight

## Prerequisites

### Required
- **uv** - Universal Python package manager (https://github.com/astral-sh/uv)
  ```bash
  # Install uv if you haven't already
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

### Recommended
- Python 3.10+ (for running `maid` CLI commands)
- pytest or vitest/jest (depending on your project language)

## Installation

```bash
# Install this plugin from the aidrivencoder marketplace
/plugin install maid-runner@aidrivencoder
```

The plugin will automatically:
1. Install the `maid-runner` PyPI package using `uv` (silent, idempotent)
2. Make all MAID commands and agents available
3. Activate MAID methodology guidance when you need it (on-demand skill)

## How It Differs from `maid init`

### Traditional Approach (maid init)
```bash
# Install maid-runner package
uv pip install maid-runner

# Initialize MAID in your project
cd your-project
maid init

# This copies:
# - Commands to .claude/commands/
# - Agents to .claude/agents/
# - Docs to .maid/docs/
# - Updates CLAUDE.md
```

### Plugin Approach (This Plugin)
```bash
# Just install the plugin
/plugin install maid-runner@aidrivencoder

# Everything is ready to use!
# - Commands available as /command-name
# - Agents available via Task tool
# - MAID methodology skill activates when needed
# - No CLAUDE.md modification needed
```

### Key Differences
| Feature | maid init | Plugin |
|---------|-----------|--------|
| Installation | Manual pip/uv install | Automatic on session start |
| Commands/Agents | Copies to .claude/ | Provided by plugin |
| Documentation | Modifies CLAUDE.md | On-demand skill (activated when needed) |
| Context Usage | Always loaded | Only when using MAID |
| Updates | Manual re-run of init | Automatic with plugin updates |
| Project Structure | Creates manifests/, tests/, .maid/docs/ | Created when needed by commands |

## Getting Started

After installing the plugin:

1. **Access MAID Methodology Guidance** (on-demand)

   The MAID methodology skill activates automatically when you:
   - Ask about MAID: "How do I use MAID?", "What is MAID methodology?"
   - Mention manifests: "Create a manifest", "MAID workflow"
   - Use MAID commands: `/generate-manifest`, `/maid-run`, etc.

   The skill provides complete MAID v1.3 documentation including workflow, rules, and best practices.

2. **Start using MAID commands**
   ```bash
   # Generate your first manifest
   /generate-manifest

   # Or run the complete workflow
   /maid-run
   ```

3. **Create your first manifest manually**
   ```json
   // manifests/task-001-example.manifest.json
   {
     "goal": "Create a user authentication module",
     "taskType": "create",
     "creatableFiles": ["src/auth.py"],
     "expectedArtifacts": {
       "file": "src/auth.py",
       "contains": [
         {
           "type": "function",
           "name": "authenticate_user",
           "args": [{"name": "username", "type": "str"}, {"name": "password", "type": "str"}],
           "returns": "bool"
         }
       ]
     },
     "validationCommand": ["pytest", "tests/test_auth.py", "-v"]
   }
   ```

4. **Generate tests and implement**
   ```bash
   /generate-tests manifests/task-001-example.manifest.json
   /implement manifests/task-001-example.manifest.json
   ```

5. **Validate your work**
   ```bash
   /run-validation task-001
   ```

## Documentation

- **Full MAID Specification**: See `docs/maid_specs.md` in this plugin
- **Unit Testing Rules**: See `docs/unit-testing-rules.md` in this plugin
- **MAID Runner Repository**: https://github.com/mamertofabian/maid-runner
- **PyPI Package**: https://pypi.org/project/maid-runner/

## Version

Plugin version: **0.9.0** (matches maid-runner PyPI package version)

## Support

- **Issues**: https://github.com/mamertofabian/maid-runner/issues
- **Author**: Mamerto Fabian (mamerto@codefrost.dev)
- **License**: MIT

## Advanced Usage

### Using MAID Agents Directly

You can invoke MAID agents directly using the Task tool:

```
"I need to create a manifest for user authentication"
# Claude will use the maid-manifest-architect agent

"Review my manifest and tests before implementation"
# Claude will use the maid-plan-reviewer agent
```

### Custom Validation Commands

MAID supports any validation command in your manifest:

```json
{
  "validationCommand": ["npm", "test", "--", "auth.test.ts"]
  // or
  "validationCommand": ["pytest", "tests/test_auth.py", "-v"]
  // or
  "validationCommand": ["cargo", "test", "test_auth"]
}
```

### Manifest Chains

MAID supports manifest chains for evolving code:

```json
{
  "taskType": "edit",
  "supersedes": ["task-001-create-auth.manifest.json"],
  "editableFiles": ["src/auth.py"],
  ...
}
```

## Tips

1. **Always validate before implementing**: Use `/validate-manifest` before `/implement`
2. **Use behavioral tests**: Write tests that verify behavior, not implementation
3. **Keep manifests small**: One file per manifest for clear audit trails
4. **Use manifest chains**: Supersede old manifests instead of modifying them
5. **Run quality checks**: Use `/audit` to ensure MAID compliance

## Troubleshooting

### "uv not found" error
Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### Commands not available
Restart your Claude Code session to reload the plugin

### Validation fails
Run `/fix` to automatically fix common validation errors

### Want to update MAID Runner
The plugin will auto-update the PyPI package on next session start after updating the plugin version
