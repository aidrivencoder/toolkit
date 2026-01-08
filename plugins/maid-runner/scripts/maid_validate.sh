#!/bin/bash

# MAID Validation Hook Script
# Runs `uv run maid validate` when supported files are modified via Write or Edit tools

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from the tool input
# For Write tool: {"file_path": "...", "content": "..."}
# For Edit tool: {"file_path": "...", "old_string": "...", "new_string": "..."}
FILE_PATH=$(echo "$INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]+' | head -1)

# If no file path found, exit silently
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get the file extension
EXTENSION="${FILE_PATH##*.}"

# Supported extensions for MAID Runner (Python and TypeScript/JavaScript)
case ".$EXTENSION" in
    .py|.ts|.tsx|.js|.jsx|.svelte)
        # Check if uv is installed
        if ! command -v uv &>/dev/null; then
            echo "Warning: uv not installed, skipping MAID validation" >&2
            exit 0
        fi

        # Check if maid-runner is installed
        if ! uv pip show maid-runner &>/dev/null 2>&1; then
            echo "Warning: maid-runner not installed, skipping validation" >&2
            exit 0
        fi

        # Run MAID validation
        echo "🔍 Running MAID validation for $FILE_PATH..."
        if uv run maid validate 2>&1; then
            echo "✓ MAID validation passed"
            exit 0
        else
            # Exit code 2 blocks and provides feedback to Claude
            echo "MAID validation failed. Please review the manifest compliance." >&2
            exit 2
        fi
        ;;
    *)
        # Not a supported file extension, skip silently
        exit 0
        ;;
esac
