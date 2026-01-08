---
name: MAID Methodology
description: This skill should be used when the user asks about "MAID methodology", "manifest-driven development", "create a manifest", "MAID workflow", "MAID rules", "validate manifest", "how to use MAID", "what is MAID", mentions "manifests/" directory, asks to "follow MAID", asks about "MAID agents", "maid-manifest-architect", "maid-developer", "maid-test-designer", "unit testing", "behavioral tests", or when working with MAID Runner commands. Provides comprehensive guidance on the Manifest-driven AI Development (MAID) v1.3 methodology including custom agents and CLI commands.
version: 1.3.0
---

# MAID Methodology

**⚠️ CRITICAL: Every code change MUST follow the MAID workflow.**
**⚠️ CRITICAL: You MUST use the appropriate MAID subagent for each phase. DO NOT skip subagent delegation.**

**Note on Documentation Changes:** Pure documentation changes (modifying only `.md` files with no code artifacts) may be exempt from the full MAID workflow, but should still be reviewed for accuracy and consistency. When in doubt, create a manifest.

MAID is a methodology for developing software with AI assistance by explicitly declaring:
- What files can be modified for each task
- What code artifacts (functions, classes, interfaces) should be created or modified
- How to validate that the changes meet requirements

**Supported Languages**: Python (`.py`) and TypeScript/JavaScript (`.ts`, `.tsx`, `.js`, `.jsx`)

---

## ⚠️ MANDATORY: Use MAID Subagents for Each Phase

**THIS IS NON-NEGOTIABLE. You MUST delegate to the appropriate MAID subagent for each phase of the workflow.**

The MAID methodology requires using specialized Claude Code subagents to ensure consistent, high-quality execution of each phase. **Do not attempt to perform MAID phases directly without using the designated subagent.**

### Required Subagent Usage

| Phase | Subagent | MUST Use When |
|-------|----------|---------------|
| **Phase 1** | `maid-manifest-architect` | Creating or modifying any manifest |
| **Phase 1-2 Gate** | `maid-plan-reviewer` | Before starting implementation |
| **Phase 2** | `maid-test-designer` | Creating behavioral tests |
| **Phase 3** | `maid-developer` | Implementing code to pass tests |
| **Phase 3 Support** | `maid-fixer` | Any validation error or test failure |
| **Phase 3.5** | `maid-refactorer` | Improving code after tests pass |
| **Audit** | `maid-auditor` | Checking MAID compliance |

### How to Invoke Subagents

Use the **Task tool** to delegate to the appropriate subagent:

```
Task tool parameters:
- subagent_type: "maid-manifest-architect" (or other agent name)
- prompt: "Create a manifest for [goal]"
- description: "Phase 1: Create manifest"
```

**Examples of correct subagent delegation:**

1. **User asks to add a feature:**
   → Invoke `maid-manifest-architect` subagent to create the manifest
   → Invoke `maid-test-designer` subagent to create tests
   → Invoke `maid-developer` subagent to implement

2. **User asks to fix a bug:**
   → Invoke `maid-manifest-architect` subagent (bug fixes need manifests too)
   → Invoke `maid-test-designer` subagent (write test that reproduces bug)
   → Invoke `maid-developer` subagent to fix

3. **Validation fails:**
   → Invoke `maid-fixer` subagent to identify and fix the issue

4. **User asks to refactor:**
   → Invoke `maid-refactorer` subagent to improve code quality

**WHY SUBAGENTS ARE MANDATORY:**
- Each subagent has specialized instructions for its phase
- Subagents ensure consistent application of MAID rules
- Subagents reference the correct documentation (unit-testing-rules.md, maid_specs.md)
- Subagents run the correct validation commands at the right time

---

## Key MAID Principles

- **Explicitness**: Every task context is explicitly defined in manifests
- **Extreme Isolation**: Tasks touch minimal files, specified in manifest
- **Test-Driven Validation**: Tests define success, not subjective assessment
- **Verifiable Chronology**: Current state = sequential manifest application
- **Subagent Delegation**: Each phase uses its designated subagent

