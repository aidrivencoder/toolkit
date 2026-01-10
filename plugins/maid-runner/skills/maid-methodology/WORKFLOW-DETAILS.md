# MAID Workflow Details

Detailed guidance for each phase of the MAID workflow.

## Contents

- Phase 1: Goal Definition & Manifest Creation
- Phase 2: Planning Loop (Test Design)
- Phase 3: Implementation (TDD)
- Phase 3.5: Refactoring
- Phase 4: Integration
- Handling Prerequisite Discovery
- Definition of Done
- Key Principle: No Partial Solutions
- TDD Workflow Summary
- Manual Workflow (Without Subagents)

---

## Phase 1: Goal Definition & Manifest Creation

**Subagent: `maid-runner:maid-manifest-architect`**

### Steps

1. Confirm the high-level goal with user before proceeding
2. **INVOKE the `maid-runner:maid-manifest-architect` subagent** using the Task tool to:
   - Analyze the goal and identify affected files
   - Find next task number: `ls manifests/task-*.manifest.json | tail -1`
   - Draft manifest (`manifests/task-XXX.manifest.json`) - **PRIMARY CONTRACT**
3. Subagent runs: `maid validate manifests/task-XXX.manifest.json --use-manifest-chain`
4. Iterate until validation passes

### When to Create a Manifest

**Create a manifest for:**
- Public API changes (functions, classes, methods without `_` prefix)
- New features
- Bug fixes

**Do NOT create a manifest for:**
- Private implementation refactoring (`_` prefix functions)
- Pure documentation changes (only `.md` files)

---

## Phase 2: Planning Loop (Test Design)

**Subagent: `maid-runner:maid-test-designer`**

### Steps

1. **INVOKE the `maid-runner:maid-test-designer` subagent** using the Task tool to:
   - Read manifest `expectedArtifacts`
   - Create behavioral tests (`tests/test_task_XXX_*.py` or `tests/test_task_XXX_*.test.ts`)
   - **Follow unit-testing-rules.md** for testing standards
   - Tests must USE artifacts AND ASSERT on behavior
2. Subagent runs: `maid validate manifests/task-XXX.manifest.json --validation-mode behavioral --use-manifest-chain`
3. Verify Red phase: Tests should FAIL (no implementation yet)
4. Refine BOTH tests & manifest together until validation passes

### Quality Gate

**INVOKE `maid-runner:maid-plan-reviewer` subagent** to review manifest and tests before proceeding to implementation.

The plan reviewer verifies:
- Manifest completeness
- Test coverage adequacy
- Alignment between manifest and tests

---

## Phase 3: Implementation (TDD)

**Subagent: `maid-runner:maid-developer`**

### Steps

1. Confirm Red phase (tests fail)
2. Load ONLY files from manifest (`editableFiles` + `readonlyFiles`)
3. **INVOKE the `maid-runner:maid-developer` subagent** using the Task tool to:
   - Implement code to pass tests (Green phase)
   - Match manifest artifacts exactly
   - Only edit files listed in manifest
4. Subagent runs: `maid validate manifests/task-XXX.manifest.json --validation-mode implementation --use-manifest-chain`
5. Run behavioral tests (from `validationCommand`)
6. Iterate until all validations and tests pass

### Error Recovery

If validation fails, **INVOKE `maid-runner:maid-fixer` subagent** to identify and fix issues one at a time.

---

## Phase 3.5: Refactoring

**Subagent: `maid-runner:maid-refactorer`**

### Steps

1. After tests pass, **INVOKE the `maid-runner:maid-refactorer` subagent** to:
   - Improve code quality while tests pass
   - Maintain public API and manifest compliance
   - Apply clean code principles and patterns
2. Validate tests still pass after each change
3. Keep public API unchanged

### Allowed Without New Manifest

- Private code refactoring (`_` prefix)
- Internal logic changes not affecting public API
- Code quality improvements (splitting functions, extracting helpers)

### Requirements

- All tests must continue to pass (`maid test`)
- All validations must pass (`maid validate`)
- Public API must remain unchanged

---

## Phase 4: Integration

### Final Validation

```bash
maid validate        # Validate ALL manifests
maid test            # Run ALL validation commands
pytest tests/ -v     # Full test suite (Python)
npm test             # Full test suite (TypeScript)
```

---

## Handling Prerequisite Discovery

### The Challenge

When implementing a task, you may discover that the validator or system can't handle something required by your task.

### The MAID-Compliant Solution

**What NOT to do:**
- Create workarounds in tests (artificial assertions)
- Document limitations and continue
- Modify the manifest to hide the problem

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

---

## Definition of Done

A task is NOT complete until BOTH validation commands pass with ZERO errors or warnings:

```bash
maid validate <manifest-path>  # Must pass 100%
maid test                       # Must pass 100%
```

Partial completion is not acceptable. All errors must be fixed before proceeding to the next task.

---

## Key Principle: No Partial Solutions

Every task must complete fully with all validations passing. If validation fails, either:

1. Fix the test (if test is wrong)
2. Fix the implementation (if implementation is wrong)
3. Fix the prerequisite (if system limitation discovered)

Never leave a task partially complete or with failing validations.

---

## TDD Workflow Summary

The MAID workflow embodies TDD at two levels:

### Planning Loop (Micro TDD)
- Iterative test-manifest refinement
- Tests and manifest evolve together
- Red phase verification before implementation

### Overall Workflow (Macro TDD)
1. **Red**: Tests fail (no implementation)
2. **Green**: Implementation passes tests
3. **Refactor**: Improve code quality

---

## Manual Workflow (Without Subagents)

If subagents cannot be used, follow this manual process:

1. Create manifest in `manifests/task-001-<description>.manifest.json`
2. Write behavioral tests in `tests/test_task_001_*.py` or `tests/test_task_001_*.test.ts`
3. Validate: `maid validate manifests/task-001-<description>.manifest.json --validation-mode behavioral`
4. Implement the code
5. Run tests to verify: `maid test`

**Note**: Manual execution is less reliable than using subagents. Subagents have specialized instructions for each phase.
