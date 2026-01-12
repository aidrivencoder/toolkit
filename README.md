# AI-Driven Coder Claude Code Plugins

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![YouTube](https://img.shields.io/badge/YouTube-AI--Driven_Coder-red?logo=youtube)](https://www.youtube.com/@aidrivencoder)
[![Discord](https://img.shields.io/badge/Discord-Join_Community-5865F2?logo=discord)](https://aidrivencoder.com/discord)

Professional AI development tools and MCP servers from [AI-Driven Coder](https://aidrivencoder.com) - enhancing your Claude Code workflow with validation, search, and voice capabilities.

## 🚀 Quick Start

### Install the Marketplace

```bash
/plugin marketplace add aidrivencoder/toolkit
```

### Install Individual Plugins

```bash
# MAID Runner - Validation framework
/plugin install maid-runner@aidrivencoder

# MAID Runner MCP - MCP server for MAID validation
/plugin install maid-runner-mcp@aidrivencoder

# Everything Search - Fast file search
/plugin install everything-search@aidrivencoder

# ElevenLabs - Text-to-speech integration
/plugin install elevenlabs@aidrivencoder
```

## 📦 Available Plugins

### 🔍 MAID Runner (v0.9.0)

**Tool-agnostic validation framework for Manifest-driven AI Development**

Ensures your AI-generated code maintains architectural integrity by validating artifacts against declarative manifests. Supports Python 3.10+ and TypeScript/JavaScript.

```bash
/plugin install maid-runner@aidrivencoder
```

**Key Features:**
- Validates code structure against manifest specifications
- Behavioral testing integration
- Multi-language support (Python, TypeScript/JavaScript)
- Pre-commit hooks for quality enforcement

**Learn More:** [MAID Runner Repository](https://github.com/mamertofabian/maid-runner)

---

### 🔌 MAID Runner MCP (v0.1.0)

**Model Context Protocol server for MAID Runner validation tools**

Bridges AI agents with the MAID framework, enabling programmatic validation without subprocess calls. Perfect for integrating MAID methodology directly into your AI workflow.

```bash
/plugin install maid-runner-mcp@aidrivencoder
```

**Key Features:**
- MCP tools for validation and snapshots
- Direct manifest access and schema resources
- Workflow guidance prompts
- Seamless integration with Claude Code and other AI agents

**Learn More:** [MAID Runner MCP Repository](https://github.com/mamertofabian/maid-runner-mcp)

---

### 🔎 Everything Search

**Fast cross-platform file search MCP server**

Find files instantly across your entire system using platform-native search engines (Everything on Windows, locate on Linux, mdfind on macOS).

```bash
/plugin install everything-search@aidrivencoder
```

**Key Features:**
- Lightning-fast file search across entire system
- Cross-platform support (Windows, Linux, macOS)
- Regex and wildcard pattern matching
- File metadata retrieval

**Learn More:** [Everything Search Repository](https://github.com/mamertofabian/mcp-everything-search)

---

### 🎙️ ElevenLabs

**Text-to-speech MCP server for AI workflows**

Generate natural-sounding voice audio directly from your AI workflows using ElevenLabs' advanced text-to-speech technology.

```bash
/plugin install elevenlabs@aidrivencoder
```

**Key Features:**
- High-quality text-to-speech generation
- Multiple voice options
- Seamless integration with AI workflows
- Direct ElevenLabs API integration

**Learn More:** [ElevenLabs MCP Repository](https://github.com/mamertofabian/elevenlabs-mcp-server)

## 🎯 Use Cases

### For AI-Assisted Development
- **MAID Runner**: Validate that AI-generated code follows architectural patterns
- **Everything Search**: Quickly find files and references across large codebases

### For Content Creation
- **ElevenLabs**: Generate voiceovers for tutorials and documentation
- **MAID Runner**: Ensure consistent code examples in educational content

### For Workflow Automation
- **MAID Runner MCP**: Integrate validation into CI/CD pipelines
- **Everything Search**: Automate file discovery tasks

## 🛠️ Custom Commands

This marketplace includes custom slash commands to help maintain the repository:

### `/update-packages`

Automatically check PyPI for updates to maid-runner and maid-lsp packages, update version numbers in marketplace.json, commit, and push changes.

```bash
# Check for updates and apply them
/update-packages

# Dry run to see what would be updated
/update-packages --dry-run
```

**What it does:**
1. Checks PyPI for latest versions of maid-runner and maid-lsp
2. Compares with current versions in marketplace.json
3. Updates marketplace.json and plugins/maid-runner/plugin.json if needed
4. Commits changes with descriptive message
5. Pushes to repository (skipped with --dry-run)

**Requirements:** curl and jq must be installed

## 📚 Documentation

- **YouTube Channel**: [AI-Driven Coder](https://www.youtube.com/@aidrivencoder) - Tutorials and demos
- **Discord Community**: [Join the conversation](https://aidrivencoder.com/discord)
- **Website**: [aidrivencoder.com](https://aidrivencoder.com)

### Video Tutorials

Subscribe to [AI-Driven Coder](https://www.youtube.com/@aidrivencoder) for upcoming tutorials on:
- [Getting started with MAID methodology](https://youtu.be/A4_6zqPO1yQ)
- Building plugins for Claude Code - Coming soon!
- [Integrating MCP servers into your workflow](https://youtu.be/A0spAPTD4XY)

## 🤝 Contributing

These plugins are open source and welcome contributions! Each plugin has its own repository:

- [MAID Runner](https://github.com/mamertofabian/maid-runner)
- [MAID Runner MCP](https://github.com/mamertofabian/maid-runner-mcp)
- [Everything Search](https://github.com/mamertofabian/mcp-everything-search)
- [ElevenLabs MCP](https://github.com/mamertofabian/elevenlabs-mcp-server)

## 💼 Professional Services

Need custom plugin development or MAID implementation for your team?

**[Codefrost](https://codefrost.com)** offers professional services including:
- Custom Claude Code plugin development
- MAID methodology training and implementation
- AI-powered development consulting
- SaaS product development

**Contact:** [mamerto@codefrost.dev](mailto:mamerto@codefrost.dev) | [Book a call](https://calendly.com/mamerto/30min)

## 📄 License

All plugins are licensed under the MIT License. See individual repositories for details.

## 🙏 Support

If you find these plugins useful:

- ⭐ Star the repositories
- 📺 Subscribe to [AI-Driven Coder](https://www.youtube.com/@aidrivencoder)
- 💬 Join our [Discord community](https://aidrivencoder.com/discord)
- 💖 [Sponsor on GitHub](https://github.com/sponsors/mamertofabian)

---

**Created by [Mamerto Fabian](https://mamerto.codefrost.dev)** | [Codefrost](https://codefrost.com)