**The MAID workflow embodies TDD at two levels:**
- **Planning Loop**: Iterative test-manifest refinement (micro TDD)
- **Overall Workflow**: Red (failing tests) → Green (passing implementation) → Refactor (quality improvement)

---

## MAID Subagent Reference

| Subagent | Phase | Purpose | Key Responsibilities |
|----------|-------|---------|---------------------|
| `maid-manifest-architect` | Phase 1 | Create manifests | Find next task number, create manifest, validate schema |
| `maid-plan-reviewer` | Phase 1-2 Quality Gate | Review before implementation | Verify manifest completeness, check test coverage |
| `maid-test-designer` | Phase 2 | Create behavioral tests | Follow unit-testing-rules.md, USE artifacts, ASSERT behavior |
| `maid-developer` | Phase 3 | Implement code (TDD) | Confirm red phase, implement to pass tests, validate |
| `maid-fixer` | Phase 3 Support | Fix errors | Identify issue, fix one at a time, re-validate |
| `maid-refactorer` | Phase 3.5 | Improve code quality | Maintain tests passing, apply clean code principles |
| `maid-auditor` | Cross-cutting | Enforce compliance | Check immutability, verify artifacts, audit manifests |

---

## MAID Workflow with Subagents

**⚠️ REMINDER: Each phase below REQUIRES using the designated subagent. Do not perform these phases directly.**

### Phase 1: Goal Definition & Manifest Creation

**⚠️ MUST USE SUBAGENT: `maid-manifest-architect`**

1. Confirm the high-level goal with user before proceeding
2. **INVOKE the `maid-manifest-architect` subagent** using the Task tool to:
   - Analyze the goal and identify affected files
   - Find next task number: `ls manifests/task-*.manifest.json | tail -1`
   - Draft manifest (`manifests/task-XXX.manifest.json`) - **PRIMARY CONTRACT**
3. Subagent runs: `maid validate manifests/task-XXX.manifest.json --use-manifest-chain`
4. Iterate until validation passes

**When to create a manifest**: Only for public API changes (functions, classes, methods without `_` prefix). Private implementation refactoring does NOT need a manifest.

### Phase 2: Planning Loop (Test Design)

**⚠️ MUST USE SUBAGENT: `maid-test-designer`**

**Before ANY implementation - iterative refinement:**
1. **INVOKE the `maid-test-designer` subagent** using the Task tool to:
   - Read manifest `expectedArtifacts`
   - Create behavioral tests (`tests/test_task_XXX_*.py` or `tests/test_task_XXX_*.test.ts`)
   - **Follow unit-testing-rules.md** for testing standards
   - Tests must USE artifacts AND ASSERT on behavior
2. Subagent runs: `maid validate manifests/task-XXX.manifest.json --validation-mode behavioral --use-manifest-chain`
3. Verify Red phase: Tests should FAIL (no implementation yet)
4. Refine BOTH tests & manifest together until validation passes

**Quality Gate**: **INVOKE `maid-plan-reviewer` subagent** to review manifest and tests before proceeding to implementation.

### Phase 3: Implementation (TDD)

**⚠️ MUST USE SUBAGENT: `maid-developer`**

1. Confirm Red phase (tests fail)
2. Load ONLY files from manifest (`editableFiles` + `readonlyFiles`)
3. **INVOKE the `maid-developer` subagent** using the Task tool to:
   - Implement code to pass tests (Green phase)
   - Match manifest artifacts exactly
   - Only edit files listed in manifest
4. Subagent runs: `maid validate manifests/task-XXX.manifest.json --validation-mode implementation --use-manifest-chain`
5. Run behavioral tests (from `validationCommand`)
6. Iterate until all validations and tests pass

**Error Recovery**: If validation fails, **INVOKE `maid-fixer` subagent** to identify and fix issues one at a time.

### Phase 3.5: Refactoring

**⚠️ MUST USE SUBAGENT: `maid-refactorer`**

1. After tests pass, **INVOKE the `maid-refactorer` subagent** to:
   - Improve code quality while tests pass
   - Maintain public API and manifest compliance
   - Apply clean code principles and patterns
2. Validate tests still pass after each change
3. Keep public API unchanged

