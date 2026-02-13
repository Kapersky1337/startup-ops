# Startup Ops — Quickstart Guide

A step-by-step guide for getting set up, written for people who don't live in a terminal.

---

## Prerequisites

1. **A computer** running macOS, Windows, or Linux.
2. **Node.js 18 or newer** — download from https://nodejs.org (click the LTS button).
3. **Claude Desktop** or **Claude Code** — download from https://claude.ai/download.
4. **API keys** for the services you want to connect (instructions below).

---

## Installation

### Step 1: Open a terminal

- **macOS:** Press Cmd + Space, type "Terminal", press Enter.
- **Windows:** Press Win + R, type "cmd", press Enter.
- **Linux:** Press Ctrl + Alt + T.

### Step 2: Verify Node.js is installed

Type this and press Enter:

```
node --version
```

You should see `v18.x.x` or higher. If not, install Node.js from https://nodejs.org.

### Step 3: Install the skill

```bash
git clone https://github.com/Kapersky1337/startup-ops.git ~/.claude/skills/startup-ops
```

### Step 4: Run the setup script

```bash
bash ~/.claude/skills/startup-ops/scripts/setup.sh
```

The script will:
1. Check that Node.js and npm are available.
2. Show a list of integrations and let you pick which to enable.
3. Ask for your API keys (with links to where to find them).
4. Write the configuration into Claude's settings.

### Step 5: Restart Claude

Close and reopen Claude Desktop or restart Claude Code. Your integrations are now active.

---

## Getting API Keys

You only need keys for the services you actually use.

### Slack
1. Go to https://api.slack.com/apps.
2. Click "Create New App" > "From scratch."
3. Name it something like "Claude AI" and select your workspace.
4. Under OAuth & Permissions, add these Bot Token Scopes: `channels:history`, `channels:read`, `chat:write`, `users:read`.
5. Click "Install to Workspace."
6. Copy the Bot User OAuth Token (starts with `xoxb-`).

### HubSpot
1. Go to https://developers.hubspot.com.
2. Navigate to Apps > Private Apps.
3. Create a private app with CRM read/write scopes.
4. Copy the Access Token.

### Linear
1. Go to https://linear.app/settings/api.
2. Under Personal API Keys, click "Create key."
3. Copy the key.

### Notion
1. Go to https://www.notion.so/my-integrations.
2. Click "New integration."
3. Copy the Internal Integration Secret (starts with `secret_`).
4. Go to any Notion page you want Claude to access, click "..." > "Connections" > add your integration.

### Telegram
1. Open Telegram and search for @BotFather.
2. Send `/newbot` and follow the prompts.
3. Copy the API token.

### Otter.ai
Use your Otter.ai login email and password.

### Granola
1. Go to https://granola.ai and log in.
2. Navigate to Settings > API Keys.
3. Create and copy a key.

### Google Calendar and Google Drive
Both share the same credentials:
1. Go to https://console.cloud.google.com.
2. Create a project (or use an existing one).
3. Enable the Calendar API and Drive API.
4. Go to Credentials > Create Credentials > OAuth client ID.
5. Choose "Desktop app."
6. Copy the Client ID and Client Secret.
7. Complete the OAuth consent flow to get a Refresh Token.

### GitHub
1. Go to https://github.com/settings/tokens.
2. Click "Generate new token (classic)."
3. Enable the `repo` and `read:org` scopes.
4. Copy the token (starts with `ghp_`).

### Brave Search
1. Go to https://brave.com/search/api/.
2. Sign up (there's a free tier).
3. Copy your API key.

### Zapier
1. Go to https://zapier.com/mcp.
2. Connect your account.
3. Copy the MCP API key.

---

## Frequently Asked Questions

**Do I need all 14 integrations?**
No. The setup script lets you pick only the ones you use.

**Is this secure?**
API keys are stored locally on your computer at `~/.startup-ops.env` with restricted file permissions. They are not transmitted anywhere except to the services you connect to.

**Can I add more integrations later?**
Yes. Run the setup script again and select additional services.

**What if I change an API key?**
Run the setup script again, or edit `~/.startup-ops.env` directly and restart Claude.

**How do I update to the latest version?**
Run `cd ~/.claude/skills/startup-ops && git pull`.

---

## Need Help?

Ask Claude: "Help me set up Startup Ops" — Claude has access to this skill and can walk you through the process interactively.
