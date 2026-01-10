# MAID Manifest Templates

Templates and examples for creating MAID manifests.

---

## Critical Rules

### expectedArtifacts is an OBJECT, not an array

- `expectedArtifacts` defines artifacts for **ONE file only**
- For multi-file tasks: Create **separate manifests** for each file
- Structure: `{"file": "...", "contains": [...]}`
- **NOT** an array of file objects

### Manifest Immutability

- Current task's manifest can be modified while actively working
- Once you move to the next task, ALL prior manifests become immutable
- NEVER modify completed task manifests

### One File Per Manifest

If your task modifies public APIs in multiple files, create separate sequential manifests:
- `task-050-update-utils.manifest.json` → modifies `utils.py`
- `task-051-update-handlers.manifest.json` → modifies `handlers.py`

---

## Python Template

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

---

## TypeScript Template

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

## Artifact Types

### Python Artifacts

| Type | Example | Notes |
|------|---------|-------|
| `function` | `def my_function():` | Top-level or class method |
| `class` | `class MyClass:` | Class definition |
| `attribute` | `self.my_attr` | Class attribute (use with `class` field) |

### TypeScript Artifacts

| Type | Example | Notes |
|------|---------|-------|
| `function` | `function myFunction()` | Named function |
| `class` | `class MyClass` | Class definition |
| `interface` | `interface MyInterface` | Interface definition |

---

## Validation Modes

### Strict Mode (creatableFiles)

Implementation must EXACTLY match `expectedArtifacts`.

Use for new files where you control the entire content.

### Permissive Mode (editableFiles)

Implementation must CONTAIN `expectedArtifacts` (allows existing code).

Use for existing files where you're adding to existing code.

---

## Artifact Rules

- **Public** (no `_` prefix): MUST be in manifest
- **Private** (`_` prefix): Optional in manifest

---

## Superseded Manifests

When a manifest is superseded:
- `maid validate` ignores it when merging manifest chains
- `maid test` does NOT execute its `validationCommand`
- Serves as historical documentation only

---

## File Deletion Pattern

```json
{
  "goal": "Remove deprecated module",
  "taskType": "refactor",
  "supersedes": ["task-010-create-module.manifest.json"],
  "creatableFiles": [],
  "editableFiles": [],
  "readonlyFiles": [],
  "expectedArtifacts": {
    "file": "path/to/deleted_file.py",
    "status": "absent"
  },
  "validationCommand": ["pytest", "tests/", "-v"]
}
```

---

## File Rename Pattern

```json
{
  "goal": "Rename module from old_name to new_name",
  "taskType": "refactor",
  "supersedes": ["task-010-create-old-name.manifest.json"],
  "creatableFiles": ["src/new_name.py"],
  "editableFiles": [],
  "readonlyFiles": [],
  "expectedArtifacts": {
    "file": "src/new_name.py",
    "contains": [
      {"type": "function", "name": "existing_function"}
    ]
  },
  "validationCommand": ["pytest", "tests/", "-v"]
}
```

---

## Snapshot to Evolution Transition

### Snapshot Phase (Initial baseline)

```json
{
  "goal": "Snapshot existing service module",
  "taskType": "snapshot",
  "expectedArtifacts": {
    "file": "src/service.py",
    "contains": [
      {"type": "function", "name": "func_1"},
      {"type": "function", "name": "func_2"},
      {"type": "function", "name": "func_3"}
    ]
  }
}
```

### Transition Manifest (First evolution)

```json
{
  "goal": "Add new feature to service",
  "taskType": "edit",
  "supersedes": ["task-015-snapshot-service.manifest.json"],
  "editableFiles": ["src/service.py"],
  "expectedArtifacts": {
    "file": "src/service.py",
    "contains": [
      {"type": "function", "name": "func_1"},
      {"type": "function", "name": "func_2"},
      {"type": "function", "name": "func_3"},
      {"type": "function", "name": "new_func"}
    ]
  },
  "validationCommand": ["pytest", "tests/test_service.py", "-v"]
}
```

### Future Evolution (Natural MAID flow)

```json
{
  "goal": "Add another feature",
  "taskType": "edit",
  "editableFiles": ["src/service.py"],
  "expectedArtifacts": {
    "file": "src/service.py",
    "contains": [
      {"type": "function", "name": "another_func"}
    ]
  },
  "validationCommand": ["pytest", "tests/test_service.py", "-v"]
}
```

With `--use-manifest-chain`, the validator merges all active manifests.

---

## Naming Convention

```
manifests/task-XXX-description.manifest.json
```

- `XXX` = Zero-padded task number (001, 002, etc.)
- `description` = Kebab-case brief description
- Must be in `manifests/` directory

Find next task number:
```bash
ls manifests/task-*.manifest.json | tail -1
```