### Phase 4: Integration

**VALIDATE EVERYTHING**:
```bash
maid validate        # Validate ALL manifests
maid test            # Run ALL validation commands
pytest tests/ -v     # Full test suite (Python)
npm test             # Full test suite (TypeScript)
```

---

## MAID CLI Quick Reference

### Essential Commands (Run These Frequently!)

```bash
# Whole-codebase validation - PRIMARY COMMANDS
maid validate                 # Validate ALL active manifests
maid test                     # Run ALL validation commands from manifests

# Phase-specific validation
maid validate <path> --validation-mode behavioral     # Phase 2: Verify tests USE artifacts
maid validate <path> --validation-mode implementation # Phase 3: Verify code DEFINES artifacts

# With manifest chain (recommended for evolving codebases)
maid validate <path> --use-manifest-chain

# Manifest creation (auto-numbers, auto-supersedes)
maid manifest create <file> --goal "description"
maid manifest create <file> --goal "description" --artifacts '[{"type": "class", "name": "MyClass"}]'
maid manifest create <file> --goal "description" --dry-run --json  # Preview first

# Capture existing code baseline
maid snapshot <file>

# Find manifests for a file
maid manifests <file>

# Watch mode for TDD
maid test --manifest <path> --watch       # Single manifest
maid test --watch-all                     # Multi-manifest

# Get help
maid --help
maid validate --help
```

---

## Testing Standards

**⚠️ CRITICAL: All tests must follow the unit testing rules defined in `@${CLAUDE_PLUGIN_ROOT}/docs/unit-testing-rules.md`**

### Key Testing Principles

1. **Test behavior, not implementation details** - Focus on observable inputs and outputs
2. **Minimize mocking to essential dependencies** - Only mock external systems you don't control
3. **Make tests deterministic and independent** - Tests should not depend on each other
4. **Test for failure conditions, not just happy paths** - Verify error handling works correctly
5. **Keep tests simple, readable, and maintainable** - Follow the AAA pattern: Arrange, Act, Assert

### Testing Frameworks

| Language   | Primary Framework | Fallback/Alternative |
|------------|-------------------|----------------------|
| Python     | pytest            | unittest             |
| TypeScript | Vitest / Jest     | Mocha + Chai         |

### Critical Testing Rules

- **Don't mock what you don't own** - Create adapters around external dependencies
- **Test state changes, not just function calls** - Verify actual data changes
- **Use test fixtures intelligently** - Leverage framework-provided fixtures for setup/teardown
- **Make tests obvious and transparent** - Someone unfamiliar should understand what a test verifies
- **Write tests before fixing bugs** - Create a test that reproduces the bug first

For complete guidelines, see `@${CLAUDE_PLUGIN_ROOT}/docs/unit-testing-rules.md`.

---

## Validation Flow

The `maid validate` command supports two validation modes:

### Behavioral Mode (`--validation-mode behavioral`)
**Use during Phase 2 (Planning Loop) when writing tests**

1. **Schema Validation**: Ensures manifest follows the JSON schema
2. **Behavioral Test Validation**: Verifies test files USE the declared artifacts (AST-based)

Note: Behavioral validation only checks artifacts from the current manifest, not the merged chain.

### Implementation Mode (`--validation-mode implementation`, default)
**Use during Phase 3 (Implementation) when writing code**

1. **Schema Validation**: Ensures manifest follows the JSON schema
2. **Implementation Validation**: Verifies code DEFINES the declared artifacts
3. **File Tracking Analysis** (when using `--use-manifest-chain`): Detects undeclared and partially compliant files

### File Tracking Analysis

When using `--use-manifest-chain` in implementation mode, MAID Runner performs automatic file tracking analysis with a two-level warning system:

- **🔴 UNDECLARED** (High Priority): Files exist in codebase but not in any manifest
  - No audit trail of when/why created
  - **Action**: Add to `creatableFiles` or `editableFiles` in a manifest

- **🟡 REGISTERED** (Medium Priority): Files in manifests but incomplete compliance
  - Issues: Missing `expectedArtifacts`, no tests, or only in `readonlyFiles`
  - **Action**: Add `expectedArtifacts` and `validationCommand` for full compliance

