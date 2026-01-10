# MAID CLI Reference

Complete command reference for MAID Runner CLI.

---

## Whole-Codebase Validation

Primary commands for validating all manifests:

```bash
# Validate ALL active manifests
maid validate

# Run ALL validation commands from manifests
maid test
```

---

## Single Manifest Validation

### Basic Validation

```bash
maid validate <path>
maid validate manifests/task-001-feature.manifest.json
```

### With Manifest Chain

Recommended for evolving codebases - merges all active manifests:

```bash
maid validate <path> --use-manifest-chain
```

### Validation Modes

**Behavioral Mode** (Phase 2 - Test Design):
```bash
maid validate <path> --validation-mode behavioral --use-manifest-chain
```
- Verifies test files USE the declared artifacts (AST-based)
- Use when writing tests before implementation

**Implementation Mode** (Phase 3 - Default):
```bash
maid validate <path> --validation-mode implementation --use-manifest-chain
```
- Verifies code DEFINES the declared artifacts
- Includes file tracking analysis
- Default mode if not specified

---

## Manifest Creation

### Basic Creation

```bash
maid manifest create <file> --goal "description"
```

### With Artifacts

```bash
maid manifest create <file> --goal "description" --artifacts '[{"type": "class", "name": "MyClass"}]'
```

### Preview First (Dry Run)

```bash
maid manifest create <file> --goal "description" --dry-run --json
```

---

## Snapshot Commands

Capture existing code baseline:

```bash
maid snapshot <file>
```

---

## Finding Manifests

Find manifests that track a specific file:

```bash
maid manifests <file>
```

---

## Test Execution

### Run All Tests

```bash
maid test
```

### Single Manifest Tests

```bash
maid test --manifest <path>
```

### Watch Mode (TDD)

```bash
# Single manifest watch
maid test --manifest <path> --watch

# Multi-manifest watch
maid test --watch-all
```

---

## Help Commands

```bash
maid --help
maid validate --help
maid manifest --help
maid test --help
```

---

## File Tracking Analysis

When using `--use-manifest-chain` in implementation mode, MAID performs automatic file tracking:

### Warning Levels

| Level | Status | Meaning | Action |
|-------|--------|---------|--------|
| High | UNDECLARED | File exists but not in any manifest | Add to manifest |
| Medium | REGISTERED | In manifest but incomplete compliance | Add expectedArtifacts |
| Clean | TRACKED | Full MAID compliance | None needed |

### Common Issues

**UNDECLARED files**: No audit trail of when/why created
- Add to `creatableFiles` or `editableFiles` in a manifest

**REGISTERED files**: Missing `expectedArtifacts`, no tests, or only in `readonlyFiles`
- Add `expectedArtifacts` and `validationCommand` for full compliance

---

## Installation

### Using pipx (recommended)

```bash
pipx install maid-runner
```

### Using pip

```bash
pip install maid-runner
```

### Using uv

```bash
# As a tool (global)
uv tool install maid-runner

# As a dev dependency (project-local)
uv add maid-runner --dev
```

### Verify Installation

```bash
maid --help
```

**Note:** MAID Runner requires Python 3.10+.
