# MAID Methodology

**This project uses Manifest-driven AI Development (MAID) v1.3**

MAID is a methodology for developing software with AI assistance by explicitly declaring:
- What files can be modified for each task
- What code artifacts (functions, classes, interfaces) should be created or modified
- How to validate that the changes meet requirements

This project is compatible with MAID-aware AI agents including Claude Code and other tools that understand the MAID workflow.

**Supported Languages**: Python (`.py`) and TypeScript/JavaScript (`.ts`, `.tsx`, `.js`, `.jsx`)

## Prerequisites: Installing MAID Runner

MAID Runner is a Python CLI tool that validates manifests and runs tests. Install it using one of these methods:

**Option 1: Using pipx (recommended for global installation)**
```bash
pipx install maid-runner
```

**Option 2: Using pip**
```bash
pip install maid-runner
```

**Option 3: Using uv**
```bash
# As a tool (global)
uv tool install maid-runner

# As a dev dependency (project-local)
uv add maid-runner --dev
```

After installation, verify with:
```bash
maid --help
```

**Note:** MAID Runner requires Python 3.10+. If using `uv` or a virtual environment with a project-local install, prefix commands with your runner (e.g., `uv run maid validate ...`).

## MAID Workflow

### Phase 1: Goal Definition
Confirm the high-level goal before proceeding.

### Phase 2: Planning Loop
**Before ANY implementation - iterative refinement:**
1. Draft manifest (`manifests/task-XXX.manifest.json`)
2. Draft behavioral tests (`tests/test_task_XXX_*.py` or `tests/test_task_XXX_*.test.ts`)
3. Run validation: `maid validate manifests/task-XXX.manifest.json --validation-mode behavioral`
4. Refine both tests & manifest until validation passes

### Phase 3: Implementation
1. Load ONLY files from manifest (`editableFiles` + `readonlyFiles`)
2. Implement code to pass tests
3. Run behavioral validation (from `validationCommand`)
4. Iterate until all tests pass

### Phase 4: Integration
Verify complete chain: `pytest tests/ -v` or `npm test`

## Manifest Template

### Python Example
```json
{
  "goal": "Clear task description",
  "taskType": "edit|create|refactor",
  "supersedes": [],
  "creatableFiles": [],
  "editableFiles": [],
  "readonlyFiles": [],
  "expectedArtifacts": {
    "file": "path/to/file.py",
    "contains": [
      {
        "type": "function|class|attribute",
        "name": "artifact_name",
        "args": [{"name": "arg1", "type": "str"}],
        "returns": "ReturnType"
      }
    ]
  },
  "validationCommand": ["pytest", "tests/test_file.py", "-v"]
}
```

### TypeScript Example
```json
{
  "goal": "Clear task description",
  "taskType": "edit|create|refactor",
  "supersedes": [],
  "creatableFiles": [],
  "editableFiles": [],
  "readonlyFiles": [],
  "expectedArtifacts": {
    "file": "path/to/file.ts",
    "contains": [
      {
        "type": "function|class|interface",
        "name": "artifactName",
        "args": [{"name": "arg1", "type": "string"}],
        "returns": "ReturnType"
      }
    ]
  },
  "validationCommand": ["npm", "test", "--", "file.test.ts"]
}
```

## MAID CLI Commands

```bash
# Validate a manifest
maid validate <manifest-path> [--validation-mode behavioral|implementation]

# Generate a snapshot manifest from existing code
maid snapshot <file-path> [--output-dir <dir>]

# List manifests that reference a file
maid manifests <file-path> [--manifest-dir <dir>]

# Run all validation commands
maid test [--manifest-dir <dir>]

# Get help
maid --help
```

## Validation Modes

- **Strict Mode** (`creatableFiles`): Implementation must EXACTLY match `expectedArtifacts`
- **Permissive Mode** (`editableFiles`): Implementation must CONTAIN `expectedArtifacts` (allows existing code)

## Key Rules

**NEVER:** Modify code without manifest | Skip validation | Access unlisted files
**ALWAYS:** Manifest first → Tests → Implementation → Validate

## Manifest Rules (CRITICAL)

**These rules are non-negotiable for maintaining MAID compliance:**

