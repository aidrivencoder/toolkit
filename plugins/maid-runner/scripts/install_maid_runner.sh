#!/bin/bash
set -e

# Check if uv is installed
if ! command -v uv &>/dev/null; then
  echo "ERROR: uv is required but not installed"
  echo "Install from: https://github.com/astral-sh/uv"
  exit 1
fi

# Check if virtual environment exists, create if not
if [ -z "$VIRTUAL_ENV" ] && [ ! -d ".venv" ]; then
  echo "📁 No virtual environment found, creating one..."
  if uv venv; then
    echo "✓ Virtual environment created at .venv"
  else
    echo "✗ Failed to create virtual environment"
    exit 1
  fi
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