- **✓ TRACKED** (Clean): Files with full MAID compliance
  - Properly documented with artifacts and behavioral tests

This progressive compliance system helps identify accountability gaps and supports gradual migration to MAID.

---

## Subagent Invocation Patterns

**⚠️ These patterns show the REQUIRED subagent invocations for common scenarios.**

### Pattern 1: Complete MAID Workflow (Feature Request)

```
User: "Add a user authentication module"

1. INVOKE maid-manifest-architect subagent via Task tool:
   → subagent_type: "maid-manifest-architect"
   → prompt: "Create manifest for user authentication module"
   → Subagent creates manifests/task-XXX-user-auth.manifest.json
   → Subagent runs: maid validate --use-manifest-chain

2. INVOKE maid-test-designer subagent via Task tool:
   → subagent_type: "maid-test-designer"
   → prompt: "Create behavioral tests for task-XXX"
   → Subagent reads unit-testing-rules.md
   → Subagent creates tests/test_task_XXX_user_auth.py
   → Subagent runs: maid validate --validation-mode behavioral

3. INVOKE maid-developer subagent via Task tool:
   → subagent_type: "maid-developer"
   → prompt: "Implement code to pass tests for task-XXX"
   → Subagent implements src/auth.py
   → Subagent runs: maid validate && pytest

4. Final validation:
   → maid validate && maid test
```

### Pattern 2: Fix Failing Validation

```
User: "The validation is failing, please fix it"

INVOKE maid-fixer subagent via Task tool:
→ subagent_type: "maid-fixer"
→ prompt: "Fix validation errors for task-XXX"
→ Subagent reads validation error output
→ Subagent identifies specific issue
→ Subagent fixes one issue at a time
→ Subagent re-runs: maid validate <path>
→ Repeats until all issues resolved
```

### Pattern 3: Improve Code Quality

```
User: "Refactor the implementation to improve code quality"

INVOKE maid-refactorer subagent via Task tool:
→ subagent_type: "maid-refactorer"
→ prompt: "Improve code quality for [file/module]"
→ Subagent reviews current implementation
→ Subagent applies clean code principles
→ Subagent runs tests after each change
→ Subagent ensures: maid validate passes
```

### Pattern 4: Compliance Audit

```
User: "Check if the code follows MAID methodology"

INVOKE maid-auditor subagent via Task tool:
→ subagent_type: "maid-auditor"
→ prompt: "Audit MAID compliance for the codebase"
→ Subagent reviews all manifests
→ Subagent checks for immutability violations
→ Subagent verifies artifact declarations
→ Subagent runs: maid validate
→ Subagent reports compliance status
```

### Pattern 5: Bug Fix

```
User: "Fix the login bug where users can't authenticate"

1. INVOKE maid-manifest-architect subagent:
   → Create manifest for the bug fix (bugs need manifests too!)

2. INVOKE maid-test-designer subagent:
   → Write test that reproduces the bug (should fail initially)

3. INVOKE maid-developer subagent:
   → Implement fix to pass the test

4. Final validation:
   → maid validate && maid test
```

---

## Key Rules

**NEVER:** Modify code without manifest | Skip validation | Access unlisted files
**ALWAYS:** Manifest first → Tests → Implementation → Validate

---

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

---

## Manifest Template

**⚠️ CRITICAL: `expectedArtifacts` is an OBJECT, not an array!**

- `expectedArtifacts` defines artifacts for **ONE file only**
- For multi-file tasks: Create **separate manifests** for each file
- Structure: `{"file": "...", "contains": [...]}`
- **NOT** an array of file objects

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
        "class": "ParentClass",
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

---

## Validation Modes

- **Strict Mode** (`creatableFiles`): Implementation must EXACTLY match `expectedArtifacts`
- **Permissive Mode** (`editableFiles`): Implementation must CONTAIN `expectedArtifacts` (allows existing code)

---

## Artifact Rules

- **Public** (no `_` prefix): MUST be in manifest
- **Private** (`_` prefix): Optional in manifest
- **creatableFiles**: Strict validation (exact match)
- **editableFiles**: Permissive validation (contains at least)

