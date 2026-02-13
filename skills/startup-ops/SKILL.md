---
name: startup-ops
description: "Startup Ops Skill Pack — installs and configures 14 MCP servers for business operations: Slack, HubSpot, Linear, Notion, Telegram, Otter.ai, Granola, Google Calendar, GitHub, and more."
---

# Startup Ops — MCP Skill Pack

A curated bundle of 14 MCP (Model Context Protocol) servers that connect Claude to the tools startups use every day — CRM, project management, team chat, meeting notes, calendars, docs, and more.

## Included Integrations

**Communication**
- Slack — Read and send messages, manage channels, search conversations
- Telegram — Send and receive messages, manage groups and bots

**CRM & Sales**
- HubSpot — Manage contacts, companies, deals, and tickets

**Project Management**
- Linear — Create and update issues, manage sprints, track projects

**Documentation**
- Notion — Read and write pages, query databases, manage wikis

**Meetings**
- Otter.ai — Search and download meeting transcripts and audio
- Granola — Access meeting notes, summaries, and action items

**Productivity**
- Google Calendar — View and create events, check availability, schedule meetings
- Google Drive — Search, read, and manage files and folders

**Development**
- GitHub — Manage repositories, issues, pull requests, and code search

**Research**
- Brave Search — Real-time web search for competitive intelligence and research

**Utilities**
- Memory — Persistent knowledge graph across conversations (no API key required)
- Zapier — Connect 6,000+ apps with automated workflows
- Sequential Thinking — Break down complex problems step by step (no API key required)

## Setup

Run the setup script to select which integrations to enable and enter your API keys:

```bash
bash scripts/setup.sh
```

The script will walk you through:
1. Selecting which MCPs to install (all enabled by default)
2. Entering API keys for each service (with links to where to find them)
3. Writing the configuration to Claude's settings
4. Validating the setup

For detailed setup instructions, see [resources/quickstart-guide.md](resources/quickstart-guide.md).

## API Key Reference

| Service | Where to create your key |
|---------|--------------------------|
| Slack | https://api.slack.com/apps — Create App, then OAuth & Permissions |
| HubSpot | https://developers.hubspot.com — Private Apps |
| Linear | https://linear.app/settings/api — Personal API Keys |
| Notion | https://www.notion.so/my-integrations — New Integration |
| Telegram | Message @BotFather on Telegram with /newbot |
| Otter.ai | Your Otter.ai login email and password |
| Granola | https://granola.ai/settings — API Keys |
| Google Calendar | https://console.cloud.google.com — Calendar API, OAuth credentials |
| Google Drive | Same Google Cloud project — Drive API, OAuth credentials |
| GitHub | https://github.com/settings/tokens — Personal Access Token |
| Brave Search | https://brave.com/search/api/ — Get API Key |
| Zapier | https://zapier.com/mcp — Connect Account |
| Memory | No key required |
| Sequential Thinking | No key required |

## Example Prompts

Once configured, you can ask Claude:

- "Show me all open Linear issues assigned to me"
- "Summarize yesterday's meeting notes from Granola"
- "Find the latest deal updates in HubSpot"
- "Search Slack for messages about the product launch"
- "What's on my calendar for tomorrow?"
- "Create a Notion page with our Q1 OKRs"
- "Search the web for competitor pricing"

## Reconfiguration

To add, remove, or update integrations, run the setup script again:

```bash
bash ~/.claude/skills/startup-ops/scripts/setup.sh
```

## Troubleshooting

**"Command not found: node"**
Install Node.js 18 or newer from https://nodejs.org, or run `brew install node` on macOS.

**"MCP server failed to start"**
Check that your API key is correct in `~/.claude/claude_desktop_config.json` and restart Claude.

**"Permission denied"**
Run `chmod +x ~/.claude/skills/startup-ops/scripts/setup.sh` and try again.
