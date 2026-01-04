#!/bin/bash
set -e

# Check if uv is installed
if ! command -v uv &>/dev/null; then
  echo "ERROR: uv is required but not installed"
  echo "Install from: https://github.com/astral-sh/uv"
  exit 1
fi

# Check if maid-runner is already installed (idempotency)
if uv pip show maid-runner &>/dev/null; then
  exit 0  # Silent success if already installed
fi

# Install maid-runner
echo "📦 Installing maid-runner from PyPI..."
if uv pip install maid-runner; then
  echo "✓ maid-runner installed successfully"
  exit 0
else
  echo "✗ Failed to install maid-runner"
  exit 1
fi