---

## Superseded Manifests and Test Execution

**Critical Behavior:** When a manifest is superseded, it is completely excluded from MAID operations:

- `maid validate` ignores superseded manifests when merging manifest chains
- `maid test` does NOT execute `validationCommand` from superseded manifests
- Superseded manifests serve as historical documentation only—they are archived, not active

**Why this matters:** If you supersede a manifest, its tests will no longer run. This is by design—superseded manifests represent obsolete contracts that have been replaced.

---

## Transitioning from Snapshots to Natural Evolution

**Key Insight:** Snapshot manifests are for "frozen" code. Once code needs to evolve, you must transition to the natural MAID flow.

### The Pattern

1. **Snapshot Phase** (Initial baseline):
   - Use `maid snapshot` to capture complete public API of existing code
   - `taskType: "snapshot"` declares ALL functions/classes at that point in time

2. **Transition Manifest** (First evolution):
   - When file needs changes, create an edit manifest that:
     - Declares ALL current functions (existing + new)
     - Supersedes the snapshot manifest
     - Uses `taskType: "edit"` (not "snapshot")
   - This is the bridge from frozen state to natural evolution

3. **Future Evolution** (Natural MAID flow):
   - Subsequent manifests only declare NEW changes
   - With `--use-manifest-chain`, validator merges all active manifests
   - No need to update previous manifests when adding new APIs

### Example Evolution

```
File history: src/service.py

task-015-snapshot-service.manifest.json (snapshot)
├─ Declares: func_1, func_2, func_3
└─ Status: SUPERSEDED by task-123

task-123-add-new-feature.manifest.json (edit, supersedes task-015)
├─ Declares: func_1, func_2, func_3, new_func  // ALL current functions
└─ Supersedes: ["task-015-snapshot-service.manifest.json"]

task-126-another-feature.manifest.json (edit)
└─ Declares: another_func  // Only the new addition

With --use-manifest-chain:
  Merged = task-123 + task-126
  = {func_1, func_2, func_3, new_func, another_func} ✅
```

### Key Rules

- Once you supersede a snapshot with a comprehensive edit manifest, continue using incremental edit manifests
- Don't create new snapshots unless establishing a new "checkpoint" baseline
- The transition manifest must be comprehensive (list ALL current functions), but future edits can be incremental

---

## File Deletion Pattern

When removing a file tracked by MAID: Create refactor manifest → Supersede creation manifest → Delete file and tests → Validate deletion.

**Manifest**: `taskType: "refactor"`, supersedes original, `status: "absent"` in expectedArtifacts

**Validation**: File deleted, tests deleted, no remaining imports

---

## File Rename Pattern

When renaming a file tracked by MAID: Create refactor manifest → Supersede creation manifest → Use `git mv` → Update manifest → Validate rename.

**Manifest**: `taskType: "refactor"`, supersedes original, new filename in `creatableFiles`, same API in `expectedArtifacts` under new location

**Validation**: Old file deleted, new file exists with working functionality, no old imports, git history preserved

**Key difference from deletion**: Rename maintains module's public API continuity under new location.

---

## Refactoring Private Implementation

MAID provides flexibility for refactoring private implementation details without requiring new manifests:

- **Private code** (functions, classes, variables with `_` prefix) can be refactored freely
- **Internal logic changes** that don't affect the public API are allowed
- **Code quality improvements** (splitting functions, extracting helpers, renaming privates) are permitted

**Requirements:**
- All tests must continue to pass (`maid test`)
- All validations must pass (`maid validate`)
- Public API must remain unchanged (no changes to public functions, classes, or signatures)
- No MAID rules are violated

This breathing room allows practical development without bureaucracy while maintaining accountability for public interface changes.

---

## Handling Prerequisite Discovery

### The Challenge
When implementing a task, you may discover that the validator or system can't handle something required by your task.

### The MAID-Compliant Solution

**What NOT to do:**
- ❌ Create workarounds in tests (artificial assertions)
- ❌ Document limitations and continue
- ❌ Modify the manifest to hide the problem

