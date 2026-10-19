# Deploy and Host OpenWorker on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/openworker?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=openworker)

[OpenWorker](https://github.com/andrewyng/openworker) is an open-source AI coworker. It's MIT-licensed and comes from the `andrewyng` GitHub organization. You give it an outcome, such as a security review of a repo, a report from your CRM, or a reply in a Slack thread. It plans the steps, uses your tools, checks in before anything consequential, and delivers the finished file or message. It works with any model: OpenAI, Anthropic, Gemini, DeepSeek, Qwen, Kimi, Mistral, Grok, OpenRouter and more. It connects to 25+ apps (GitHub, Slack, Jira, Notion, Linear, HubSpot, Gmail, Google Calendar and others) plus any MCP server.

The official builds are desktop apps for macOS and Windows. This template runs the same agent server and the same React interface as a web app on Railway. It keeps running while your laptop is closed, so scheduled automations and Slack mentions get answered at any hour.

## About Hosting OpenWorker

It's one service with a Railway volume. Sessions, settings, model keys, connector tokens, memory and the agent's workspace all live on the volume at `/data`.

- **Password-protected web app.** Open the Railway domain and sign in with `OPENWORKER_USER` and `OPENWORKER_PASSWORD`, which is generated at deploy.
- **API locked as well.** The OpenWorker server requires an API token on every call and WebSocket. A fresh token is created at each boot, and the gateway hands it to the browser only after the password check. Nothing reaches the agent without both.
- **Its own Linux box.** The agent's shell and file tools run inside this container, with `git`, `curl`, `ripgrep` and Python available. They work in `/data/workspace`, so cloned repos and generated files survive redeploys.
- **Pinned release.** The image builds OpenWorker `v0.3.1` from source, the server plus the web interface. To upgrade, change `OPENWORKER_VERSION` in the Dockerfile of your fork.

## Common Use Cases

- An always-on AI coworker for scheduled automations: a morning brief, a weekly GitHub progress report posted to Slack, a standing watch over a channel
- Security review of repositories: deterministic scanners plus model reasoning, with fixes you approve
- A shared agent box that a team opens from any browser, instead of each person running a desktop app

## Dependencies for OpenWorker Hosting

- An API key for at least one model provider, added in **Settings → Models & Keys**
- Optional: API keys or tokens for the apps you want to connect (GitHub, Slack, Notion, Linear and others)

### Deployment Dependencies

- [OpenWorker on GitHub](https://github.com/andrewyng/openworker)
- [Headless runs and approval modes](https://github.com/andrewyng/openworker/blob/main/docs/headless.md)
- [Template source on GitHub](https://github.com/two-workspaces/openworker)

### Implementation Details

**First steps.**

1. Open the service's Railway domain and sign in.
2. Go to **Settings → Models & Keys** and paste a model key. The model picker in the composer then lists that provider's models.
3. Ask for something real. A new session starts in `/data/workspace`.

**Approvals.** By default the agent asks before writes, sends and shell commands (**Ask for approval** in the composer). Auto-approve lets a reviewer model pass routine actions and still escalates anything it's unsure about.

**Connectors.** Use API keys or personal access tokens in **Settings → Connectors**. Connections that need the OpenWorker cloud sign-in (managed OAuth) are built for the desktop app's local callback and may not finish on a hosted domain. Use the manual credential option instead.

**Slack and Telegram.** The Slack and Telegram bridges are included. Connect Slack in Settings and mention `@OpenWorker` in a channel. The session runs on this server and replies in the thread.

**Sandbox.** The desktop app can wrap the agent's commands in NVIDIA OpenShell, the macOS sandbox, or a Windows account. Those aren't available here. The Railway container itself is the boundary: the agent can read anything in it, including its own stored keys. Give it keys scoped to what it should touch.

**Resources.** Measured on Railway, the server and gateway idle at about 100 MB of RAM with near-zero CPU, so it fits every Railway plan. Usage grows with what the agent runs in its shell, for example cloning and scanning a large repository.

## Why Deploy OpenWorker on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying OpenWorker on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
