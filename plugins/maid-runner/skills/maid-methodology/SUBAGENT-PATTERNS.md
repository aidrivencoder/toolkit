# MAID Subagent Invocation Patterns

Detailed patterns for invoking MAID subagents using the Task tool.

## Contents

- Why Subagents Are Required
- Subagent Reference (table of all 7 subagents)
- Pattern 1: Complete MAID Workflow (Feature Request)
- Pattern 2: Fix Failing Validation
- Pattern 3: Improve Code Quality
- Pattern 4: Compliance Audit
- Pattern 5: Bug Fix
- Common Delegation Examples
- Task Tool Invocation Format

---

## Why Subagents Are Required

- Each subagent has specialized instructions for its phase
- Subagents ensure consistent application of MAID rules
- Subagents reference the correct documentation
- Subagents run the correct validation commands at the right time

---

## Subagent Reference

| Subagent | Phase | Purpose | Key Responsibilities |
|----------|-------|---------|---------------------|
| `maid-runner:maid-manifest-architect` | Phase 1 | Create manifests | Find next task number, create manifest, validate schema |
| `maid-runner:maid-plan-reviewer` | Phase 1-2 Gate | Review before implementation | Verify manifest completeness, check test coverage |
| `maid-runner:maid-test-designer` | Phase 2 | Create behavioral tests | Follow unit-testing-rules.md, USE artifacts, ASSERT behavior |
| `maid-runner:maid-developer` | Phase 3 | Implement code (TDD) | Confirm red phase, implement to pass tests, validate |
| `maid-runner:maid-fixer` | Phase 3 Support | Fix errors | Identify issue, fix one at a time, re-validate |
| `maid-runner:maid-refactorer` | Phase 3.5 | Improve code quality | Maintain tests passing, apply clean code principles |
| `maid-runner:maid-auditor` | Cross-cutting | Enforce compliance | Check immutability, verify artifacts, audit manifests |

---

## Pattern 1: Complete MAID Workflow (Feature Request)

```
User: "Add a user authentication module"

1. INVOKE maid-runner:maid-manifest-architect subagent via Task tool:
   → subagent_type: "maid-runner:maid-manifest-architect"
   → prompt: "Create manifest for user authentication module"
   → Subagent creates manifests/task-XXX-user-auth.manifest.json
   → Subagent runs: maid validate --use-manifest-chain

2. INVOKE maid-runner:maid-test-designer subagent via Task tool:
   → subagent_type: "maid-runner:maid-test-designer"
   → prompt: "Create behavioral tests for task-XXX"
   → Subagent reads unit-testing-rules.md
   → Subagent creates tests/test_task_XXX_user_auth.py
   → Subagent runs: maid validate --validation-mode behavioral

3. INVOKE maid-runner:maid-developer subagent via Task tool:
   → subagent_type: "maid-runner:maid-developer"
   → prompt: "Implement code to pass tests for task-XXX"
   → Subagent implements src/auth.py
   → Subagent runs: maid validate && pytest

4. Final validation:
   → maid validate && maid test
```

---

## Pattern 2: Fix Failing Validation

```
User: "The validation is failing, please fix it"

INVOKE maid-runner:maid-fixer subagent via Task tool:
→ subagent_type: "maid-runner:maid-fixer"
→ prompt: "Fix validation errors for task-XXX"
→ Subagent reads validation error output
→ Subagent identifies specific issue
→ Subagent fixes one issue at a time
→ Subagent re-runs: maid validate <path>
→ Repeats until all issues resolved
```

---

## Pattern 3: Improve Code Quality

```
User: "Refactor the implementation to improve code quality"

INVOKE maid-runner:maid-refactorer subagent via Task tool:
→ subagent_type: "maid-runner:maid-refactorer"
→ prompt: "Improve code quality for [file/module]"
→ Subagent reviews current implementation
→ Subagent applies clean code principles
→ Subagent runs tests after each change
→ Subagent ensures: maid validate passes
```

---

## Pattern 4: Compliance Audit

```
User: "Check if the code follows MAID methodology"

INVOKE maid-runner:maid-auditor subagent via Task tool:
→ subagent_type: "maid-runner:maid-auditor"
→ prompt: "Audit MAID compliance for the codebase"
→ Subagent reviews all manifests
→ Subagent checks for immutability violations
→ Subagent verifies artifact declarations
→ Subagent runs: maid validate
→ Subagent reports compliance status
```

---

## Pattern 5: Bug Fix

```
User: "Fix the login bug where users can't authenticate"

1. INVOKE maid-runner:maid-manifest-architect subagent:
   → Create manifest for the bug fix (bugs need manifests too!)

2. INVOKE maid-runner:maid-test-designer subagent:
   → Write test that reproduces the bug (should fail initially)

3. INVOKE maid-runner:maid-developer subagent:
   → Implement fix to pass the test

4. Final validation:
   → maid validate && maid test
```

---

## Common Delegation Examples

### User asks to add a feature

```
1. → Invoke maid-runner:maid-manifest-architect subagent to create the manifest
2. → Invoke maid-runner:maid-test-designer subagent to create tests
3. → Invoke maid-runner:maid-developer subagent to implement
```

### User asks to fix a bug

```
1. → Invoke maid-runner:maid-manifest-architect subagent (bug fixes need manifests too)
2. → Invoke maid-runner:maid-test-designer subagent (write test that reproduces bug)
3. → Invoke maid-runner:maid-developer subagent to fix
```

### Validation fails

```
→ Invoke maid-runner:maid-fixer subagent to identify and fix the issue
```

### User asks to refactor

```
→ Invoke maid-runner:maid-refactorer subagent to improve code quality
```

---

## Task Tool Invocation Format

```
Task tool parameters:
- subagent_type: "maid-runner:maid-manifest-architect" (or other maid-runner agent)
- prompt: "Create a manifest for [goal]"
- description: "Phase 1: Create manifest"
```

Always use the fully qualified subagent name with `maid-runner:` prefix from the table above.
