# Security

## What this plugin does

Startup Ops is a **configuration-only** Claude Code plugin. It writes a JSON config file that tells Claude Code which MCP servers to use and what API keys to pass to them.

## What it does NOT do

- **Does not install software.** The setup script writes a config file. It does not download, compile, or install any packages.
- **Does not execute remote code.** No scripts are fetched or run from the internet.
- **Does not transmit your API keys.** Your keys are stored locally on your machine in `~/.startup-ops.env` with `600` permissions (readable only by your user account).
- **Does not modify system files.** The only files it writes are Claude's config file and the local `.env` file.

## How MCP servers run

When Claude Code starts, it reads its config and launches MCP servers using `npx`. Each server is an npm package fetched by `npx` at runtime. The packages referenced in this plugin are:

| Package | Publisher | Source |
|---------|-----------|--------|
| `@anthropic-ai/mcp-server-slack` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@anthropic-ai/mcp-server-github` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@anthropic-ai/mcp-server-gdrive` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@anthropic-ai/mcp-server-brave-search` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@anthropic-ai/mcp-server-memory` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@anthropic-ai/mcp-server-sequential-thinking` | Anthropic | [GitHub](https://github.com/anthropics/anthropic-mcp-servers) |
| `@hubspot/mcp-server` | HubSpot | [npm](https://www.npmjs.com/package/@hubspot/mcp-server) |
| `@notionhq/notion-mcp-server` | Notion | [npm](https://www.npmjs.com/package/@notionhq/notion-mcp-server) |
| `@google/calendar-mcp` | Google | [npm](https://www.npmjs.com/package/@google/calendar-mcp) |
| `mcp-linear` | Linear community | [npm](https://www.npmjs.com/package/mcp-linear) |
| `@pab1it0/telegram-mcp` | Community | [npm](https://www.npmjs.com/package/@pab1it0/telegram-mcp) |
| `otter-mcp` | Community | [npm](https://www.npmjs.com/package/otter-mcp) |
| `granola-mcp` | Community | [npm](https://www.npmjs.com/package/granola-mcp) |
| `mcp-server-zapier` | Zapier community | [npm](https://www.npmjs.com/package/mcp-server-zapier) |

Six of the fourteen packages are published by Anthropic, the maker of Claude. Four are published by the official service provider (HubSpot, Notion, Google). The remaining four are open-source community packages.

## API key storage

- Keys are stored in `~/.startup-ops.env` with Unix permissions `600` (owner read/write only).
- Keys are also written into Claude's config file at `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) because Claude Code reads them from there at startup.
- Keys are **never** transmitted by this plugin. Each MCP server uses the keys locally to authenticate with its respective API.

## Reviewing the code

This plugin is fully open source. Every file is readable:

- [setup.sh](skills/startup-ops/scripts/setup.sh) -- the setup script (bash)
- [mcp-registry.json](skills/startup-ops/resources/mcp-registry.json) -- the list of MCP packages
- [SKILL.md](skills/startup-ops/SKILL.md) -- the skill definition Claude reads

## Reporting issues

If you find a security issue, please open a GitHub issue or email the maintainer directly. Do not post API keys or credentials in issues.