- **Manifest Immutability**: The current task's manifest (e.g., `task-050.manifest.json`) can be modified while actively working on that task. Once you move to the next task, ALL prior manifests become immutable and part of the permanent audit trail. NEVER modify completed task manifests—this breaks the chronological record of changes.

- **One File Per Manifest**: `expectedArtifacts` is an OBJECT that defines artifacts for a SINGLE file only. It is NOT an array of files. This is a common mistake that will cause validation to fail.

- **Multi-File Changes Require Multiple Manifests**: If your task modifies public APIs in multiple files (e.g., `utils.py` AND `handlers.py`), you MUST create separate sequential manifests—one per file:
  - `task-050-update-utils.manifest.json` → modifies `utils.py`
  - `task-051-update-handlers.manifest.json` → modifies `handlers.py`

- **Definition of Done (Zero Tolerance)**: A task is NOT complete until BOTH validation commands pass with ZERO errors or warnings:
  - `maid validate <manifest-path>` → Must pass 100%
  - `maid test` → Must pass 100%

  Partial completion is not acceptable. All errors must be fixed before proceeding to the next task.

## Artifact Rules

- **Public** (no `_` prefix): MUST be in manifest
- **Private** (`_` prefix): Optional in manifest
- **creatableFiles**: Strict validation (exact match)
- **editableFiles**: Permissive validation (contains at least)

## Superseded Manifests

**Critical:** When a manifest is superseded, it is completely excluded from MAID operations:

- `maid validate` ignores superseded manifests when merging manifest chains
- `maid test` does NOT execute `validationCommand` from superseded manifests
- Superseded manifests serve as historical documentation only—they are archived, not active

## Transitioning from Snapshots to Natural Evolution

**Key Insight:** Snapshot manifests are for "frozen" code. Once code evolves, transition to natural MAID flow:

1. **Snapshot Phase**: Capture complete baseline with `maid snapshot`
2. **Transition Manifest**: When file needs changes, create edit manifest that:
   - Declares ALL current functions (existing + new)
   - Supersedes the snapshot manifest
   - Uses `taskType: "edit"`
3. **Future Evolution**: Subsequent manifests only declare new changes
   - With `--use-manifest-chain`, validator merges all active manifests
   - No need to update previous manifests

## File Deletion Pattern

When removing a file tracked by MAID: Create refactor manifest → Supersede creation manifest → Delete file and tests → Validate deletion.

**Manifest**: `taskType: "refactor"`, supersedes original, `status: "absent"` in expectedArtifacts

**Validation**: File deleted, tests deleted, no remaining imports

## File Rename Pattern

When renaming a file tracked by MAID: Create refactor manifest → Supersede creation manifest → Use `git mv` → Update manifest → Validate rename.

**Manifest**: `taskType: "refactor"`, supersedes original, new filename in `creatableFiles`, same API in `expectedArtifacts` under new location

**Validation**: Old file deleted, new file exists with working functionality, no old imports, git history preserved

**Key difference from deletion**: Rename maintains module's public API continuity under new location.

## Refactoring Private Implementation

MAID provides flexibility for refactoring private implementation details without requiring new manifests:

- **Private code** (functions, classes, variables with `_` prefix) can be refactored freely
- **Internal logic changes** that don't affect the public API are allowed
- **Code quality improvements** (splitting functions, extracting helpers, renaming privates) are permitted

**Requirements:**
- All tests must continue to pass
- All validations must pass (`maid validate`, `maid test`)
- Public API must remain unchanged
- No MAID rules are violated

This breathing room allows practical development without bureaucracy while maintaining accountability for public interface changes.

## Getting Started

1. Create your first manifest in `manifests/task-001-<description>.manifest.json`
2. Write behavioral tests in `tests/test_task_001_*.py` or `tests/test_task_001_*.test.ts`
3. Validate: `maid validate manifests/task-001-<description>.manifest.json --validation-mode behavioral`
4. Implement the code
5. Run tests to verify: `maid test`

## Additional Resources

- **Full MAID Specification**: Available in the MAID Runner plugin documentation
- **MAID Runner Repository**: https://github.com/mamertofabian/maid-runner
