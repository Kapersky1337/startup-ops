<h1 align="center">Startup Ops</h1>
<p align="center">
  <strong>Connect Claude to the tools your startup uses every day.</strong><br>
  14 integrations. One setup. No code required.
</p>
<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License"></a>
  <img src="https://img.shields.io/badge/integrations-14-blue" alt="14 Integrations">
  <a href="SECURITY.md"><img src="https://img.shields.io/badge/security-auditable-brightgreen" alt="Security"></a>
</p>

---

## What is this?

A [Claude Code Plugin](https://docs.anthropic.com/en/docs/claude-code/plugins) that connects Claude to 14 tools startups use every day. After a one-time setup, you can ask Claude things like:

> "Show me all open Linear issues assigned to me"  
> "Summarize yesterday's Granola meeting"  
> "Search Slack for messages about the product launch"  
> "What's on my calendar tomorrow?"  
> "Create a Notion page with our Q1 OKRs"  
> "Find the latest deal updates in HubSpot"

No coding required. The setup script walks you through everything.

---

## Install

### For non-technical users

1. **Open Terminal** -- on Mac, press `Cmd + Space`, type "Terminal", press Enter.

2. **Clone this repo:**
   ```bash
   git clone https://github.com/Kapersky1337/startup-ops.git
   ```

3. **Run setup:**
   ```bash
   bash startup-ops/skills/startup-ops/scripts/setup.sh
   ```
   The script shows you a list of integrations, lets you pick the ones you want, then asks for your API keys (with links to get each one). It saves everything locally on your machine.

4. **Load into Claude Code:**
   ```bash
   claude --plugin-dir ./startup-ops
   ```

5. **Restart Claude Code.** Done.

### For developers

**Plugin directory (quick test):**
```bash
git clone https://github.com/Kapersky1337/startup-ops.git
claude --plugin-dir ./startup-ops
bash startup-ops/skills/startup-ops/scripts/setup.sh
```

**Marketplace (permanent install, inside Claude Code):**
```
/plugin marketplace add Kapersky1337/startup-ops
/plugin install startup-ops
```

**Manual skill copy (no plugin system):**
```bash
git clone https://github.com/Kapersky1337/startup-ops.git /tmp/startup-ops
cp -r /tmp/startup-ops/skills/startup-ops ~/.claude/skills/startup-ops
bash ~/.claude/skills/startup-ops/scripts/setup.sh
```

**Preview without writing anything:**
```bash
bash startup-ops/skills/startup-ops/scripts/setup.sh --dry-run
```

---

## Integrations

| # | Integration | Category | What Claude can do | Key required? |
|---|-------------|----------|-------------------|---------------|
| 1 | **Slack** | Communication | Read/send messages, search conversations, manage channels | Yes |
| 2 | **HubSpot** | CRM | Manage contacts, companies, deals, tickets | Yes |
| 3 | **Linear** | Project management | Create/update issues, manage sprints, track projects | Yes |
| 4 | **Notion** | Documentation | Read/write pages, query databases, manage wikis | Yes |
| 5 | **Telegram** | Communication | Send/receive messages, manage groups and bots | Yes |
| 6 | **Otter.ai** | Meetings | Search and download meeting transcripts | Yes |
| 7 | **Granola** | Meetings | Access meeting notes, summaries, action items | Yes |
| 8 | **Google Calendar** | Scheduling | View/create events, check availability | Yes |
| 9 | **Google Drive** | File storage | Search, read, and manage files | Yes |
| 10 | **GitHub** | Development | Repos, PRs, issues, code search | Yes |
| 11 | **Brave Search** | Research | Real-time web search | Yes |
| 12 | **Zapier** | Automation | Connect 6,000+ apps via workflows | Yes |
| 13 | **Memory** | Utility | Persistent knowledge graph across chats | **No** |
| 14 | **Sequential Thinking** | Utility | Multi-step reasoning and problem decomposition | **No** |

---

## API Key Reference

Every key stays on your machine. The setup script will prompt you for each one, but here's the full reference so you can prepare ahead of time.

---

### Slack

| Variable | Description |
|----------|-------------|
| `SLACK_BOT_TOKEN` | Bot User OAuth Token (`xoxb-...`) |
| `SLACK_TEAM_ID` | Your workspace's Team ID |

**How to get it:**
1. Go to [api.slack.com/apps](https://api.slack.com/apps) and click **Create New App**.
2. Choose **From scratch**, name it (e.g. "Claude"), select your workspace.
3. Go to **OAuth & Permissions** in the sidebar.
4. Under **Scopes > Bot Token Scopes**, add: `channels:history`, `channels:read`, `chat:write`, `users:read`.
5. Click **Install to Workspace** and copy the **Bot User OAuth Token**.
6. Your Team ID is in your workspace URL: `https://app.slack.com/client/TXXXXXXXX` -- that `T` string is it.

---

### HubSpot

| Variable | Description |
|----------|-------------|
| `HUBSPOT_ACCESS_TOKEN` | Private App access token |

**How to get it:**
1. Go to [developers.hubspot.com](https://developers.hubspot.com) and log in.
2. Open your account, go to **Settings > Integrations > Private Apps**.
3. Click **Create a private app**, name it, and select the scopes you need (contacts, deals, etc.).
4. Click **Create app** and copy the access token.

---

### Linear

| Variable | Description |
|----------|-------------|
| `LINEAR_API_KEY` | Personal API key |

**How to get it:**
1. Go to [linear.app/settings/api](https://linear.app/settings/api).
2. Under **Personal API Keys**, click **Create key**.
3. Name it (e.g. "Claude") and copy the key.

---

### Notion

| Variable | Description |
|----------|-------------|
| `NOTION_TOKEN` | Integration token (`secret_...`) |

**How to get it:**
1. Go to [notion.so/my-integrations](https://www.notion.so/my-integrations).
2. Click **New integration**, name it, select your workspace.
3. Copy the **Internal Integration Secret**.
4. **Important:** Go to each Notion page/database you want Claude to access, click `...` > **Connections** > **Connect to** > your integration.

---

### Telegram

| Variable | Description |
|----------|-------------|
| `TELEGRAM_BOT_TOKEN` | Bot token from BotFather |
| `TELEGRAM_API_ID` | *(optional)* API ID for user-mode features |
| `TELEGRAM_API_HASH` | *(optional)* API hash for user-mode features |

**How to get it:**
1. Open Telegram and message [@BotFather](https://t.me/botfather).
2. Send `/newbot`, follow the prompts to name your bot.
3. BotFather will send you the token. Copy it.
4. *(Optional)* For user-mode features, register at [my.telegram.org/apps](https://my.telegram.org/apps).

---

### Otter.ai

| Variable | Description |
|----------|-------------|
| `OTTER_EMAIL` | Your Otter.ai account email |
| `OTTER_PASSWORD` | Your Otter.ai account password |

**How to get it:**
Use the email and password you log into [otter.ai](https://otter.ai) with.

---

### Granola

| Variable | Description |
|----------|-------------|
| `GRANOLA_API_TOKEN` | API token |

**How to get it:**
1. Go to [granola.ai/settings](https://granola.ai/settings).
2. Navigate to the **API** section.
3. Generate and copy your API token.

---

### Google Calendar

| Variable | Description |
|----------|-------------|
| `GOOGLE_CLIENT_ID` | OAuth 2.0 Client ID |
| `GOOGLE_CLIENT_SECRET` | OAuth 2.0 Client Secret |
| `GOOGLE_REFRESH_TOKEN` | OAuth 2.0 Refresh Token |

**How to get it:**
1. Go to [console.cloud.google.com](https://console.cloud.google.com).
2. Create a new project (or use an existing one).
3. Go to **APIs & Services > Library**, search for "Google Calendar API", and enable it.
4. Go to **APIs & Services > Credentials**, click **Create Credentials > OAuth 2.0 Client ID**.
5. Set Application Type to **Desktop app**, name it, and click Create.
6. Copy the **Client ID** and **Client Secret**.
7. To get a Refresh Token, use the [OAuth 2.0 Playground](https://developers.google.com/oauthplayground/) or run the consent flow described in [Google's OAuth guide](https://developers.google.com/identity/protocols/oauth2).

---

### Google Drive

| Variable | Description |
|----------|-------------|
| `GOOGLE_CLIENT_ID` | Same as Google Calendar |
| `GOOGLE_CLIENT_SECRET` | Same as Google Calendar |
| `GOOGLE_REFRESH_TOKEN` | Same as Google Calendar |

**How to get it:**
Use the same Google Cloud project as Calendar. Just also enable the **Google Drive API** in the API Library.

---

### GitHub

| Variable | Description |
|----------|-------------|
| `GITHUB_TOKEN` | Personal Access Token (classic or fine-grained) |

**How to get it:**
1. Go to [github.com/settings/tokens](https://github.com/settings/tokens).
2. Click **Generate new token** (classic is simpler).
3. Select the scopes you need: `repo`, `read:org`, `read:user` at minimum.
4. Generate and copy the token.

---

### Brave Search

| Variable | Description |
|----------|-------------|
| `BRAVE_API_KEY` | Search API key |

**How to get it:**
1. Go to [brave.com/search/api](https://brave.com/search/api/).
2. Click **Get API Key** and create an account.
3. The free tier gives you 2,000 queries/month.
4. Copy your API key from the dashboard.

---

### Zapier

| Variable | Description |
|----------|-------------|
| `ZAPIER_MCP_API_KEY` | MCP API key |

**How to get it:**
1. Go to [zapier.com/mcp](https://zapier.com/mcp).
2. Connect your Zapier account.
3. Copy the MCP API key provided.

---

### Memory

No API key required. Works out of the box. Stores a knowledge graph locally so Claude can remember things across conversations.

### Sequential Thinking

No API key required. Works out of the box. Helps Claude break down complex problems into structured reasoning steps.

---

## Security

**This plugin does not install software, download packages, or transmit your API keys.**

It writes a JSON config file that Claude reads on startup. That's it.

- Your API keys are stored locally at `~/.startup-ops.env` with `600` permissions (readable only by you).
- Six of the fourteen MCP packages are published by [Anthropic](https://github.com/anthropics/anthropic-mcp-servers) (the maker of Claude). Four are from official vendors (HubSpot, Notion, Google).
- The setup script is 100% auditable bash. No minified code, no obfuscation.

Full details: [SECURITY.md](SECURITY.md)

---

## Project structure

```
startup-ops/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── skills/
│   └── startup-ops/
│       ├── SKILL.md              # Skill definition (Claude reads this)
│       ├── scripts/
│       │   └── setup.sh          # Interactive setup (writes config only)
│       └── resources/
│           ├── mcp-registry.json # All 14 MCP server configs
│           ├── env-template.env  # API key template
│           └── quickstart-guide.md
├── SECURITY.md
├── README.md
└── LICENSE
```

---

## FAQ

**Do I need to know how to code?**  
No. The setup script walks you through everything with numbered steps.

**Is this safe?**  
Yes. The setup script only writes a config file. It does not install, download, or execute anything. [Full security details](SECURITY.md).

**What if I don't have all the API keys?**  
Skip any you don't have. You can run the setup again later to add more.

**Can I use this with Claude Desktop (not Claude Code)?**  
Yes. The setup script writes to Claude Desktop's config file by default.

**How do I update?**  
```bash
cd startup-ops && git pull
```

**How do I remove an integration?**  
Run the setup script again and deselect what you don't want. Or edit `~/Library/Application Support/Claude/claude_desktop_config.json` directly.

**Where are my API keys stored?**  
Locally at `~/.startup-ops.env` (only readable by you) and in Claude's config file. Never transmitted anywhere.

---

## Contributing

1. Add the server config to `skills/startup-ops/resources/mcp-registry.json`
2. Test: `bash skills/startup-ops/scripts/setup.sh --dry-run`
3. Submit a pull request

---

## License

[MIT](LICENSE)