**The Correct Approach:**
1. **Stash Current Work**: `git stash` current task implementation
2. **Create Prerequisite Task**: Task with alphabetic suffix (e.g., Task-006a) to fix the issue
3. **Complete Prerequisite**: Full MAID workflow for the prerequisite
4. **Restore and Complete**: Original task now works cleanly

### Task Numbering Strategy

When discovering prerequisites mid-task, use alphabetic suffixes:
- Task-006a, Task-006b, etc. for discovered prerequisites
- Preserves original task numbers
- Maintains clean chronological ordering

### Key Principle: No Partial Solutions

**Every task must complete fully with all validations passing.** If validation fails, either:
1. Fix the test (if test is wrong)
2. Fix the implementation (if implementation is wrong)
3. Fix the prerequisite (if system limitation discovered)

Never leave a task partially complete or with failing validations.

---

## Prerequisites: Installing MAID Runner

MAID Runner is a Python CLI tool that validates manifests and runs tests. The MAID Runner plugin automatically installs it on session start, but you can also install it manually:

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

---

## Getting Started with MAID Subagents

**⚠️ REMEMBER: Always INVOKE the appropriate subagent for each phase using the Task tool.**

1. **Describe Your Goal**: Tell Claude what you want to build
2. **Manifest Creation**: **INVOKE `maid-manifest-architect` subagent** via Task tool to create the manifest
3. **Validation**: Subagent runs `maid validate` to verify manifest structure
4. **Test Design**: **INVOKE `maid-test-designer` subagent** via Task tool to create behavioral tests (following unit-testing-rules.md)
5. **Implementation**: **INVOKE `maid-developer` subagent** via Task tool to implement code
6. **Final Validation**: Run `maid validate` and `maid test` to verify everything

### Manual Getting Started (Without Subagents)

If for some reason subagents cannot be used, follow this manual process:

1. Create your first manifest in `manifests/task-001-<description>.manifest.json`
2. Write behavioral tests in `tests/test_task_001_*.py` or `tests/test_task_001_*.test.ts`
3. Validate: `maid validate manifests/task-001-<description>.manifest.json --validation-mode behavioral`
4. Implement the code
5. Run tests to verify: `maid test`

**Note**: Manual execution is less reliable than using subagents. Subagents have specialized instructions for each phase and ensure consistent application of MAID rules.

---

## Available Slash Commands

The plugin provides these slash commands for quick access:

| Command | Description |
|---------|-------------|
| `/spike` | Explore and spike an idea before creating manifest |
| `/plan` | Complete Phase 1 & 2 (manifest + tests) from goal |
| `/maid-run` | Run complete MAID workflow from goal to validated implementation |
| `/generate-manifest` | Generate MAID manifest from goal (Phase 1) |
| `/enhance-manifest` | Enhance existing manifest with additional details |
| `/validate-manifest` | Validate and review manifest (Phase 1/2 quality gate) |
| `/generate-tests` | Generate behavioral tests from manifest (Phase 2) |
| `/implement` | Implement code from manifest (Phase 3) |
| `/fix` | Fix validation errors and test failures (Phase 3 support) |
| `/refactor` | Refactor code while maintaining compliance (Phase 3.5) |
| `/audit` | Audit MAID compliance (cross-cutting) |
| `/run-validation` | Run validation tests for a manifest or task number |
| `/improve-tests` | Enhance test coverage and quality |

---

## Key Reminders

- Manifest chain = source of truth for file state
- Manifest = contract; tests support implementation and verification
- Every change needs a manifest with sequential numbering
- **Manifest immutability**: Current task's manifest can be modified during active development; all prior tasks' manifests are immutable
- **One file per manifest**: `expectedArtifacts` defines artifacts for ONE file only; multi-file changes require separate manifests

---

## Additional Resources

For complete MAID specification details, see the full documentation at:
- **Full MAID Specification**: @${CLAUDE_PLUGIN_ROOT}/docs/maid_specs.md
- **Unit Testing Rules**: @${CLAUDE_PLUGIN_ROOT}/docs/unit-testing-rules.md
- **MAID Runner Repository**: https://github.com/mamertofabian/maid-runner
